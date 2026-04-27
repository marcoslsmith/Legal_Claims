import React, { useEffect, useState } from 'react';
import { Plus, X, Trash2, ChevronRight } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import type { Case, Question, CaseQuestion } from '../../types/database';

interface CaseQuestionRow extends CaseQuestion {
  question: Question;
}

export default function CaseForms() {
  const [cases, setCases] = useState<Case[]>([]);
  const [selectedCase, setSelectedCase] = useState<Case | null>(null);
  const [showCaseList, setShowCaseList] = useState(true);
  const [caseQs, setCaseQs] = useState<CaseQuestionRow[]>([]);
  const [allQuestions, setAllQuestions] = useState<Question[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [showAddQ, setShowAddQ] = useState(false);
  const [selectedQId, setSelectedQId] = useState('');
  const [requiredForCase, setRequiredForCase] = useState(false);
  const [conditionQId, setConditionQId] = useState('');
  const [conditionAnswer, setConditionAnswer] = useState('');

  useEffect(() => {
    supabase.from('cases').select('*').eq('status', 'active').order('priority_score', { ascending: false })
      .then(({ data }) => setCases(data || []));
    supabase.from('questions').select('*').order('question_text')
      .then(({ data }) => setAllQuestions(data || []));
  }, []);

  const selectCase = async (c: Case) => {
    setLoading(true);
    setSelectedCase(c);
    setShowCaseList(false);
    const { data } = await supabase
      .from('case_questions')
      .select('*, questions(*)')
      .eq('case_id', c.id)
      .order('display_order');
    setCaseQs((data as any[] || []).map(cq => ({ ...cq, question: cq.questions })));
    setLoading(false);
  };

  const handleAddQuestion = async () => {
    if (!selectedCase || !selectedQId) return;
    setSaving(true);
    await supabase.from('case_questions').insert({
      case_id: selectedCase.id,
      question_id: selectedQId,
      display_order: caseQs.length + 1,
      required_for_case: requiredForCase,
      condition_question_id: conditionQId || null,
      condition_answer: conditionAnswer || null,
    });
    const { data } = await supabase
      .from('case_questions')
      .select('*, questions(*)')
      .eq('case_id', selectedCase.id)
      .order('display_order');
    setCaseQs((data as any[] || []).map(cq => ({ ...cq, question: cq.questions })));
    setShowAddQ(false);
    setSelectedQId('');
    setRequiredForCase(false);
    setConditionQId('');
    setConditionAnswer('');
    setSaving(false);
  };

  const handleRemove = async (cqId: string) => {
    await supabase.from('case_questions').delete().eq('id', cqId);
    setCaseQs(prev => prev.filter(cq => cq.id !== cqId));
  };

  const handleToggleRequired = async (cq: CaseQuestionRow) => {
    await supabase.from('case_questions').update({ required_for_case: !cq.required_for_case }).eq('id', cq.id);
    setCaseQs(prev => prev.map(q => q.id === cq.id ? { ...q, required_for_case: !cq.required_for_case } : q));
  };

  const alreadyAdded = new Set(caseQs.map(cq => cq.question_id));
  const availableToAdd = allQuestions.filter(q => !alreadyAdded.has(q.id));

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
        <h1 className="text-lg sm:text-xl font-bold text-slate-900">Case Form Builder</h1>
      </div>

      <div className="lg:grid lg:grid-cols-3 lg:gap-6">
        {/* Case list — full screen on mobile, panel on desktop */}
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
                  <div>
                    <div className="font-medium text-sm">{c.name}</div>
                    <div className={`text-xs mt-0.5 ${selectedCase?.id === c.id ? 'text-blue-200' : 'text-slate-400'}`}>
                      {c.case_type === 'mass_tort' ? 'Mass Tort' : 'Class Action'}
                    </div>
                  </div>
                  <ChevronRight size={16} className={selectedCase?.id === c.id ? 'text-blue-200' : 'text-slate-400'} />
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Questions panel */}
        <div className={`${!showCaseList || selectedCase ? 'block' : 'hidden lg:block'} lg:col-span-2 bg-white rounded-xl border border-slate-200 p-4`}>
          {!selectedCase ? (
            <div className="hidden lg:flex items-center justify-center h-40 text-slate-400 text-sm">
              Select a case to manage its form questions
            </div>
          ) : (
            <>
              <div className="flex items-center justify-between mb-4">
                <div>
                  <h2 className="font-semibold text-slate-900 text-sm">{selectedCase.name}</h2>
                  <p className="text-xs text-slate-500 mt-0.5">{caseQs.length} question{caseQs.length !== 1 ? 's' : ''}</p>
                </div>
                <button
                  onClick={() => setShowAddQ(true)}
                  className="flex items-center gap-1.5 bg-blue-700 hover:bg-blue-800 text-white text-sm font-semibold px-4 py-2.5 rounded-xl transition-colors min-h-[44px]"
                >
                  <Plus size={15} /> Add
                </button>
              </div>

              {loading ? (
                <div className="flex items-center justify-center py-10">
                  <div className="w-6 h-6 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
                </div>
              ) : caseQs.length === 0 ? (
                <div className="text-center py-12 text-slate-400 text-sm">
                  No questions added yet.
                </div>
              ) : (
                <div className="space-y-2">
                  {caseQs.map((cq, idx) => (
                    <div key={cq.id} className="flex items-start gap-3 bg-slate-50 rounded-xl p-3.5">
                      <span className="text-xs text-slate-400 font-mono mt-1 w-5 shrink-0 text-center">{idx + 1}</span>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm text-slate-800 font-medium leading-snug">{cq.question.question_text}</p>
                        <div className="flex items-center gap-2 mt-2 flex-wrap">
                          <span className="font-mono text-xs text-slate-500 bg-white border border-slate-200 px-1.5 py-0.5 rounded">{cq.question.field_key}</span>
                          <span className="text-xs text-blue-700 bg-blue-50 px-1.5 py-0.5 rounded">{cq.question.question_type}</span>
                          {cq.condition_question_id && <span className="text-xs text-amber-700 bg-amber-50 px-1.5 py-0.5 rounded">Conditional</span>}
                        </div>
                        <label className="flex items-center gap-2 mt-2 cursor-pointer min-h-[32px]">
                          <input
                            type="checkbox"
                            checked={cq.required_for_case || false}
                            onChange={() => handleToggleRequired(cq)}
                            className="w-4 h-4 rounded border-slate-300 text-blue-600"
                          />
                          <span className="text-xs text-slate-600">Required</span>
                        </label>
                      </div>
                      <button
                        onClick={() => handleRemove(cq.id)}
                        className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-colors shrink-0"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </>
          )}
        </div>
      </div>

      {/* Add question — bottom sheet on mobile */}
      {showAddQ && (
        <div className="fixed inset-0 z-50 flex flex-col justify-end lg:items-center lg:justify-center lg:bg-black/50 lg:px-4">
          <div className="bg-white w-full lg:max-w-md lg:rounded-2xl rounded-t-3xl shadow-xl">
            <div className="px-5 py-4 border-b border-slate-200 flex items-center justify-between">
              <h3 className="font-bold text-slate-900">Add Question</h3>
              <button onClick={() => setShowAddQ(false)} className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-xl">
                <X size={20} />
              </button>
            </div>
            <div className="p-5 space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Question</label>
                <select
                  value={selectedQId}
                  onChange={e => setSelectedQId(e.target.value)}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                >
                  <option value="">Choose a question...</option>
                  {availableToAdd.map(q => (
                    <option key={q.id} value={q.id}>{q.question_text.slice(0, 60)}{q.question_text.length > 60 ? '...' : ''}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Show only if (optional)</label>
                <select
                  value={conditionQId}
                  onChange={e => setConditionQId(e.target.value)}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white mb-2"
                >
                  <option value="">Always show</option>
                  {caseQs.map(cq => (
                    <option key={cq.question_id} value={cq.question_id}>{cq.question.question_text.slice(0, 50)}</option>
                  ))}
                </select>
                {conditionQId && (
                  <input
                    value={conditionAnswer}
                    onChange={e => setConditionAnswer(e.target.value)}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Show if answer equals (e.g. yes)"
                  />
                )}
              </div>

              <label className="flex items-center gap-3 cursor-pointer min-h-[44px]">
                <input
                  type="checkbox"
                  checked={requiredForCase}
                  onChange={e => setRequiredForCase(e.target.checked)}
                  className="w-5 h-5 rounded border-slate-300 text-blue-600"
                />
                <span className="text-sm text-slate-700">Required for this case</span>
              </label>
            </div>
            <div className="p-4 border-t border-slate-100 flex gap-3 pb-safe">
              <button onClick={() => setShowAddQ(false)} className="flex-1 min-h-[48px] border border-slate-300 text-slate-700 font-medium rounded-xl text-sm">Cancel</button>
              <button
                onClick={handleAddQuestion}
                disabled={!selectedQId || saving}
                className="flex-1 min-h-[48px] bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 text-white font-semibold rounded-xl text-sm transition-colors"
              >
                {saving ? 'Adding...' : 'Add Question'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
