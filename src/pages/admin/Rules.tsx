import React, { useEffect, useState } from 'react';
import { Plus, X, Trash2, ChevronRight } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import type { Case, MatchingRule, Question } from '../../types/database';

const OPERATORS = ['equals', 'not_equals', 'contains', 'in_list', 'greater_than', 'less_than', 'between'];

const EMPTY: Partial<MatchingRule> = {
  rule_type: 'field_match', field_key: '', operator: 'equals',
  value: '', value_list: [], value_min: '', value_max: '',
  points: 20, is_disqualifying: false, description: '',
};

export default function Rules() {
  const [cases, setCases] = useState<Case[]>([]);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [selectedCase, setSelectedCase] = useState<Case | null>(null);
  const [showCaseList, setShowCaseList] = useState(true);
  const [rules, setRules] = useState<MatchingRule[]>([]);
  const [loading, setLoading] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState<Partial<MatchingRule>>(EMPTY);
  const [saving, setSaving] = useState(false);
  const [listInput, setListInput] = useState('');

  useEffect(() => {
    supabase.from('cases').select('*').order('priority_score', { ascending: false }).then(({ data }) => setCases(data || []));
    supabase.from('questions').select('*').order('field_key').then(({ data }) => setQuestions(data || []));
  }, []);

  const selectCase = async (c: Case) => {
    setLoading(true);
    setSelectedCase(c);
    setShowCaseList(false);
    const { data } = await supabase.from('matching_rules').select('*').eq('case_id', c.id);
    setRules(data || []);
    setLoading(false);
  };

  const handleSave = async () => {
    if (!selectedCase) return;
    setSaving(true);
    await supabase.from('matching_rules').insert({ ...form, case_id: selectedCase.id, id: undefined });
    const { data } = await supabase.from('matching_rules').select('*').eq('case_id', selectedCase.id);
    setRules(data || []);
    setShowForm(false);
    setForm(EMPTY);
    setSaving(false);
  };

  const handleDelete = async (id: string) => {
    await supabase.from('matching_rules').delete().eq('id', id);
    setRules(prev => prev.filter(r => r.id !== id));
  };

  const addListItem = () => {
    if (!listInput.trim()) return;
    setForm(f => ({ ...f, value_list: [...(f.value_list || []), listInput.trim()] }));
    setListInput('');
  };

  const totalPoints = rules.filter(r => !r.is_disqualifying).reduce((acc, r) => acc + (r.points || 0), 0);

  return (
    <div className="p-4 sm:p-6">
      <div className="flex items-center gap-3 mb-5">
        {!showCaseList && selectedCase && (
          <button
            onClick={() => { setShowCaseList(true); setSelectedCase(null); }}
            className="w-10 h-10 flex items-center justify-center text-slate-500 hover:bg-slate-100 rounded-xl transition-colors lg:hidden"
          >
            ←
          </button>
        )}
        <h1 className="text-lg sm:text-xl font-bold text-slate-900">Matching Rules</h1>
      </div>

      <div className="lg:grid lg:grid-cols-3 lg:gap-6">
        {/* Case list */}
        <div className={`${showCaseList ? 'block' : 'hidden lg:block'} bg-white rounded-xl border border-slate-200 p-4 lg:self-start`}>
          <h2 className="text-sm font-semibold text-slate-700 mb-3">Select a Case</h2>
          <div className="space-y-2">
            {cases.map(c => (
              <button
                key={c.id}
                onClick={() => selectCase(c)}
                className={`w-full text-left px-4 py-3.5 rounded-xl transition-colors min-h-[56px] ${selectedCase?.id === c.id ? 'bg-blue-700 text-white' : 'text-slate-700 hover:bg-slate-50 border border-slate-200 active:bg-slate-100'}`}
              >
                <div className="flex items-center justify-between">
                  <span className="font-medium text-sm">{c.name}</span>
                  <ChevronRight size={16} className={selectedCase?.id === c.id ? 'text-blue-200' : 'text-slate-400'} />
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Rules panel */}
        <div className={`${!showCaseList || selectedCase ? 'block' : 'hidden lg:block'} lg:col-span-2 bg-white rounded-xl border border-slate-200 p-4`}>
          {!selectedCase ? (
            <div className="hidden lg:flex items-center justify-center h-40 text-slate-400 text-sm">
              Select a case to manage its matching rules
            </div>
          ) : (
            <>
              <div className="flex items-center justify-between mb-4">
                <div>
                  <h2 className="font-semibold text-slate-900 text-sm">{selectedCase.name}</h2>
                  <p className="text-xs text-slate-500 mt-0.5">Max score: <strong>{totalPoints} pts</strong> · Strong Match ≥80 pts</p>
                </div>
                <button
                  onClick={() => { setForm({ ...EMPTY, case_id: selectedCase.id }); setShowForm(true); }}
                  className="flex items-center gap-1.5 bg-blue-700 hover:bg-blue-800 text-white text-sm font-semibold px-4 py-2.5 rounded-xl transition-colors min-h-[44px]"
                >
                  <Plus size={15} /> Add Rule
                </button>
              </div>

              {/* Scoring tiers */}
              <div className="flex gap-2 mb-4 overflow-x-auto pb-1">
                {[
                  { label: 'Strong Match', range: '≥80 pts', cls: 'bg-emerald-50 text-emerald-700 border-emerald-200' },
                  { label: 'Possible Match', range: '50–79 pts', cls: 'bg-amber-50 text-amber-700 border-amber-200' },
                  { label: 'More Info', range: '<50 pts', cls: 'bg-blue-50 text-blue-700 border-blue-200' },
                ].map(t => (
                  <span key={t.label} className={`text-xs px-2.5 py-1 rounded-full font-medium border shrink-0 ${t.cls}`}>
                    {t.label}: {t.range}
                  </span>
                ))}
              </div>

              {loading ? (
                <div className="flex items-center justify-center py-10">
                  <div className="w-6 h-6 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
                </div>
              ) : rules.length === 0 ? (
                <div className="text-center py-12 text-slate-400 text-sm">No rules yet. Add rules to define eligibility scoring.</div>
              ) : (
                <div className="space-y-2">
                  {rules.map(rule => (
                    <div key={rule.id} className={`rounded-xl p-4 border ${rule.is_disqualifying ? 'bg-red-50 border-red-200' : 'bg-slate-50 border-slate-200'}`}>
                      <div className="flex items-start justify-between gap-3">
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 flex-wrap mb-1.5">
                            <span className={`text-xs font-semibold px-2.5 py-1 rounded-full border ${rule.is_disqualifying ? 'bg-red-100 text-red-700 border-red-300' : 'bg-emerald-50 text-emerald-700 border-emerald-200'}`}>
                              {rule.is_disqualifying ? 'Disqualifying' : `+${rule.points} pts`}
                            </span>
                          </div>
                          <div className="flex items-center gap-1.5 flex-wrap text-sm">
                            <span className="font-mono text-xs bg-white border border-slate-200 px-2 py-1 rounded-lg text-slate-700">{rule.field_key}</span>
                            <span className="text-slate-500 text-xs">{rule.operator}</span>
                            <span className="font-mono text-xs bg-blue-50 text-blue-700 px-2 py-1 rounded-lg">
                              {rule.value || (rule.value_list?.slice(0, 2).join(', ') || '')}
                              {(rule.value_list?.length || 0) > 2 && ` +${(rule.value_list?.length || 0) - 2} more`}
                            </span>
                          </div>
                          {rule.description && (
                            <p className="text-xs text-slate-500 mt-1.5">{rule.description}</p>
                          )}
                        </div>
                        <button
                          onClick={() => handleDelete(rule.id)}
                          className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-colors shrink-0"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </>
          )}
        </div>
      </div>

      {/* Form — bottom sheet on mobile */}
      {showForm && (
        <div className="fixed inset-0 z-50 flex flex-col justify-end lg:items-center lg:justify-center lg:bg-black/50 lg:px-4">
          <div className="bg-white w-full lg:max-w-md lg:rounded-2xl rounded-t-3xl shadow-xl max-h-[90vh] flex flex-col">
            <div className="px-5 py-4 border-b border-slate-200 flex items-center justify-between">
              <h3 className="font-bold text-slate-900">Add Matching Rule</h3>
              <button onClick={() => setShowForm(false)} className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-xl">
                <X size={20} />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-5 space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Field Key</label>
                <select
                  value={form.field_key || ''}
                  onChange={e => setForm(f => ({ ...f, field_key: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                >
                  <option value="">Select a field...</option>
                  {questions.map(q => (
                    <option key={q.id} value={q.field_key}>
                      {q.field_key} — {q.question_text.slice(0, 40)}
                    </option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Operator</label>
                  <select
                    value={form.operator || 'equals'}
                    onChange={e => setForm(f => ({ ...f, operator: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                  >
                    {OPERATORS.map(op => <option key={op} value={op}>{op.replace(/_/g, ' ')}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Points</label>
                  <input
                    type="number"
                    value={form.points || 0}
                    onChange={e => setForm(f => ({ ...f, points: parseInt(e.target.value) }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>

              {form.operator !== 'in_list' ? (
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Match Value</label>
                  <input
                    value={form.value || ''}
                    onChange={e => setForm(f => ({ ...f, value: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="e.g. yes, California"
                  />
                </div>
              ) : (
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Match Values (list)</label>
                  <div className="flex gap-2 mb-2">
                    <input
                      value={listInput}
                      onChange={e => setListInput(e.target.value)}
                      onKeyDown={e => { if (e.key === 'Enter') { e.preventDefault(); addListItem(); }}}
                      className="flex-1 px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Add value..."
                    />
                    <button onClick={addListItem} className="w-12 h-12 flex items-center justify-center bg-blue-700 text-white rounded-xl hover:bg-blue-800">
                      <Plus size={18} />
                    </button>
                  </div>
                  <div className="flex flex-wrap gap-2">
                    {(form.value_list || []).map((v, i) => (
                      <span key={i} className="flex items-center gap-1.5 bg-slate-100 text-sm px-3 py-1.5 rounded-lg">
                        {v}
                        <button onClick={() => setForm(f => ({ ...f, value_list: (f.value_list || []).filter((_, idx) => idx !== i) }))} className="text-slate-400 hover:text-red-500">
                          <X size={13} />
                        </button>
                      </span>
                    ))}
                  </div>
                </div>
              )}

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Description (optional)</label>
                <input
                  value={form.description || ''}
                  onChange={e => setForm(f => ({ ...f, description: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <label className="flex items-start gap-3 cursor-pointer min-h-[48px] bg-red-50 rounded-xl p-3">
                <input
                  type="checkbox"
                  checked={form.is_disqualifying || false}
                  onChange={e => setForm(f => ({ ...f, is_disqualifying: e.target.checked }))}
                  className="mt-0.5 w-5 h-5 rounded border-slate-300 text-red-600 focus:ring-red-500"
                />
                <div>
                  <span className="text-sm font-medium text-slate-800">Disqualifying Rule</span>
                  <p className="text-xs text-slate-500 mt-0.5">Marks user as Not Eligible regardless of other rules.</p>
                </div>
              </label>
            </div>

            <div className="p-4 border-t border-slate-100 flex gap-3 pb-safe">
              <button onClick={() => setShowForm(false)} className="flex-1 min-h-[48px] border border-slate-300 text-slate-700 font-medium rounded-xl text-sm">Cancel</button>
              <button
                onClick={handleSave}
                disabled={saving || !form.field_key}
                className="flex-1 min-h-[48px] bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 text-white font-semibold rounded-xl text-sm transition-colors"
              >
                {saving ? 'Saving...' : 'Add Rule'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
