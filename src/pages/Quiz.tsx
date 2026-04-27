import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowRight, ArrowLeft, CheckCircle2, Pencil } from 'lucide-react';
import { ProgressBar } from '../components/ProgressBar';
import { FlowStepper } from '../components/FlowStepper';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import type { Question } from '../types/database';

const FLOW_STEPS = [
  { label: 'Eligibility' },
  { label: 'Contact' },
  { label: 'Intake' },
  { label: 'Consent' },
  { label: 'Done' },
];

const BROAD_QUIZ_KEYS = [
  'state_of_residence',
  'used_prescription_medications',
  'used_lawsuit_products',
  'diagnosed_serious_condition',
  'military_or_contaminated_site',
  'received_data_breach_notice',
  'experienced_employment_issues',
  'experienced_consumer_issues',
];

type Mode = 'loading' | 'review' | 'quiz';

export default function Quiz() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [questions, setQuestions] = useState<Question[]>([]);
  const [step, setStep] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [mode, setMode] = useState<Mode>('loading');
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (!user) { navigate('/auth?next=quiz'); return; }
    loadQuestions();
  }, [user]);

  const loadQuestions = async () => {
    const [{ data: qData }, { data: existingAns }] = await Promise.all([
      supabase.from('questions').select('*').in('field_key', BROAD_QUIZ_KEYS),
      supabase.from('answers').select('*').eq('user_id', user!.id).in('field_key', BROAD_QUIZ_KEYS),
    ]);

    const ordered = BROAD_QUIZ_KEYS
      .map(k => qData?.find(q => q.field_key === k))
      .filter(Boolean) as Question[];
    setQuestions(ordered);

    const answerMap: Record<string, string> = {};
    (existingAns || []).forEach(a => { answerMap[a.field_key] = a.answer_value || ''; });
    setAnswers(answerMap);

    const allAnswered = ordered.length > 0 && ordered.every(q => answerMap[q.field_key]);
    setMode(allAnswered ? 'review' : 'quiz');
  };

  const handleAnswer = (value: string) => {
    if (!questions[step]) return;
    setAnswers(prev => ({ ...prev, [questions[step].field_key]: value }));
  };

  const handleNext = () => {
    if (step < questions.length - 1) setStep(s => s + 1);
    else submitQuiz();
  };

  const handleBack = () => { if (step > 0) setStep(s => s - 1); };

  const submitQuiz = async () => {
    if (!user) return;
    setSaving(true);
    for (const [fieldKey, value] of Object.entries(answers)) {
      const q = questions.find(q => q.field_key === fieldKey);
      if (!q) continue;
      await supabase.from('answers').upsert({
        user_id: user.id,
        question_id: q.id,
        field_key: fieldKey,
        answer_value: value,
      }, { onConflict: 'user_id,question_id' });
    }
    if (answers['state_of_residence']) {
      await supabase.from('profiles').update({ state: answers['state_of_residence'] }).eq('id', user.id);
    }
    setSaving(false);
    navigate('/contact');
  };

  const startEdit = (fromStep: number) => {
    setStep(fromStep);
    setMode('quiz');
  };

  if (mode === 'loading') return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  // Review mode — show all answers with edit options
  if (mode === 'review') {
    return (
      <div className="min-h-[calc(100vh-56px)] bg-slate-50 flex flex-col">
        <FlowStepper steps={FLOW_STEPS} currentStep={0} />
        <div className="max-w-lg mx-auto w-full px-4 sm:px-6 py-6 flex-1 flex flex-col">
          <div className="mb-5">
            <div className="flex items-center gap-2 mb-1">
              <CheckCircle2 size={18} className="text-emerald-600" />
              <h1 className="text-lg font-bold text-slate-900">Your Eligibility Answers</h1>
            </div>
            <p className="text-sm text-slate-500">You've already completed this questionnaire. Review or update any answers below.</p>
          </div>

          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden mb-4">
            {questions.map((q, idx) => {
              const val = answers[q.field_key];
              return (
                <div key={q.id} className={`px-5 py-4 flex items-start gap-3 ${idx < questions.length - 1 ? 'border-b border-slate-100' : ''}`}>
                  <div className="flex-1 min-w-0">
                    <p className="text-xs text-slate-400 font-medium mb-0.5">Q{idx + 1}</p>
                    <p className="text-sm text-slate-700 leading-snug">{q.question_text}</p>
                    {val ? (
                      <p className="text-sm font-semibold text-slate-900 mt-1 capitalize">{val}</p>
                    ) : (
                      <p className="text-sm text-amber-600 mt-1 font-medium">Not answered</p>
                    )}
                  </div>
                  <button
                    onClick={() => startEdit(idx)}
                    className="w-9 h-9 flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-xl transition-colors shrink-0 mt-0.5"
                    aria-label="Edit answer"
                  >
                    <Pencil size={15} />
                  </button>
                </div>
              );
            })}
          </div>

          <div className="flex gap-3">
            <button
              onClick={() => startEdit(0)}
              className="flex-1 min-h-[52px] border border-slate-300 text-slate-700 font-medium rounded-xl text-sm hover:bg-slate-50 transition-colors"
            >
              Retake All
            </button>
            <button
              onClick={() => navigate('/results')}
              className="flex-1 min-h-[52px] bg-blue-700 hover:bg-blue-800 text-white font-semibold rounded-xl text-sm transition-colors flex items-center justify-center gap-2"
            >
              See My Matches <ArrowRight size={16} />
            </button>
          </div>

          <p className="text-xs text-slate-400 text-center mt-4 px-4 leading-relaxed">
            This is not legal advice. Your answers help identify potentially relevant claims only.
          </p>
        </div>
      </div>
    );
  }

  // Quiz mode
  const q = questions[step];
  if (!q) return null;
  const currentAnswer = answers[q.field_key] || '';
  const optionsArr: string[] = Array.isArray(q.answer_options) ? q.answer_options as string[] : [];

  return (
    <div className="min-h-[calc(100vh-56px)] bg-slate-50 flex flex-col">
      <FlowStepper steps={FLOW_STEPS} currentStep={0} />
      <div className="max-w-lg mx-auto w-full px-4 sm:px-6 pt-3 pb-4">
        <ProgressBar current={step + 1} total={questions.length} label="Eligibility Check" />
      </div>

      <div className="flex-1 max-w-lg mx-auto w-full px-4 sm:px-6 pb-6 flex flex-col">
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden flex-1 flex flex-col">
          <div className="px-6 py-5 border-b border-slate-100">
            <p className="text-xs text-blue-600 font-semibold uppercase tracking-wider mb-2">
              Question {step + 1} of {questions.length}
            </p>
            <h2 className="text-lg sm:text-xl font-bold text-slate-900 leading-snug">{q.question_text}</h2>
            {q.help_text && (
              <p className="text-sm text-slate-500 mt-2 leading-relaxed">{q.help_text}</p>
            )}
          </div>

          <div className="flex-1 px-6 py-5 overflow-y-auto">
            {q.question_type === 'yes_no' && (
              <div className="space-y-3">
                {[
                  { value: 'yes', label: 'Yes', desc: 'This applies to me' },
                  { value: 'no', label: 'No', desc: 'This does not apply to me' },
                ].map(opt => (
                  <button
                    key={opt.value}
                    onClick={() => handleAnswer(opt.value)}
                    className={`w-full text-left px-5 py-4 rounded-xl border-2 transition-all duration-150 min-h-[64px] ${
                      currentAnswer === opt.value
                        ? 'border-blue-600 bg-blue-50'
                        : 'border-slate-200 hover:border-blue-200 hover:bg-slate-50 active:bg-slate-100'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 ${currentAnswer === opt.value ? 'border-blue-600 bg-blue-600' : 'border-slate-300'}`}>
                        {currentAnswer === opt.value && <div className="w-2 h-2 rounded-full bg-white" />}
                      </div>
                      <div>
                        <span className={`font-semibold text-sm ${currentAnswer === opt.value ? 'text-blue-700' : 'text-slate-800'}`}>{opt.label}</span>
                        <p className="text-xs text-slate-500 mt-0.5">{opt.desc}</p>
                      </div>
                    </div>
                  </button>
                ))}
              </div>
            )}

            {q.question_type === 'dropdown' && (
              <div className="space-y-2">
                {optionsArr.map((opt: string) => (
                  <button
                    key={opt}
                    onClick={() => handleAnswer(opt)}
                    className={`w-full text-left px-5 py-3.5 rounded-xl border-2 transition-all duration-150 min-h-[52px] text-sm font-medium ${
                      currentAnswer === opt
                        ? 'border-blue-600 bg-blue-50 text-blue-700'
                        : 'border-slate-200 text-slate-700 hover:border-blue-200 hover:bg-slate-50 active:bg-slate-100'
                    }`}
                  >
                    {opt}
                  </button>
                ))}
              </div>
            )}
          </div>

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
              disabled={!currentAnswer || saving}
              className="flex-1 flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 disabled:bg-slate-200 disabled:text-slate-400 disabled:cursor-not-allowed text-white font-semibold py-3 rounded-xl transition-colors text-sm min-h-[48px]"
            >
              {saving ? (
                <div className="w-5 h-5 border-2 border-white/40 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  {step === questions.length - 1 ? 'Save & See Matches' : 'Next'}
                  <ArrowRight size={17} />
                </>
              )}
            </button>
          </div>
        </div>

        <p className="text-xs text-slate-400 text-center mt-4 px-4 leading-relaxed">
          This is not legal advice. Your answers help identify potentially relevant claims only.
        </p>
      </div>
    </div>
  );
}
