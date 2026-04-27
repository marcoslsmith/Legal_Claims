import type { MatchTier } from '../types/database';

const config: Record<MatchTier, { label: string; classes: string; dot: string }> = {
  strong_match: { label: 'Strong Match', classes: 'bg-emerald-50 text-emerald-700 border-emerald-200', dot: 'bg-emerald-500' },
  possible_match: { label: 'Possible Match', classes: 'bg-amber-50 text-amber-700 border-amber-200', dot: 'bg-amber-500' },
  more_info_needed: { label: 'More Info Needed', classes: 'bg-blue-50 text-blue-700 border-blue-200', dot: 'bg-blue-500' },
  not_eligible: { label: 'Not Eligible', classes: 'bg-slate-100 text-slate-500 border-slate-200', dot: 'bg-slate-400' },
};

export function MatchBadge({ tier }: { tier: MatchTier }) {
  const c = config[tier] || config.more_info_needed;
  return (
    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium border ${c.classes}`}>
      <span className={`w-1.5 h-1.5 rounded-full ${c.dot}`} />
      {c.label}
    </span>
  );
}
