import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowRight, ArrowLeft, Info } from 'lucide-react';
import { ProgressBar } from '../components/ProgressBar';
import { FlowStepper } from '../components/FlowStepper';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import {
  multiSelectValuesForSave,
  parseMultiSelectStored,
  parseQuestionOptions,
  serializeMultiSelect,
} from '../lib/multiSelect';
import type { Case, Question } from '../types/database';

const FLOW_STEPS = [
  { label: 'Eligibility' },
  { label: 'Contact' },
  { label: 'Intake' },
  { label: 'Consent' },
  { label: 'Done' },
];

interface IntakeQuestion extends Question {
  required_for_case: boolean;
  display_order: number;
  condition_question_id: string | null;
  condition_answer: string | null;
}

export default function Intake() {
  const { slug } = useParams<{ slug: string }>();
  const { user } = useAuth();
  const navigate = useNavigate();

  const [caseData, setCaseData] = useState<Case | null>(null);
  const [questions, setQuestions] = useState<IntakeQuestion[]>([]);
  const [existingAnswers, setExistingAnswers] = useState<Record<string, string>>({});
  const [currentAnswers, setCurrentAnswers] = useState<Record<string, string>>({});
  const [step, setStep] = useState(0);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (!user) { navigate('/auth'); return; }
    loadData();
  }, [user, slug]);

  const loadData = async () => {
    const { data: caseRow } = await supabase.from('cases').select('*').eq('slug', slug).maybeSingle();
    if (!caseRow) { navigate('/results'); return; }
    setCaseData(caseRow);

    const { data: caseQs } = await supabase
      .from('case_questions')
      .select('*, questions!case_questions_question_id_fkey(*)')
      .eq('case_id', caseRow.id)
      .order('display_order');

    const { data: existingAns } = await supabase
      .from('answers')
      .select('*')
      .eq('user_id', user!.id);

    const intakeQs: IntakeQuestion[] = (caseQs || []).map((cq: any) => ({
      ...(cq['questions!case_questions_question_id_fkey'] || cq.questions),
      required_for_case: cq.required_for_case,
      display_order: cq.display_order,
      condition_question_id: cq.condition_question_id,
      condition_answer: cq.condition_answer,
    }));

    setQuestions(intakeQs);

    const answerMap: Record<string, string> = {};
    (existingAns || []).forEach(a => {
      const q = intakeQs.find(row => row.field_key === a.field_key);
      const knownOptions = q ? parseQuestionOptions(q.answer_options) : [];
      if (a.answer_values?.length) {
        answerMap[a.field_key] = serializeMultiSelect(a.answer_values);
      } else if (a.answer_value) {
        answerMap[a.field_key] = serializeMultiSelect(
          parseMultiSelectStored(a.answer_value, knownOptions),
        );
      }
    });
    setExistingAnswers(answerMap);
    setCurrentAnswers(answerMap);

    // Compute visible questions at load time (using the pre-loaded answerMap for conditions)
    const visibleAtLoad = intakeQs.filter(q => {
      if (!q.condition_question_id) return true;
      const condQ = intakeQs.find(cq => cq.id === q.condition_question_id);
      if (!condQ) return true;
      return answerMap[condQ.field_key] === q.condition_answer;
    });

    // Jump to first unanswered question so profile fields filled in the quiz are skipped
    const firstUnanswered = visibleAtLoad.findIndex(q => !answerMap[q.field_key]);
    setStep(firstUnanswered === -1 ? visibleAtLoad.length : firstUnanswered);

    setLoading(false);
  };

  const visibleQuestions = questions.filter(q => {
    if (!q.condition_question_id) return true;
    const condQ = questions.find(cq => cq.id === q.condition_question_id);
    if (!condQ) return true;
    return currentAnswers[condQ.field_key] === q.condition_answer;
  });

  const currentQ = visibleQuestions[step];

  const handleAnswer = (value: string) => {
    if (!currentQ) return;
    setCurrentAnswers(prev => ({ ...prev, [currentQ.field_key]: value }));
  };

  const handleMultiSelect = (value: string) => {
    if (!currentQ) return;
    const options = parseQuestionOptions(currentQ.answer_options);
    const selected = parseMultiSelectStored(currentAnswers[currentQ.field_key] || '', options);
    const idx = selected.indexOf(value);
    if (idx > -1) selected.splice(idx, 1);
    else selected.push(value);
    setCurrentAnswers(prev => ({
      ...prev,
      [currentQ.field_key]: serializeMultiSelect(selected),
    }));
  };

  const handleNext = async () => {
    if (step < visibleQuestions.length - 1) setStep(s => s + 1);
    else await saveAndContinue();
  };

  const handleBack = () => { if (step > 0) setStep(s => s - 1); };

  const saveAndContinue = async () => {
    if (!user || !caseData) return;
    setSaving(true);

    let { data: submission } = await supabase
      .from('submissions')
      .select('*')
      .eq('user_id', user.id)
      .eq('case_id', caseData.id)
      .maybeSingle();

    if (!submission) {
      const { data: newSub } = await supabase
        .from('submissions')
        .insert({ user_id: user.id, case_id: caseData.id, status: 'in_progress' })
        .select()
        .single();
      submission = newSub;
    }

    for (const q of visibleQuestions) {
      const val = currentAnswers[q.field_key];
      if (!val) continue;
      const isMulti = q.question_type === 'multi_select';
      const knownOptions = parseQuestionOptions(q.answer_options);
      const multiValues = isMulti ? multiSelectValuesForSave(val, knownOptions) : null;
      await supabase.from('answers').upsert({
        user_id: user.id,
        submission_id: submission?.id,
        question_id: q.id,
        field_key: q.field_key,
        answer_value: isMulti ? null : val,
        answer_values: multiValues,
      }, { onConflict: 'user_id,question_id' });
    }

    setSaving(false);
    navigate(`/consent/${caseData.slug}`);
  };

  if (loading) return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  if (!caseData || visibleQuestions.length === 0) {
    return (
      <div className="bg-slate-50 min-h-[calc(100vh-56px)] flex flex-col">
        <FlowStepper steps={FLOW_STEPS} currentStep={2} />
      <div className="max-w-lg mx-auto px-4 py-16 text-center flex-1">
        <h2 className="font-bold text-slate-900 mb-2">No additional questions needed</h2>
        <p className="text-slate-500 text-sm mb-6 leading-relaxed">You've already provided all the required information for this case.</p>
        <button
          onClick={saveAndContinue}
          disabled={saving}
          className="bg-blue-700 hover:bg-blue-800 text-white font-semibold px-8 py-3.5 rounded-xl transition-colors text-sm min-h-[48px]"
        >
          {saving ? 'Processing...' : 'Continue to Consent →'}
        </button>
      </div>
      </div>
    );
  }

  const q = currentQ;
  if (!q) return null;
  const currentVal = currentAnswers[q.field_key] || '';
  const isAlreadyAnswered = !!existingAnswers[q.field_key];
  const optionsArr: string[] = parseQuestionOptions(q.answer_options);
  const selectedMulti = parseMultiSelectStored(currentVal, optionsArr);

  // date_range stores as "YYYY-MM-DD|YYYY-MM-DD"
  const [dateRangeStart, dateRangeEnd] = q.question_type === 'date_range' && currentVal.includes('|')
    ? currentVal.split('|')
    : ['', ''];
  const handleDateRangeChange = (which: 'start' | 'end', val: string) => {
    const [s, e] = currentVal.includes('|') ? currentVal.split('|') : ['', ''];
    const next = which === 'start' ? `${val}|${e}` : `${s}|${val}`;
    handleAnswer(next);
  };

  const canAdvance =
    currentVal ||
    q.question_type === 'multi_select' ||
    q.question_type === 'text' ||
    q.question_type === 'number' ||
    q.question_type === 'date' ||
    q.question_type === 'date_range';

  return (
    <div className="min-h-[calc(100vh-56px)] bg-slate-50 flex flex-col">
      <FlowStepper steps={FLOW_STEPS} currentStep={2} />
      {/* Progress */}
      <div className="max-w-lg mx-auto w-full px-4 sm:px-6 pt-3 pb-4">
        <p className="text-xs font-medium text-slate-500 mb-2 truncate">{caseData.name}</p>
        <ProgressBar current={step + 1} total={visibleQuestions.length} label="Claim Intake" />
      </div>

      <div className="flex-1 max-w-lg mx-auto w-full px-4 sm:px-6 pb-6 flex flex-col">
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden flex-1 flex flex-col">
          {/* Question header */}
          <div className="px-6 py-5 border-b border-slate-100">
            {isAlreadyAnswered && (
              <div className="flex items-center gap-2 bg-blue-50 border border-blue-200 text-blue-700 rounded-xl px-3 py-2 mb-3 text-xs">
                <Info size={14} className="shrink-0" />
                We already have your answer — you can update it below.
              </div>
            )}
            <p className="text-xs text-blue-600 font-semibold uppercase tracking-wider mb-2">
              Question {step + 1} of {visibleQuestions.length}
            </p>
            <h2 className="text-lg sm:text-xl font-bold text-slate-900 leading-snug">{q.question_text}</h2>
            {q.help_text && (
              <p className="text-sm text-slate-500 mt-2 leading-relaxed">{q.help_text}</p>
            )}
          </div>

          {/* Answer area */}
          <div className="flex-1 px-6 py-5 overflow-y-auto">
            {q.question_type === 'yes_no' && (
              <div className="space-y-3">
                {[
                  { value: 'yes', label: 'Yes', desc: 'This applies to me' },
                  { value: 'no', label: 'No', desc: 'This does not apply' },
                ].map(opt => (
                  <button
                    key={opt.value}
                    onClick={() => handleAnswer(opt.value)}
                    className={`w-full text-left px-5 py-4 rounded-xl border-2 transition-all duration-150 min-h-[64px] ${
                      currentVal === opt.value
                        ? 'border-blue-600 bg-blue-50'
                        : 'border-slate-200 hover:border-blue-200 active:bg-slate-50'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 ${currentVal === opt.value ? 'border-blue-600 bg-blue-600' : 'border-slate-300'}`}>
                        {currentVal === opt.value && <div className="w-2 h-2 rounded-full bg-white" />}
                      </div>
                      <div>
                        <span className={`font-semibold text-sm ${currentVal === opt.value ? 'text-blue-700' : 'text-slate-800'}`}>{opt.label}</span>
                        <p className="text-xs text-slate-500 mt-0.5">{opt.desc}</p>
                      </div>
                    </div>
                  </button>
                ))}
              </div>
            )}

            {q.question_type === 'dropdown' && (
              <div className="space-y-2">
                {optionsArr.map(opt => (
                  <button
                    key={opt}
                    onClick={() => handleAnswer(opt)}
                    className={`w-full text-left px-5 py-3.5 rounded-xl border-2 transition-all duration-150 min-h-[52px] text-sm font-medium ${
                      currentVal === opt
                        ? 'border-blue-600 bg-blue-50 text-blue-700'
                        : 'border-slate-200 text-slate-700 hover:border-blue-200 active:bg-slate-50'
                    }`}
                  >
                    {opt}
                  </button>
                ))}
              </div>
            )}

            {q.question_type === 'multi_select' && (
              <div className="space-y-2">
                {optionsArr.map(opt => (
                  <button
                    key={opt}
                    onClick={() => handleMultiSelect(opt)}
                    className={`w-full text-left px-5 py-3.5 rounded-xl border-2 transition-all duration-150 min-h-[52px] flex items-center gap-3 ${
                      selectedMulti.includes(opt)
                        ? 'border-blue-600 bg-blue-50'
                        : 'border-slate-200 hover:border-blue-200 active:bg-slate-50'
                    }`}
                  >
                    <span className={`w-5 h-5 rounded border-2 flex items-center justify-center shrink-0 transition-colors ${selectedMulti.includes(opt) ? 'border-blue-600 bg-blue-600' : 'border-slate-300'}`}>
                      {selectedMulti.includes(opt) && (
                        <svg className="w-3 h-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                          <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                        </svg>
                      )}
                    </span>
                    <span className={`text-sm font-medium ${selectedMulti.includes(opt) ? 'text-blue-700' : 'text-slate-700'}`}>{opt}</span>
                  </button>
                ))}
                <p className="text-xs text-slate-400 mt-1 px-1">Select all that apply</p>
              </div>
            )}

            {q.question_type === 'text' && (
              <textarea
                value={currentVal}
                onChange={e => handleAnswer(e.target.value)}
                rows={3}
                className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                placeholder="Type your answer..."
              />
            )}

            {q.question_type === 'number' && (
              <input
                type="number"
                value={currentVal}
                onChange={e => handleAnswer(e.target.value)}
                className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Enter a number..."
              />
            )}

            {q.question_type === 'date' && (
              <input
                type="date"
                value={currentVal}
                onChange={e => handleAnswer(e.target.value)}
                className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            )}

            {q.question_type === 'date_range' && (
              <div className="space-y-3">
                <div>
                  <label className="block text-xs font-semibold text-slate-600 mb-1.5">From (approx.)</label>
                  <input
                    type="date"
                    value={dateRangeStart}
                    onChange={e => handleDateRangeChange('start', e.target.value)}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-xs font-semibold text-slate-600 mb-1.5">To (approx., or leave blank if ongoing)</label>
                  <input
                    type="date"
                    value={dateRangeEnd}
                    onChange={e => handleDateRangeChange('end', e.target.value)}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <p className="text-xs text-slate-400">A best-guess range is fine — exact dates are not required.</p>
              </div>
            )}
          </div>

          {/* Navigation */}
          <div className="px-6 py-4 border-t border-slate-100 flex items-center gap-3">
            <button
              onClick={handleBack}
              disabled={step === 0}
              className="w-11 h-11 flex items-center justify-center text-slate-500 hover:text-slate-700 disabled:opacity-30 disabled:cursor-not-allowed transition-colors rounded-xl hover:bg-slate-100"
            >
              <ArrowLeft size={20} />
            </button>
            <button
              onClick={handleNext}
              disabled={!canAdvance || saving}
              className="flex-1 flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 disabled:bg-slate-200 disabled:text-slate-400 text-white font-semibold py-3 rounded-xl transition-colors text-sm min-h-[48px]"
            >
              {saving ? (
                <div className="w-5 h-5 border-2 border-white/40 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  {step === visibleQuestions.length - 1 ? 'Continue to Consent' : 'Next'}
                  <ArrowRight size={17} />
                </>
              )}
            </button>
          </div>
        </div>

        <p className="text-xs text-slate-400 text-center mt-4 leading-relaxed">
          This is not legal advice. Your answers help identify potentially relevant claims only.
        </p>
      </div>
    </div>
  );
}
