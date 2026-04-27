import React, { useEffect, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { ArrowRight, RefreshCw, AlertCircle, Search, ChevronRight, DollarSign, CheckCircle2, Clock } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { MatchBadge } from '../components/MatchBadge';
import type { Case, MatchTier } from '../types/database';

interface CaseMatch {
  case: Case;
  tier: MatchTier;
  score: number;
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
    const [{ data: cases }, { data: rules }, { data: userAnswers }, { data: userSubs }] = await Promise.all([
      supabase.from('cases').select('*').eq('status', 'active').order('priority_score', { ascending: false }),
      supabase.from('matching_rules').select('*'),
      supabase.from('answers').select('*').eq('user_id', user!.id),
      supabase.from('submissions').select('case_id, status').eq('user_id', user!.id),
    ]);

    const map: Record<string, string> = {};
    for (const sub of (userSubs || [])) map[sub.case_id] = sub.status;
    setSubmissionMap(map);

    if (!cases) { setLoading(false); return; }

    setAllCases(cases);

    const answerMap: Record<string, string | string[]> = {};
    (userAnswers || []).forEach(a => {
      answerMap[a.field_key] = a.answer_values?.length ? a.answer_values : (a.answer_value || '');
    });

    const caseMatches: CaseMatch[] = cases.map(c => {
      const caseRules = (rules || []).filter(r => r.case_id === c.id);
      let score = 0;
      let disqualified = false;

      for (const rule of caseRules) {
        const userVal = answerMap[rule.field_key];
        if (userVal === undefined || userVal === '') continue;
        const strVal = Array.isArray(userVal) ? userVal.join(',') : userVal;

        let matched = false;
        switch (rule.operator) {
          case 'equals': matched = strVal.toLowerCase() === (rule.value || '').toLowerCase(); break;
          case 'not_equals': matched = strVal.toLowerCase() !== (rule.value || '').toLowerCase(); break;
          case 'contains': matched = strVal.toLowerCase().includes((rule.value || '').toLowerCase()); break;
          case 'in_list':
            matched = Array.isArray(userVal)
              ? userVal.some(v => (rule.value_list || []).includes(v))
              : (rule.value_list || []).some(v => strVal.toLowerCase().includes(v.toLowerCase()));
            break;
        }

        if (matched) {
          if (rule.is_disqualifying) { disqualified = true; break; }
          score += rule.points || 0;
        }
      }

      let tier: MatchTier;
      if (disqualified) tier = 'not_eligible';
      else if (score >= 80) tier = 'strong_match';
      else if (score >= 50) tier = 'possible_match';
      else tier = 'more_info_needed';

      return { case: c, tier, score };
    });

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

  // Cases that didn't score as a match — show as browse section
  const matchedIds = new Set(matches.map(m => m.case.id));
  const otherCases = allCases.filter(c => !matchedIds.has(c.id));

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-slate-900 mb-1">Your Matches</h1>
        <p className="text-slate-500 text-sm leading-relaxed">
          Based on your answers, here are the claims you may qualify for.
        </p>
      </div>

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
                    Start Intake <ArrowRight size={15} />
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
