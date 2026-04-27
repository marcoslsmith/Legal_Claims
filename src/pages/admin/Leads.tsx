import React, { useEffect, useState } from 'react';
import { Search, Eye, ChevronRight, X, Filter } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { MatchBadge } from '../../components/MatchBadge';
import { StatusBadge } from '../../components/StatusBadge';
import type { Submission, Case, Profile, MatchTier } from '../../types/database';

interface Lead extends Submission {
  case: Case;
  profile: Profile;
}

interface LeadDetail extends Lead {
  answers: Array<{ field_key: string; answer_value: string; question?: { question_text: string } }>;
  documents: Array<{ id: string; file_name: string; document_type: string }>;
  consents: Array<{ consented_at: string }>;
  status_history: Array<{ new_status: string; created_at: string; note: string }>;
}

const STATUSES = ['new', 'needs_review', 'qualified', 'routed', 'accepted', 'rejected', 'duplicate', 'bad_contact', 'closed'];

export default function Leads() {
  const [leads, setLeads] = useState<Lead[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  const [selected, setSelected] = useState<LeadDetail | null>(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [updatingStatus, setUpdatingStatus] = useState(false);

  useEffect(() => { loadLeads(); }, []);

  const loadLeads = async () => {
    const { data } = await supabase
      .from('submissions')
      .select('*, cases(*), profiles(*)')
      .order('created_at', { ascending: false });
    setLeads((data as any[] || []).map(s => ({ ...s, case: s.cases, profile: s.profiles })));
    setLoading(false);
  };

  const openDetail = async (lead: Lead) => {
    setDetailLoading(true);
    setSelected(lead as LeadDetail);
    const [{ data: ans }, { data: docs }, { data: cons }, { data: hist }] = await Promise.all([
      supabase.from('answers').select('*, questions(question_text)').eq('user_id', lead.user_id),
      supabase.from('uploaded_documents').select('*').eq('submission_id', lead.id),
      supabase.from('consents').select('*').eq('submission_id', lead.id),
      supabase.from('lead_status_history').select('*').eq('submission_id', lead.id).order('created_at'),
    ]);
    setSelected({
      ...lead,
      answers: (ans as any[] || []).map(a => ({ ...a, question: a.questions })),
      documents: docs || [],
      consents: cons || [],
      status_history: hist || [],
    });
    setDetailLoading(false);
  };

  const updateStatus = async (newStatus: string) => {
    if (!selected) return;
    setUpdatingStatus(true);
    await supabase.from('submissions').update({ status: newStatus, updated_at: new Date().toISOString() }).eq('id', selected.id);
    await supabase.from('lead_status_history').insert({
      submission_id: selected.id,
      old_status: selected.status,
      new_status: newStatus,
      note: 'Updated by admin',
    });
    setSelected(prev => prev ? { ...prev, status: newStatus } : null);
    setLeads(prev => prev.map(l => l.id === selected.id ? { ...l, status: newStatus } : l));
    setUpdatingStatus(false);
  };

  const filtered = leads.filter(l => {
    const q = search.toLowerCase();
    const matchesSearch = !search ||
      (l.profile?.full_name || '').toLowerCase().includes(q) ||
      (l.profile?.email || '').toLowerCase().includes(q) ||
      (l.case?.name || '').toLowerCase().includes(q);
    return matchesSearch && (!statusFilter || l.status === statusFilter);
  });

  return (
    <div className="p-4 sm:p-6">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-lg sm:text-xl font-bold text-slate-900">Lead Dashboard</h1>
        <span className="text-sm text-slate-500">{filtered.length} lead{filtered.length !== 1 ? 's' : ''}</span>
      </div>

      {/* Search + filter bar */}
      <div className="flex gap-2 mb-4">
        <div className="relative flex-1">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none" />
          <input
            value={search}
            onChange={e => setSearch(e.target.value)}
            placeholder="Search name, email, case..."
            className="w-full pl-9 pr-3 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
          />
        </div>
        <button
          onClick={() => setShowFilters(!showFilters)}
          className={`flex items-center gap-1.5 px-3 py-2.5 rounded-xl border text-sm font-medium transition-colors min-w-[44px] justify-center ${statusFilter ? 'bg-blue-700 border-blue-700 text-white' : 'border-slate-300 text-slate-600 bg-white hover:border-blue-300'}`}
        >
          <Filter size={16} />
          <span className="hidden sm:inline">Filter</span>
        </button>
      </div>

      {showFilters && (
        <div className="mb-4 p-3 bg-white rounded-xl border border-slate-200">
          <p className="text-xs font-medium text-slate-500 uppercase tracking-wide mb-2">Filter by Status</p>
          <div className="flex flex-wrap gap-2">
            <button
              onClick={() => setStatusFilter('')}
              className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-colors min-h-[36px] ${!statusFilter ? 'bg-blue-700 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}`}
            >
              All
            </button>
            {STATUSES.map(s => (
              <button
                key={s}
                onClick={() => setStatusFilter(s)}
                className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-colors min-h-[36px] ${statusFilter === s ? 'bg-blue-700 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}`}
              >
                {s.replace(/_/g, ' ')}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Mobile card list */}
      {loading ? (
        <div className="flex items-center justify-center py-16">
          <div className="w-7 h-7 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-16 text-slate-400 text-sm bg-white rounded-xl border border-slate-200">
          No leads found.
        </div>
      ) : (
        <>
          {/* Desktop table */}
          <div className="hidden lg:block bg-white rounded-xl border border-slate-200 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-slate-50 border-b border-slate-200">
                  <tr>
                    {['Name', 'Email', 'Phone', 'State', 'Case', 'Match', 'Status', 'Submitted', ''].map(h => (
                      <th key={h} className="text-left text-xs font-semibold text-slate-500 uppercase tracking-wide px-4 py-3 whitespace-nowrap">{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {filtered.map(lead => (
                    <tr key={lead.id} className="hover:bg-slate-50 transition-colors">
                      <td className="px-4 py-3 font-medium text-slate-900 whitespace-nowrap">{lead.profile?.full_name || '—'}</td>
                      <td className="px-4 py-3 text-slate-600 whitespace-nowrap">{lead.profile?.email || '—'}</td>
                      <td className="px-4 py-3 text-slate-600 whitespace-nowrap">{lead.profile?.phone || '—'}</td>
                      <td className="px-4 py-3 text-slate-600 whitespace-nowrap">{lead.profile?.state || '—'}</td>
                      <td className="px-4 py-3 text-slate-700 whitespace-nowrap max-w-[140px] truncate">{lead.case?.name}</td>
                      <td className="px-4 py-3 whitespace-nowrap">{lead.match_tier ? <MatchBadge tier={lead.match_tier as MatchTier} /> : '—'}</td>
                      <td className="px-4 py-3 whitespace-nowrap"><StatusBadge status={lead.status} /></td>
                      <td className="px-4 py-3 text-slate-500 whitespace-nowrap text-xs">{lead.submitted_at ? new Date(lead.submitted_at).toLocaleDateString() : '—'}</td>
                      <td className="px-4 py-3 whitespace-nowrap">
                        <button onClick={() => openDetail(lead)} className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors">
                          <Eye size={16} />
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Mobile / tablet card list */}
          <div className="lg:hidden space-y-3">
            {filtered.map(lead => (
              <button
                key={lead.id}
                onClick={() => openDetail(lead)}
                className="w-full text-left bg-white rounded-xl border border-slate-200 p-4 hover:border-blue-300 active:bg-slate-50 transition-colors"
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="flex-1 min-w-0">
                    <p className="font-semibold text-slate-900 text-sm truncate">
                      {lead.profile?.full_name || 'Unknown'}
                    </p>
                    <p className="text-xs text-slate-500 mt-0.5 truncate">{lead.profile?.email}</p>
                    <p className="text-xs text-slate-600 mt-1 font-medium truncate">{lead.case?.name}</p>
                  </div>
                  <div className="flex flex-col items-end gap-1.5 shrink-0">
                    <StatusBadge status={lead.status} />
                    {lead.match_tier && <MatchBadge tier={lead.match_tier as MatchTier} />}
                  </div>
                </div>
                <div className="flex items-center justify-between mt-3 pt-3 border-t border-slate-100">
                  <div className="flex items-center gap-3 text-xs text-slate-500">
                    <span>{lead.profile?.state || '—'}</span>
                    <span>&bull;</span>
                    <span>{lead.profile?.phone || 'No phone'}</span>
                  </div>
                  <div className="flex items-center gap-1 text-blue-600 text-xs font-medium">
                    View <ChevronRight size={13} />
                  </div>
                </div>
              </button>
            ))}
          </div>
        </>
      )}

      {/* Lead detail — full screen on mobile, side panel on desktop */}
      {selected && (
        <div className="fixed inset-0 z-50 flex">
          <div className="hidden lg:block flex-1 bg-black/40" onClick={() => setSelected(null)} />
          <div className="w-full lg:w-[480px] bg-white flex flex-col h-full overflow-hidden shadow-xl">
            <div className="sticky top-0 bg-white border-b border-slate-200 px-5 py-4 flex items-center justify-between">
              <div>
                <h2 className="font-bold text-slate-900 text-base">{selected.profile?.full_name || 'Lead Detail'}</h2>
                <p className="text-xs text-slate-500 mt-0.5">{selected.case?.name}</p>
              </div>
              <button
                onClick={() => setSelected(null)}
                className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-xl transition-colors"
              >
                <X size={20} />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-5 space-y-5 pb-safe">
              {detailLoading ? (
                <div className="flex items-center justify-center py-20">
                  <div className="w-7 h-7 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
                </div>
              ) : (
                <>
                  {/* Status update */}
                  <div className="bg-slate-50 rounded-xl p-4">
                    <div className="flex items-center justify-between mb-3">
                      <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Update Status</h3>
                      <StatusBadge status={selected.status} />
                    </div>
                    <div className="flex flex-wrap gap-2">
                      {STATUSES.map(s => (
                        <button
                          key={s}
                          onClick={() => updateStatus(s)}
                          disabled={updatingStatus || selected.status === s}
                          className={`px-3 py-2 rounded-xl text-xs font-medium transition-colors min-h-[36px] ${selected.status === s ? 'bg-blue-700 text-white' : 'bg-white border border-slate-200 text-slate-600 hover:border-blue-300 hover:text-blue-700'}`}
                        >
                          {s.replace(/_/g, ' ')}
                        </button>
                      ))}
                    </div>
                  </div>

                  {/* Profile */}
                  <div>
                    <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-3">Profile</h3>
                    <div className="grid grid-cols-2 gap-2">
                      {[
                        ['Email', selected.profile?.email],
                        ['Phone', selected.profile?.phone],
                        ['State', selected.profile?.state],
                        ['City', selected.profile?.city],
                        ['ZIP', selected.profile?.zip_code],
                        ['Prior Attorney', selected.profile?.prior_attorney ? 'Yes' : 'No'],
                      ].map(([k, v]) => (
                        <div key={k as string} className="bg-slate-50 rounded-xl p-3">
                          <div className="text-xs text-slate-400 mb-0.5">{k}</div>
                          <div className="font-medium text-slate-800 text-sm">{v || '—'}</div>
                        </div>
                      ))}
                    </div>
                  </div>

                  {/* Match */}
                  <div>
                    <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">Match Score</h3>
                    <div className="flex items-center gap-3 bg-slate-50 rounded-xl p-3">
                      {selected.match_tier && <MatchBadge tier={selected.match_tier as MatchTier} />}
                      <span className="text-sm text-slate-700">Score: <strong>{selected.match_score || 0} pts</strong></span>
                    </div>
                  </div>

                  {/* Answers */}
                  {selected.answers && selected.answers.length > 0 && (
                    <div>
                      <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-3">Answers</h3>
                      <div className="space-y-2">
                        {selected.answers.map(a => (
                          <div key={a.field_key} className="bg-slate-50 rounded-xl p-3">
                            <div className="text-xs text-slate-400 mb-0.5">{(a as any).question?.question_text || a.field_key}</div>
                            <div className="font-medium text-slate-800 text-sm">{a.answer_value || '—'}</div>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Documents */}
                  {selected.documents && selected.documents.length > 0 && (
                    <div>
                      <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">Documents ({selected.documents.length})</h3>
                      <div className="space-y-2">
                        {selected.documents.map(doc => (
                          <div key={doc.id} className="flex items-center gap-2 bg-slate-50 rounded-xl p-3">
                            <span className="text-slate-700 font-medium text-sm truncate flex-1">{doc.file_name}</span>
                            <span className="text-slate-400 text-xs shrink-0">{doc.document_type}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Consent */}
                  {selected.consents && selected.consents.length > 0 && (
                    <div>
                      <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">Consent</h3>
                      <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-3 text-sm text-emerald-700">
                        Consented on {new Date(selected.consents[0].consented_at!).toLocaleString()}
                      </div>
                    </div>
                  )}

                  {/* Status history */}
                  {selected.status_history && selected.status_history.length > 0 && (
                    <div>
                      <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">Status History</h3>
                      <div className="space-y-2">
                        {selected.status_history.map((h, i) => (
                          <div key={i} className="flex items-start gap-2 bg-slate-50 rounded-xl p-3">
                            <span className="w-2 h-2 rounded-full bg-blue-400 mt-1 shrink-0" />
                            <div>
                              <span className="font-medium text-slate-800 text-sm">{h.new_status.replace(/_/g, ' ')}</span>
                              <p className="text-xs text-slate-500">{new Date(h.created_at!).toLocaleDateString()}{h.note ? ` — ${h.note}` : ''}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
