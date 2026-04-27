import React, { useEffect, useState } from 'react';
import { Users, FileText, CheckCircle, DollarSign, TrendingUp, Activity } from 'lucide-react';
import { supabase } from '../../lib/supabase';

interface Stats {
  totalUsers: number;
  totalSubmissions: number;
  qualifiedLeads: number;
  estimatedRevenue: number;
  submittedLeads: number;
  completionRate: number;
}

interface CaseStat { caseName: string; count: number; }

export default function Overview() {
  const [stats, setStats] = useState<Stats>({ totalUsers: 0, totalSubmissions: 0, qualifiedLeads: 0, estimatedRevenue: 0, submittedLeads: 0, completionRate: 0 });
  const [caseStats, setCaseStats] = useState<CaseStat[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => { loadStats(); }, []);

  const loadStats = async () => {
    const [{ count: usersCount }, { data: subs }, { data: cases }] = await Promise.all([
      supabase.from('profiles').select('*', { count: 'exact', head: true }),
      supabase.from('submissions').select('*, cases(name)'),
      supabase.from('cases').select('*').eq('status', 'active'),
    ]);

    const allSubs = subs || [];
    const submitted = allSubs.filter(s => ['submitted', 'under_review', 'routed', 'accepted'].includes(s.status));
    const qualified = allSubs.filter(s => ['accepted', 'routed'].includes(s.status));
    const revenue = qualified.reduce((acc, s) => acc + (s.estimated_value || 0), 0);
    const inProgress = allSubs.filter(s => s.status === 'in_progress').length;
    const completionRate = allSubs.length > 0 ? Math.round((submitted.length / allSubs.length) * 100) : 0;

    setStats({
      totalUsers: usersCount || 0,
      totalSubmissions: allSubs.length,
      qualifiedLeads: qualified.length,
      estimatedRevenue: revenue,
      submittedLeads: submitted.length,
      completionRate,
    });

    // Count by case
    const caseCounts: Record<string, number> = {};
    allSubs.forEach((s: any) => {
      const name = s.cases?.name || 'Unknown';
      caseCounts[name] = (caseCounts[name] || 0) + 1;
    });
    setCaseStats(Object.entries(caseCounts).map(([caseName, count]) => ({ caseName, count })).sort((a, b) => b.count - a.count));
    setLoading(false);
  };

  const cards = [
    { label: 'Total Users', value: stats.totalUsers, icon: Users, color: 'blue' },
    { label: 'Total Submissions', value: stats.totalSubmissions, icon: FileText, color: 'teal' },
    { label: 'Submitted Leads', value: stats.submittedLeads, icon: Activity, color: 'amber' },
    { label: 'Qualified Leads', value: stats.qualifiedLeads, icon: CheckCircle, color: 'emerald' },
    { label: 'Est. Revenue', value: `$${stats.estimatedRevenue.toLocaleString()}`, icon: DollarSign, color: 'green' },
    { label: 'Completion Rate', value: `${stats.completionRate}%`, icon: TrendingUp, color: 'slate' },
  ];

  const colorMap: Record<string, string> = {
    blue: 'bg-blue-50 text-blue-700',
    teal: 'bg-teal-50 text-teal-700',
    amber: 'bg-amber-50 text-amber-700',
    emerald: 'bg-emerald-50 text-emerald-700',
    green: 'bg-green-50 text-green-700',
    slate: 'bg-slate-100 text-slate-700',
  };

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  return (
    <div className="p-6">
      <h1 className="text-xl font-bold text-slate-900 mb-6">Analytics Overview</h1>

      <div className="grid grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
        {cards.map(card => (
          <div key={card.label} className="bg-white rounded-xl border border-slate-200 p-5">
            <div className="flex items-center justify-between mb-3">
              <span className="text-xs font-medium text-slate-500 uppercase tracking-wide">{card.label}</span>
              <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${colorMap[card.color]}`}>
                <card.icon size={16} />
              </div>
            </div>
            <div className="text-2xl font-bold text-slate-900">{loading ? '—' : card.value}</div>
          </div>
        ))}
      </div>

      {caseStats.length > 0 && (
        <div className="bg-white rounded-xl border border-slate-200 p-6">
          <h2 className="font-semibold text-slate-900 mb-4 text-sm">Submissions by Case</h2>
          <div className="space-y-3">
            {caseStats.map(cs => {
              const pct = stats.totalSubmissions > 0 ? Math.round((cs.count / stats.totalSubmissions) * 100) : 0;
              return (
                <div key={cs.caseName}>
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-sm text-slate-700 font-medium">{cs.caseName}</span>
                    <span className="text-xs text-slate-500">{cs.count} ({pct}%)</span>
                  </div>
                  <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                    <div className="h-full bg-blue-500 rounded-full transition-all" style={{ width: `${pct}%` }} />
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}
