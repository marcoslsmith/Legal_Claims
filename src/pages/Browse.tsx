import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { ArrowRight, Search, DollarSign, Scale, X, SlidersHorizontal, CheckCircle2, Clock } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { MatchBadge } from '../components/MatchBadge';
import type { Case, MatchTier } from '../types/database';

const TYPE_LABELS: Record<string, string> = {
  mass_tort: 'Mass Tort',
  class_action: 'Class Action',
};

// Statuses that mean the user has meaningfully completed or submitted intake
const COMPLETED_STATUSES = new Set(['submitted', 'under_review', 'routed', 'accepted', 'rejected', 'duplicate', 'bad_contact', 'closed']);
const IN_PROGRESS_STATUSES = new Set(['in_progress']);

export default function Browse() {
  const { user, loading: authLoading } = useAuth();
  const [cases, setCases] = useState<Case[]>([]);
  const [submissionMap, setSubmissionMap] = useState<Record<string, string>>({}); // case_id -> status
  const [matchTierMap, setMatchTierMap] = useState<Record<string, MatchTier>>({}); // case_id -> match_tier
  const [loading, setLoading] = useState(true);
  const [query, setQuery] = useState('');
  const [typeFilter, setTypeFilter] = useState<string>('all');

  useEffect(() => {
    if (authLoading) return;
    loadData();
  }, [user, authLoading]);

  const loadData = async () => {
    const [casesRes, subsRes] = await Promise.all([
      supabase.from('cases').select('*').eq('status', 'active').order('priority_score', { ascending: false }),
      user
        ? supabase.from('submissions').select('case_id, status, match_tier').eq('user_id', user.id)
        : Promise.resolve({ data: [] }),
    ]);

    setCases(casesRes.data || []);

    const map: Record<string, string> = {};
    const tierMap: Record<string, MatchTier> = {};
    for (const sub of (subsRes.data || []) as any[]) {
      map[sub.case_id] = sub.status;
      if (sub.match_tier) tierMap[sub.case_id] = sub.match_tier as MatchTier;
    }
    setSubmissionMap(map);
    setMatchTierMap(tierMap);
    setLoading(false);
  };

  const filtered = cases.filter(c => {
    const q = query.toLowerCase();
    const matchesQuery = !q || c.name.toLowerCase().includes(q) || (c.short_description || '').toLowerCase().includes(q);
    const matchesType = typeFilter === 'all' || c.case_type === typeFilter;
    return matchesQuery && matchesType;
  });

  const massTortCount = cases.filter(c => c.case_type === 'mass_tort').length;
  const classActionCount = cases.filter(c => c.case_type === 'class_action').length;

  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-slate-900 mb-1">Browse Active Claims</h1>
        <p className="text-slate-500 text-sm leading-relaxed">
          {cases.length} active legal claims — click any to learn more or start your intake.
        </p>
      </div>

      {/* Search + filter */}
      <div className="flex gap-2 mb-4">
        <div className="relative flex-1">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none" />
          <input
            type="text"
            placeholder="Search claims…"
            value={query}
            onChange={e => setQuery(e.target.value)}
            className="w-full pl-9 pr-9 py-2.5 text-sm border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent placeholder-slate-400"
          />
          {query && (
            <button onClick={() => setQuery('')} className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600">
              <X size={14} />
            </button>
          )}
        </div>
        <div className="relative">
          <SlidersHorizontal size={14} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none" />
          <select
            value={typeFilter}
            onChange={e => setTypeFilter(e.target.value)}
            className="pl-8 pr-3 py-2.5 text-sm border border-slate-200 rounded-xl bg-white focus:outline-none focus:ring-2 focus:ring-blue-500 appearance-none cursor-pointer text-slate-700"
          >
            <option value="all">All types</option>
            <option value="mass_tort">Mass Tort ({massTortCount})</option>
            <option value="class_action">Class Action ({classActionCount})</option>
          </select>
        </div>
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-7 h-7 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-200 p-10 text-center">
          <Scale size={28} className="text-slate-300 mx-auto mb-3" />
          <p className="text-slate-600 font-medium text-sm">No claims match your search</p>
          <p className="text-slate-400 text-xs mt-1">Try a different keyword or clear the filter</p>
          <button onClick={() => { setQuery(''); setTypeFilter('all'); }} className="mt-3 text-xs text-blue-600 hover:underline">Clear filters</button>
        </div>
      ) : (
        <div className="space-y-3">
          {filtered.map(c => {
            const subStatus = submissionMap[c.id];
            const isCompleted = subStatus && COMPLETED_STATUSES.has(subStatus);
            const isInProgress = subStatus && IN_PROGRESS_STATUSES.has(subStatus);

            return (
              <div
                key={c.id}
                className={`block bg-white rounded-2xl border transition-all duration-200 overflow-hidden ${isCompleted ? 'border-emerald-200' : 'border-slate-200 hover:border-blue-200 hover:shadow-md'}`}
              >
                <div className="p-5">
                  <div className="flex items-start justify-between gap-3 mb-2">
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap mb-1">
                        <h2 className="font-bold text-slate-900 text-base leading-snug">
                          {c.name}
                        </h2>
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium shrink-0 ${c.case_type === 'mass_tort' ? 'bg-blue-100 text-blue-700' : 'bg-teal-100 text-teal-700'}`}>
                          {TYPE_LABELS[c.case_type] ?? c.case_type}
                        </span>
                      </div>
                      {c.short_description && (
                        <p className="text-sm text-slate-500 leading-relaxed line-clamp-2">{c.short_description}</p>
                      )}
                    </div>
                    {isCompleted ? (
                      <div className="shrink-0 w-9 h-9 rounded-xl bg-emerald-100 flex items-center justify-center mt-0.5">
                        <CheckCircle2 size={16} className="text-emerald-600" />
                      </div>
                    ) : (
                      <Link
                        to={`/intake/${c.slug}`}
                        className="shrink-0 w-9 h-9 rounded-xl bg-slate-100 hover:bg-blue-100 flex items-center justify-center transition-colors mt-0.5 group"
                      >
                        <ArrowRight size={16} className="text-slate-400 group-hover:text-blue-600 transition-colors" />
                      </Link>
                    )}
                  </div>

                  <div className="flex items-center gap-2 mt-2 flex-wrap">
                    {matchTierMap[c.id] && <MatchBadge tier={matchTierMap[c.id]} />}
                    {c.payout_range && (
                      <div className="flex items-center gap-1.5 bg-emerald-50 rounded-lg px-2.5 py-1 border border-emerald-100">
                        <DollarSign size={11} className="text-emerald-600 shrink-0" />
                        <span className="text-xs font-bold text-emerald-800">{c.payout_range}</span>
                      </div>
                    )}
                  </div>
                </div>

                <div className={`px-5 py-3 border-t flex items-center justify-between ${isCompleted ? 'bg-emerald-50 border-emerald-100' : 'bg-slate-50 border-slate-100'}`}>
                  <span className="text-xs text-slate-400 font-medium flex items-center gap-1.5">
                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 inline-block" />
                    Accepting claims
                  </span>

                  {isCompleted ? (
                    <Link
                      to="/dashboard"
                      className="text-xs font-semibold text-emerald-700 hover:text-emerald-900 transition-colors flex items-center gap-1"
                    >
                      <CheckCircle2 size={11} /> Intake submitted — view status
                    </Link>
                  ) : isInProgress ? (
                    <Link
                      to={`/intake/${c.slug}`}
                      className="text-xs font-semibold text-amber-600 hover:text-amber-800 transition-colors flex items-center gap-1"
                    >
                      <Clock size={11} /> In progress — continue
                    </Link>
                  ) : (
                    <Link
                      to={`/intake/${c.slug}`}
                      className="text-xs font-semibold text-blue-600 hover:text-blue-800 transition-colors flex items-center gap-1"
                    >
                      Start intake <ArrowRight size={11} />
                    </Link>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}

      <p className="mt-6 text-xs text-slate-400 text-center leading-relaxed">
        Potential compensation varies. This is not legal advice. No attorney-client relationship is created by browsing or submitting a claim.
      </p>
    </div>
  );
}
