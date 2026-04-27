import { useEffect, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { ArrowRight, RefreshCw, AlertCircle, Search, ChevronRight, DollarSign, CheckCircle2, Clock } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { MatchBadge } from '../components/MatchBadge';
import {
  DEFAULT_STRONG_MIN,
  DEFAULT_POSSIBLE_MIN,
  scoreCaseMatch,
  tierFromScore,
} from '../lib/matching';
import type { Case, MatchTier, MatchingRule, Submission } from '../types/database';

interface CaseMatch {
  case: Case;
  tier: MatchTier;
  score: number;
  missingInfo: Array<{ fieldKey: string; label: string; reason: string }>;
}

const COMPLETED_STATUSES = new Set(['submitted', 'under_review', 'routed', 'accepted', 'rejected', 'duplicate', 'bad_contact', 'closed']);
const IN_PROGRESS_STATUSES = new Set(['in_progress']);

export default function Results() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [matches, setMatches] = useState<CaseMatch[]>([]);
  const [allCases, setAllCases] = useState<Case[]>([]);
  const [submissionMap, setSubmissionMap] = useState<Record<string, string>>({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) { navigate('/auth'); return; }
    computeMatches();
  }, [user]);

  const computeMatches = async () => {
    const [
      { data: cases },
      { data: rules },
      { data: userAnswers },
      { data: userSubs },
      { data: questions },
    ] = await Promise.all([
      supabase.from('cases').select('*').eq('status', 'active').order('priority_score', { ascending: false }),
      supabase.from('matching_rules').select('*'),
      supabase.from('answers').select('*').eq('user_id', user!.id),
      supabase.from('submissions').select('id, case_id, status, match_score, match_tier, prior_attorney_for_case').eq('user_id', user!.id),
      supabase.from('questions').select('field_key, question_text'),
    ]);

    const { data: settingsRow } = await supabase
      .from('platform_settings')
      .select('strong_match_min, possible_match_min')
      .eq('id', 1)
      .maybeSingle();

    const strongMin = settingsRow?.strong_match_min ?? DEFAULT_STRONG_MIN;
    const possibleMin = settingsRow?.possible_match_min ?? DEFAULT_POSSIBLE_MIN;
    const thresholds = { strongMatchMin: strongMin, possibleMatchMin: possibleMin };

    const map: Record<string, string> = {};
    const subsByCaseId: Record<string, { id: string; status: string; prior_attorney_for_case: boolean | null }> = {};
    for (const sub of (userSubs || []) as Pick<Submission, 'id' | 'case_id' | 'status' | 'prior_attorney_for_case'>[]) {
      map[sub.case_id] = sub.status;
      subsByCaseId[sub.case_id] = {
        id: sub.id,
        status: sub.status,
        prior_attorney_for_case: sub.prior_attorney_for_case ?? null,
      };
    }
    setSubmissionMap(map);

    if (!cases) { setLoading(false); return; }

    setAllCases(cases);

    const answerMap: Record<string, string | string[]> = {};
    (userAnswers || []).forEach(a => {
      answerMap[a.field_key] = a.answer_values?.length ? a.answer_values : (a.answer_value || '');
    });

    const allRules = (rules || []) as MatchingRule[];
    const questionLabelMap: Record<string, string> = {};
    (questions || []).forEach((q: { field_key: string; question_text: string }) => {
      questionLabelMap[q.field_key] = q.question_text;
    });

    const caseMatches: CaseMatch[] = cases.map(c => {
      const caseRules = allRules.filter(r => r.case_id === c.id);
      const caseAnswerMap = { ...answerMap };
      const sub = subsByCaseId[c.id];
      if (sub?.prior_attorney_for_case != null) {
        const boolVal = sub.prior_attorney_for_case ? 'true' : 'false';
        caseAnswerMap.prior_attorney_for_case = boolVal;
        // Backward compatibility if any rules still reference prior_attorney.
        caseAnswerMap.prior_attorney = boolVal;
      }
      const { score, disqualified } = scoreCaseMatch(caseRules, caseAnswerMap);
      const tier = tierFromScore(score, disqualified, thresholds);
      const missingInfo = caseRules
        .filter((r) => {
          const val = answerMap[r.field_key];
          return val === undefined || val === null || String(val).trim() === '';
        })
        .map((r) => ({
          fieldKey: r.field_key,
          label: questionLabelMap[r.field_key] || r.field_key,
          reason: r.description || 'Needed to evaluate eligibility for this case',
        }))
        .filter((item, index, arr) => arr.findIndex((x) => x.fieldKey === item.fieldKey) === index);

      return { case: c, tier, score, missingInfo };
    });

    const persistRows = caseMatches
      .map(m => {
        const sub = subsByCaseId[m.case.id];
        if (!sub) return null;
        return supabase
          .from('submissions')
          .update({
            match_score: m.score,
            match_tier: m.tier,
            updated_at: new Date().toISOString(),
          })
          .eq('id', sub.id);
      })
      .filter((p): p is NonNullable<typeof p> => p != null);
    if (persistRows.length) await Promise.all(persistRows);

    setMatches(
      caseMatches
        .filter(m => m.tier !== 'not_eligible')
        .sort((a, b) => b.score - a.score)
    );
    setLoading(false);
  };

  if (loading) return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  const completedCount = matches.filter(m => {
    const s = submissionMap[m.case.id];
    return s && COMPLETED_STATUSES.has(s);
  }).length;
  const inProgressCount = matches.filter(m => {
    const s = submissionMap[m.case.id];
    return s && IN_PROGRESS_STATUSES.has(s);
  }).length;
  const unstarted = matches.filter(m => !submissionMap[m.case.id]).length;

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      <div className="mb-5">
        <h1 className="text-2xl font-bold text-slate-900 mb-1">Your Matches</h1>
        <p className="text-slate-500 text-sm leading-relaxed">
          Based on your answers, here are the claims you may qualify for.
        </p>
      </div>

      {/* Progress summary strip */}
      {matches.length > 0 && (
        <div className="bg-blue-50 border border-blue-200 rounded-2xl p-4 mb-5">
          <div className="flex items-center justify-between gap-3 flex-wrap">
            <div className="flex items-center gap-4 flex-wrap">
              <div className="text-center">
                <div className="text-xl font-bold text-slate-900">{matches.length}</div>
                <div className="text-xs text-slate-500 font-medium">Potential matches</div>
              </div>
              <div className="w-px h-8 bg-blue-200 hidden sm:block" />
              <div className="text-center">
                <div className="text-xl font-bold text-emerald-700">{completedCount}</div>
                <div className="text-xs text-slate-500 font-medium">Submitted</div>
              </div>
              {inProgressCount > 0 && (
                <>
                  <div className="w-px h-8 bg-blue-200 hidden sm:block" />
                  <div className="text-center">
                    <div className="text-xl font-bold text-amber-600">{inProgressCount}</div>
                    <div className="text-xs text-slate-500 font-medium">In progress</div>
                  </div>
                </>
              )}
              {unstarted > 0 && (
                <>
                  <div className="w-px h-8 bg-blue-200 hidden sm:block" />
                  <div className="text-center">
                    <div className="text-xl font-bold text-blue-700">{unstarted}</div>
                    <div className="text-xs text-slate-500 font-medium">Not started</div>
                  </div>
                </>
              )}
            </div>
            {unstarted > 0 && (
              <p className="text-xs text-blue-700 font-semibold leading-snug max-w-[140px] text-right">
                {unstarted} claim{unstarted !== 1 ? 's' : ''} still need{unstarted === 1 ? 's' : ''} your intake →
              </p>
            )}
            {unstarted === 0 && completedCount === matches.length && (
              <p className="text-xs text-emerald-700 font-semibold">All matched claims submitted ✓</p>
            )}
          </div>
          {/* Progress bar */}
          {matches.length > 0 && (
            <div className="mt-3">
              <div className="h-1.5 bg-blue-200 rounded-full overflow-hidden">
                <div
                  className="h-full bg-emerald-500 rounded-full transition-all duration-500"
                  style={{ width: `${Math.round((completedCount / matches.length) * 100)}%` }}
                />
              </div>
              <p className="text-xs text-slate-400 mt-1">
                {Math.round((completedCount / matches.length) * 100)}% complete
              </p>
            </div>
          )}
        </div>
      )}

      {/* Matched cases */}
      {matches.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-200 p-8 text-center mb-6">
          <div className="w-14 h-14 bg-slate-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <Search size={24} className="text-slate-400" />
          </div>
          <h2 className="font-semibold text-slate-700 mb-2">No strong matches found</h2>
          <p className="text-slate-500 text-sm leading-relaxed">
            Based on your answers, we didn't find active claims that match. Browse all open cases below — you may still qualify.
          </p>
        </div>
      ) : (
        <div className="space-y-4 mb-8">
          {matches.map(m => (
            <div key={m.case.id} className="bg-white rounded-2xl border border-slate-200 p-5">
              <div className="flex items-start gap-2 mb-2">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap mb-2">
                    <h3 className="font-bold text-slate-900 text-base">{m.case.name}</h3>
                    <span className={`text-xs px-2 py-0.5 rounded-full font-medium shrink-0 ${m.case.case_type === 'mass_tort' ? 'bg-blue-100 text-blue-700' : 'bg-teal-100 text-teal-700'}`}>
                      {m.case.case_type === 'mass_tort' ? 'Mass Tort' : 'Class Action'}
                    </span>
                  </div>
                  <MatchBadge tier={m.tier} />
                </div>
              </div>
              <p className="text-sm text-slate-600 leading-relaxed mb-3">{m.case.short_description}</p>
              {m.tier === 'more_info_needed' && m.missingInfo.length > 0 && (
                <div className="bg-amber-50 border border-amber-200 rounded-lg px-3 py-2 mb-4">
                  <p className="text-xs font-semibold text-amber-700 mb-1">More info needed to better qualify this case:</p>
                  <ul className="space-y-1">
                    {m.missingInfo.slice(0, 4).map((item) => (
                      <li key={item.fieldKey} className="text-xs text-amber-800">
                        <strong>{item.label}</strong> - {item.reason}
                      </li>
                    ))}
                  </ul>
                </div>
              )}
              {m.case.payout_range && (
                <div className="flex items-center gap-2 bg-emerald-50 rounded-lg px-3 py-2 mb-4 border border-emerald-100">
                  <DollarSign size={13} className="text-emerald-600 shrink-0" />
                  <div className="min-w-0">
                    <div className="text-xs text-emerald-600 font-medium">Potential compensation</div>
                    <div className="text-sm font-bold text-emerald-800 truncate">{m.case.payout_range}</div>
                  </div>
                </div>
              )}
              {(() => {
                const subStatus = submissionMap[m.case.id];
                if (subStatus && COMPLETED_STATUSES.has(subStatus)) return (
                  <Link
                    to="/dashboard"
                    className="flex items-center justify-center gap-2 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-200 text-sm font-semibold px-5 py-3 rounded-xl transition-colors w-full min-h-[48px]"
                  >
                    <CheckCircle2 size={15} /> Intake Submitted — View Status
                  </Link>
                );
                if (subStatus && IN_PROGRESS_STATUSES.has(subStatus)) return (
                  <Link
                    to={`/intake/${m.case.slug}`}
                    className="flex items-center justify-center gap-2 bg-amber-50 hover:bg-amber-100 text-amber-700 border border-amber-200 text-sm font-semibold px-5 py-3 rounded-xl transition-colors w-full min-h-[48px]"
                  >
                    <Clock size={15} /> Continue Intake
                  </Link>
                );
                return (
                  <Link
                    to={`/intake/${m.case.slug}`}
                    className="flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 text-white text-sm font-semibold px-5 py-3 rounded-xl transition-colors w-full min-h-[48px]"
                  >
                    {m.tier === 'more_info_needed' ? 'Complete Missing Intake' : 'Start Intake'} <ArrowRight size={15} />
                  </Link>
                );
              })()}
            </div>
          ))}
        </div>
      )}

      {/* All other active cases */}
      {allCases.length > 0 && (
        <div className="mb-6">
          <div className="flex items-center gap-2 mb-3">
            <h2 className="font-bold text-slate-900">
              {matches.length > 0 ? 'All Open Cases' : 'Browse All Open Cases'}
            </h2>
            <span className="text-xs bg-slate-100 text-slate-500 px-2 py-0.5 rounded-full font-medium">{allCases.length}</span>
          </div>
          <p className="text-sm text-slate-500 mb-4 leading-relaxed">
            You can submit for any case regardless of your match score. Our team will review your intake to determine eligibility.
          </p>

          <div className="space-y-2">
            {allCases.map(c => {
              const match = matches.find(m => m.case.id === c.id);
              const subStatus = submissionMap[c.id];
              const isCompleted = subStatus && COMPLETED_STATUSES.has(subStatus);
              const isInProgress = subStatus && IN_PROGRESS_STATUSES.has(subStatus);
              const href = isCompleted ? '/dashboard' : `/intake/${c.slug}`;
              return (
                <Link
                  key={c.id}
                  to={href}
                  className={`flex items-center gap-3 bg-white rounded-xl border p-4 transition-all group ${isCompleted ? 'border-emerald-200 bg-emerald-50/30' : 'border-slate-200 hover:border-blue-200 hover:bg-blue-50/30'}`}
                >
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap mb-1">
                      <p className={`font-semibold text-sm truncate transition-colors ${isCompleted ? 'text-emerald-800' : 'text-slate-900 group-hover:text-blue-700'}`}>{c.name}</p>
                      <span className={`text-xs px-2 py-0.5 rounded-full font-medium shrink-0 ${c.case_type === 'mass_tort' ? 'bg-blue-100 text-blue-700' : 'bg-teal-100 text-teal-700'}`}>
                        {c.case_type === 'mass_tort' ? 'Mass Tort' : 'Class Action'}
                      </span>
                    </div>
                    {c.short_description && (
                      <p className="text-xs text-slate-500 line-clamp-1">{c.short_description}</p>
                    )}
                    <div className="flex items-center gap-2 flex-wrap mt-1">
                      {match && <MatchBadge tier={match.tier} />}
                      {c.payout_range && (
                        <span className="text-xs text-emerald-700 font-medium bg-emerald-50 px-2 py-0.5 rounded-full border border-emerald-100">
                          {c.payout_range}
                        </span>
                      )}
                    </div>
                  </div>
                  {isCompleted ? (
                    <CheckCircle2 size={16} className="text-emerald-500 shrink-0" />
                  ) : isInProgress ? (
                    <Clock size={16} className="text-amber-500 shrink-0" />
                  ) : (
                    <ChevronRight size={16} className="text-slate-300 group-hover:text-blue-500 transition-colors shrink-0" />
                  )}
                </Link>
              );
            })}
          </div>
        </div>
      )}

      <div className="bg-amber-50 border border-amber-200 rounded-2xl p-4 mb-5">
        <div className="flex items-start gap-2">
          <AlertCircle size={16} className="text-amber-600 mt-0.5 shrink-0" />
          <p className="text-xs text-amber-800 leading-relaxed">
            Match results are preliminary and based solely on your answers. This is not legal advice. A legal professional must review your information before any eligibility determination is made.
          </p>
        </div>
      </div>

      <div className="flex items-center justify-between">
        <Link to="/quiz" className="flex items-center gap-1.5 text-sm text-slate-500 hover:text-slate-700 transition-colors min-h-[44px] px-1">
          <RefreshCw size={14} /> Update answers
        </Link>
        <Link to="/dashboard" className="text-sm text-blue-600 hover:text-blue-800 font-medium min-h-[44px] flex items-center">
          Go to dashboard →
        </Link>
      </div>
    </div>
  );
}
