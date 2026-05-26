import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Pencil, X, ChevronRight, AlertTriangle } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import type { Case } from '../../types/database';
import { DocRequirementsFields } from './DocRequirementsFields';

const EMPTY: Partial<Case> = {
  name: '', slug: '', case_type: 'mass_tort', status: 'active',
  short_description: '', long_description: '', priority_score: 50,
  allowed_states: [], disqualifying_states: [],
  estimated_lead_value: 0, internal_notes: '',
  require_medical_docs: false, required_doc_types: [],
};

const statusColors: Record<string, string> = {
  active: 'bg-emerald-100 text-emerald-700',
  paused: 'bg-amber-100 text-amber-700',
  closed: 'bg-slate-100 text-slate-500',
  waitlist: 'bg-blue-100 text-blue-700',
};

export default function Cases() {
  const navigate = useNavigate();
  const [cases, setCases] = useState<Case[]>([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState<Partial<Case>>(EMPTY);
  const [editing, setEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [showForm, setShowForm] = useState(false);

  useEffect(() => { loadCases(); }, []);

  const loadCases = async () => {
    const { data } = await supabase.from('cases').select('*').order('priority_score', { ascending: false });
    setCases(data || []);
    setLoading(false);
  };

  const openNew = () => { setForm(EMPTY); setEditing(false); setShowForm(true); };
  const openEdit = (c: Case) => { setForm(c); setEditing(true); setShowForm(true); };

  const handleSave = async () => {
    setSaving(true);
    if (editing && form.id) {
      await supabase.from('cases').update({ ...form, updated_at: new Date().toISOString() }).eq('id', form.id);
    } else {
      await supabase.from('cases').insert({ ...form, id: undefined });
    }
    await loadCases();
    setShowForm(false);
    setSaving(false);
  };

  return (
    <div className="p-4 sm:p-6">
      <div className="flex items-center justify-between mb-5">
        <h1 className="text-lg sm:text-xl font-bold text-slate-900">Case Management</h1>
        <button
          onClick={openNew}
          className="flex items-center gap-2 bg-blue-700 hover:bg-blue-800 text-white text-sm font-semibold px-4 py-2.5 rounded-xl transition-colors min-h-[44px]"
        >
          <Plus size={16} /> New Case
        </button>
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-16">
          <div className="w-7 h-7 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <div className="space-y-3">
          {cases.map(c => (
            <div key={c.id} className="bg-white rounded-xl border border-slate-200 p-4">
              <div className="flex items-start justify-between gap-3">
                <button
                  onClick={() => navigate(`/admin/cases/${c.id}`)}
                  className="flex-1 min-w-0 text-left group"
                >
                  <div className="flex items-center gap-2 flex-wrap mb-2">
                    <h3 className="font-semibold text-slate-900 text-sm group-hover:text-blue-700 transition-colors">{c.name}</h3>
                    <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${c.case_type === 'mass_tort' ? 'bg-blue-100 text-blue-700' : 'bg-teal-100 text-teal-700'}`}>
                      {c.case_type === 'mass_tort' ? 'Mass Tort' : 'Class Action'}
                    </span>
                    {c.category && (
                      <span className="text-xs px-2 py-0.5 rounded-full font-medium bg-slate-100 text-slate-600">
                        {c.category}
                      </span>
                    )}
                    {c.is_research_grade && (
                      <span className="text-xs px-2 py-0.5 rounded-full font-medium bg-amber-50 text-amber-700 border border-amber-200 flex items-center gap-1">
                        <AlertTriangle size={11} /> Research-grade
                      </span>
                    )}
                  </div>
                  <div className="flex items-center gap-2 flex-wrap">
                    <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${statusColors[c.status] || 'bg-slate-100 text-slate-600'}`}>
                      {c.status}
                    </span>
                    <span className="text-xs text-slate-400">Priority: {c.priority_score}</span>
                    <span className="text-xs text-slate-400">${(c.estimated_lead_value || 0).toLocaleString()} /lead</span>
                  </div>
                  {c.short_description && (
                    <p className="text-xs text-slate-500 mt-2 line-clamp-2 leading-relaxed">{c.short_description}</p>
                  )}
                </button>
                <div className="flex items-center gap-1 shrink-0">
                  <button
                    onClick={e => { e.stopPropagation(); openEdit(c); }}
                    className="w-11 h-11 flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-xl transition-colors"
                  >
                    <Pencil size={17} />
                  </button>
                  <button
                    onClick={() => navigate(`/admin/cases/${c.id}`)}
                    className="w-11 h-11 flex items-center justify-center text-slate-300 hover:text-slate-600 hover:bg-slate-50 rounded-xl transition-colors"
                  >
                    <ChevronRight size={17} />
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Form — full-screen sheet on mobile, centered modal on desktop */}
      {showForm && (
        <div className="fixed inset-0 z-50 flex flex-col lg:items-center lg:justify-start lg:pt-8 lg:bg-black/50 lg:px-4 lg:pb-8 lg:overflow-y-auto">
          <div className="bg-white w-full lg:max-w-2xl lg:rounded-2xl flex flex-col h-full lg:h-auto shadow-xl">
            <div className="sticky top-0 bg-white lg:rounded-t-2xl border-b border-slate-200 px-5 py-4 flex items-center justify-between">
              <h2 className="font-bold text-slate-900">{editing ? 'Edit Case' : 'New Case'}</h2>
              <button
                onClick={() => setShowForm(false)}
                className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-xl transition-colors"
              >
                <X size={20} />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-5 space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Case Name</label>
                <input
                  value={form.name || ''}
                  onChange={e => setForm(f => ({ ...f, name: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="e.g. Roundup Weedkiller Cancer Lawsuit"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Slug</label>
                  <input
                    value={form.slug || ''}
                    onChange={e => setForm(f => ({ ...f, slug: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="roundup"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Type</label>
                  <select
                    value={form.case_type || 'mass_tort'}
                    onChange={e => setForm(f => ({ ...f, case_type: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                  >
                    <option value="mass_tort">Mass Tort</option>
                    <option value="class_action">Class Action</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Status</label>
                  <select
                    value={form.status || 'active'}
                    onChange={e => setForm(f => ({ ...f, status: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                  >
                    <option value="active">Active</option>
                    <option value="paused">Paused</option>
                    <option value="closed">Closed</option>
                    <option value="waitlist">Waitlist</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Priority (0–100)</label>
                  <input
                    type="number"
                    value={form.priority_score || 50}
                    onChange={e => setForm(f => ({ ...f, priority_score: parseInt(e.target.value) }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                    min={0} max={100}
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Est. Lead Value ($)</label>
                <input
                  type="number"
                  value={form.estimated_lead_value || 0}
                  onChange={e => setForm(f => ({ ...f, estimated_lead_value: parseFloat(e.target.value) }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  min={0}
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">
                  Category <span className="text-slate-400 font-normal">(e.g. "Prescription drug", "Data breach")</span>
                </label>
                <input
                  value={form.category || ''}
                  onChange={e => setForm(f => ({ ...f, category: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Prescription drug"
                />
              </div>

              <label className="flex items-start gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={form.is_research_grade ?? false}
                  onChange={e => setForm(f => ({ ...f, is_research_grade: e.target.checked }))}
                  className="mt-0.5 w-5 h-5 rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                />
                <div>
                  <p className="text-sm font-medium text-slate-700">Research-grade (pending attorney review)</p>
                  <p className="text-xs text-slate-500 mt-0.5">Case info has not been reviewed by counsel. A warning banner will display in the admin detail.</p>
                </div>
              </label>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Short Description</label>
                <input
                  value={form.short_description || ''}
                  onChange={e => setForm(f => ({ ...f, short_description: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="Brief summary shown on match cards"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Long Description</label>
                <textarea
                  rows={4}
                  value={form.long_description || ''}
                  onChange={e => setForm(f => ({ ...f, long_description: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                  placeholder="Detailed description"
                />
              </div>

              <DocRequirementsFields
                requireDocs={form.require_medical_docs ?? false}
                requiredDocTypes={form.required_doc_types ?? []}
                onRequireDocsChange={v => setForm(f => ({ ...f, require_medical_docs: v }))}
                onRequiredDocTypesChange={v => setForm(f => ({ ...f, required_doc_types: v }))}
              />

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Internal Notes</label>
                <textarea
                  rows={2}
                  value={form.internal_notes || ''}
                  onChange={e => setForm(f => ({ ...f, internal_notes: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                  placeholder="Admin-only notes"
                />
              </div>
            </div>

            <div className="sticky bottom-0 bg-white border-t border-slate-100 p-4 flex gap-3">
              <button
                onClick={() => setShowForm(false)}
                className="flex-1 min-h-[48px] border border-slate-300 text-slate-700 font-medium rounded-xl text-sm hover:bg-slate-50 transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={handleSave}
                disabled={saving || !form.name || !form.slug}
                className="flex-1 min-h-[48px] bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 text-white font-semibold rounded-xl text-sm transition-colors"
              >
                {saving ? 'Saving...' : editing ? 'Save Changes' : 'Create Case'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
