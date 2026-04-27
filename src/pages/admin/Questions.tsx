import React, { useEffect, useState } from 'react';
import { Plus, Pencil, X } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import type { Question } from '../../types/database';

const CATEGORIES = ['profile', 'medical', 'product_exposure', 'employment', 'military', 'data_breach', 'consumer', 'case_specific'];
const TYPES = ['text', 'number', 'date', 'dropdown', 'multi_select', 'yes_no', 'file_upload'];

const EMPTY: Partial<Question> = {
  question_text: '', field_key: '', question_type: 'yes_no',
  answer_options: [], required: false, is_profile_field: false,
  category: 'medical', help_text: '',
};

const categoryColors: Record<string, string> = {
  profile: 'bg-slate-100 text-slate-600',
  medical: 'bg-red-50 text-red-700',
  product_exposure: 'bg-amber-50 text-amber-700',
  employment: 'bg-blue-50 text-blue-700',
  military: 'bg-green-50 text-green-700',
  data_breach: 'bg-orange-50 text-orange-700',
  consumer: 'bg-teal-50 text-teal-700',
  case_specific: 'bg-purple-50 text-purple-700',
};

export default function Questions() {
  const [questions, setQuestions] = useState<Question[]>([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState<Partial<Question>>(EMPTY);
  const [editing, setEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [showForm, setShowForm] = useState(false);
  const [optionInput, setOptionInput] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');

  useEffect(() => { loadQuestions(); }, []);

  const loadQuestions = async () => {
    const { data } = await supabase.from('questions').select('*').order('category').order('question_text');
    setQuestions(data || []);
    setLoading(false);
  };

  const openNew = () => { setForm(EMPTY); setEditing(false); setShowForm(true); setOptionInput(''); };
  const openEdit = (q: Question) => { setForm(q); setEditing(true); setShowForm(true); setOptionInput(''); };

  const handleSave = async () => {
    setSaving(true);
    if (editing && form.id) {
      await supabase.from('questions').update({ ...form, updated_at: new Date().toISOString() }).eq('id', form.id);
    } else {
      await supabase.from('questions').insert({ ...form, id: undefined });
    }
    await loadQuestions();
    setShowForm(false);
    setSaving(false);
  };

  const addOption = () => {
    if (!optionInput.trim()) return;
    const current = (form.answer_options as string[]) || [];
    setForm(f => ({ ...f, answer_options: [...current, optionInput.trim()] }));
    setOptionInput('');
  };

  const removeOption = (idx: number) => {
    const current = (form.answer_options as string[]) || [];
    setForm(f => ({ ...f, answer_options: current.filter((_, i) => i !== idx) }));
  };

  const filtered = questions.filter(q => !categoryFilter || q.category === categoryFilter);

  return (
    <div className="p-4 sm:p-6">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-lg sm:text-xl font-bold text-slate-900">Question Bank</h1>
        <button
          onClick={openNew}
          className="flex items-center gap-2 bg-blue-700 hover:bg-blue-800 text-white text-sm font-semibold px-4 py-2.5 rounded-xl transition-colors min-h-[44px]"
        >
          <Plus size={16} /> New Question
        </button>
      </div>

      {/* Category filter chips — horizontal scroll on mobile */}
      <div className="flex gap-2 mb-4 overflow-x-auto pb-1 -mx-4 px-4 sm:mx-0 sm:px-0 sm:flex-wrap">
        <button
          onClick={() => setCategoryFilter('')}
          className={`px-3 py-2 rounded-xl text-xs font-medium transition-colors shrink-0 min-h-[36px] ${!categoryFilter ? 'bg-blue-700 text-white' : 'bg-white border border-slate-200 text-slate-600'}`}
        >
          All ({questions.length})
        </button>
        {CATEGORIES.map(cat => {
          const count = questions.filter(q => q.category === cat).length;
          if (count === 0) return null;
          return (
            <button
              key={cat}
              onClick={() => setCategoryFilter(cat)}
              className={`px-3 py-2 rounded-xl text-xs font-medium transition-colors shrink-0 min-h-[36px] ${categoryFilter === cat ? 'bg-blue-700 text-white' : 'bg-white border border-slate-200 text-slate-600'}`}
            >
              {cat.replace(/_/g, ' ')} ({count})
            </button>
          );
        })}
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-16">
          <div className="w-7 h-7 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <div className="space-y-2">
          {filtered.map(q => (
            <div key={q.id} className="bg-white rounded-xl border border-slate-200 p-4">
              <div className="flex items-start gap-3">
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-slate-900 leading-snug mb-2">{q.question_text}</p>
                  <div className="flex items-center gap-2 flex-wrap">
                    <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${categoryColors[q.category || ''] || 'bg-slate-100 text-slate-600'}`}>
                      {q.category?.replace(/_/g, ' ')}
                    </span>
                    <span className="text-xs px-2 py-0.5 rounded-full bg-slate-100 text-slate-600 font-medium">
                      {q.question_type?.replace(/_/g, ' ')}
                    </span>
                    <span className="font-mono text-xs text-slate-400">{q.field_key}</span>
                  </div>
                  <div className="flex gap-3 mt-2">
                    {q.required && <span className="text-xs text-red-600 font-medium">Required</span>}
                    {q.is_profile_field && <span className="text-xs text-emerald-600 font-medium">Profile field</span>}
                  </div>
                </div>
                <button
                  onClick={() => openEdit(q)}
                  className="w-11 h-11 flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-xl transition-colors shrink-0"
                >
                  <Pencil size={17} />
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Form — full screen on mobile */}
      {showForm && (
        <div className="fixed inset-0 z-50 flex flex-col lg:items-center lg:justify-start lg:pt-8 lg:bg-black/50 lg:px-4 lg:pb-8 lg:overflow-y-auto">
          <div className="bg-white w-full lg:max-w-xl lg:rounded-2xl flex flex-col h-full lg:h-auto shadow-xl">
            <div className="sticky top-0 bg-white lg:rounded-t-2xl border-b border-slate-200 px-5 py-4 flex items-center justify-between">
              <h2 className="font-bold text-slate-900">{editing ? 'Edit Question' : 'New Question'}</h2>
              <button onClick={() => setShowForm(false)} className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-xl">
                <X size={20} />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-5 space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Question Text</label>
                <textarea
                  rows={3}
                  value={form.question_text || ''}
                  onChange={e => setForm(f => ({ ...f, question_text: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Field Key</label>
                <input
                  value={form.field_key || ''}
                  onChange={e => setForm(f => ({ ...f, field_key: e.target.value.toLowerCase().replace(/\s+/g, '_') }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono"
                  placeholder="my_field_key"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Type</label>
                  <select
                    value={form.question_type || 'yes_no'}
                    onChange={e => setForm(f => ({ ...f, question_type: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                  >
                    {TYPES.map(t => <option key={t} value={t}>{t.replace(/_/g, ' ')}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Category</label>
                  <select
                    value={form.category || 'medical'}
                    onChange={e => setForm(f => ({ ...f, category: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                  >
                    {CATEGORIES.map(c => <option key={c} value={c}>{c.replace(/_/g, ' ')}</option>)}
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Help Text (optional)</label>
                <input
                  value={form.help_text || ''}
                  onChange={e => setForm(f => ({ ...f, help_text: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              {['dropdown', 'multi_select'].includes(form.question_type || '') && (
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Answer Options</label>
                  <div className="flex gap-2 mb-2">
                    <input
                      value={optionInput}
                      onChange={e => setOptionInput(e.target.value)}
                      onKeyDown={e => { if (e.key === 'Enter') { e.preventDefault(); addOption(); }}}
                      className="flex-1 px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Add option..."
                    />
                    <button
                      onClick={addOption}
                      className="w-12 h-12 flex items-center justify-center bg-blue-700 text-white rounded-xl hover:bg-blue-800 transition-colors"
                    >
                      <Plus size={18} />
                    </button>
                  </div>
                  <div className="flex flex-wrap gap-2">
                    {((form.answer_options as string[]) || []).map((opt, idx) => (
                      <span key={idx} className="flex items-center gap-1.5 bg-slate-100 text-slate-700 text-sm px-3 py-1.5 rounded-lg">
                        {opt}
                        <button onClick={() => removeOption(idx)} className="text-slate-400 hover:text-red-500 p-0.5">
                          <X size={13} />
                        </button>
                      </span>
                    ))}
                  </div>
                </div>
              )}

              <div className="flex flex-col gap-3 pt-2">
                <label className="flex items-center gap-3 cursor-pointer min-h-[44px]">
                  <input
                    type="checkbox"
                    checked={form.required || false}
                    onChange={e => setForm(f => ({ ...f, required: e.target.checked }))}
                    className="w-5 h-5 rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                  />
                  <span className="text-sm text-slate-700">Required question</span>
                </label>
                <label className="flex items-center gap-3 cursor-pointer min-h-[44px]">
                  <input
                    type="checkbox"
                    checked={form.is_profile_field || false}
                    onChange={e => setForm(f => ({ ...f, is_profile_field: e.target.checked }))}
                    className="w-5 h-5 rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                  />
                  <span className="text-sm text-slate-700">Reusable profile field (don't ask again)</span>
                </label>
              </div>
            </div>

            <div className="sticky bottom-0 bg-white border-t border-slate-100 p-4 flex gap-3">
              <button onClick={() => setShowForm(false)} className="flex-1 min-h-[48px] border border-slate-300 text-slate-700 font-medium rounded-xl text-sm">Cancel</button>
              <button
                onClick={handleSave}
                disabled={saving || !form.question_text || !form.field_key}
                className="flex-1 min-h-[48px] bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 text-white font-semibold rounded-xl text-sm transition-colors"
              >
                {saving ? 'Saving...' : 'Save Question'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
