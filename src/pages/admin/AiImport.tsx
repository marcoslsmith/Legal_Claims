import React, { useState, useRef, useCallback } from 'react';
import {
  Sparkles, FileText, ChevronDown, ChevronUp, CheckCircle2,
  AlertCircle, Pencil, Trash2, Plus, X, Loader2, Upload,
  ArrowRight, RotateCcw, Check, FilePlus2
} from 'lucide-react';
import { supabase } from '../../lib/supabase';

// ── Types ──────────────────────────────────────────────────────────────────

interface AiCase {
  name: string;
  slug: string;
  case_type: string;
  short_description: string;
  long_description: string;
  estimated_lead_value: number;
  priority_score: number;
  internal_notes: string;
}

interface AiQuestion {
  question_text: string;
  field_key: string;
  question_type: string;
  answer_options: string[];
  category: string;
  help_text: string;
  required: boolean;
  is_profile_field: boolean;
  // resolved after commit
  _id?: string;
  _exists?: boolean; // matched to an existing question in DB
}

interface AiRule {
  field_key: string;
  operator: string;
  value: string;
  value_list: string[];
  points: number;
  is_disqualifying: boolean;
  description: string;
}

interface ParsedPayload {
  case: AiCase;
  questions: AiQuestion[];
  rules: AiRule[];
}

type CommitStatus = 'idle' | 'committing' | 'done' | 'error';

// ── Helpers ────────────────────────────────────────────────────────────────

const QUESTION_TYPES = ['yes_no', 'dropdown', 'multi_select', 'text', 'number', 'date'];
const CATEGORIES = ['profile', 'medical', 'product_exposure', 'employment', 'military', 'data_breach', 'consumer', 'case_specific'];
const OPERATORS = ['equals', 'not_equals', 'in_list', 'greater_than', 'less_than'];

const categoryColor: Record<string, string> = {
  profile: 'bg-slate-100 text-slate-600',
  medical: 'bg-red-50 text-red-700',
  product_exposure: 'bg-amber-50 text-amber-700',
  employment: 'bg-blue-50 text-blue-700',
  military: 'bg-green-50 text-green-700',
  data_breach: 'bg-orange-50 text-orange-700',
  consumer: 'bg-teal-50 text-teal-700',
  case_specific: 'bg-slate-100 text-slate-500',
};

function InlineEdit({ value, onChange, multiline = false, className = '' }: {
  value: string; onChange: (v: string) => void; multiline?: boolean; className?: string;
}) {
  const base = `w-full px-2.5 py-1.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white ${className}`;
  return multiline
    ? <textarea value={value} onChange={e => onChange(e.target.value)} rows={2} className={`${base} resize-none`} />
    : <input value={value} onChange={e => onChange(e.target.value)} className={base} />;
}

// ── Section wrappers ───────────────────────────────────────────────────────

function Section({ title, count, badge, children, defaultOpen = true }: {
  title: string; count: number; badge?: string; children: React.ReactNode; defaultOpen?: boolean;
}) {
  const [open, setOpen] = useState(defaultOpen);
  return (
    <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden">
      <button
        onClick={() => setOpen(o => !o)}
        className="w-full flex items-center justify-between px-5 py-4 hover:bg-slate-50 transition-colors"
      >
        <div className="flex items-center gap-3">
          <span className="font-semibold text-slate-900 text-sm">{title}</span>
          <span className="text-xs bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full font-medium">{count}</span>
          {badge && <span className="text-xs bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full font-medium">{badge}</span>}
        </div>
        {open ? <ChevronUp size={16} className="text-slate-400" /> : <ChevronDown size={16} className="text-slate-400" />}
      </button>
      {open && <div className="border-t border-slate-100 p-4 space-y-3">{children}</div>}
    </div>
  );
}

function readFileAsBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      const dataUrl = e.target?.result as string;
      // Strip the data URL prefix (e.g. "data:application/pdf;base64,")
      const base64 = dataUrl.split(',')[1];
      resolve(base64);
    };
    reader.onerror = () => reject(new Error('Failed to read file'));
    reader.readAsDataURL(file);
  });
}

// ── Main component ─────────────────────────────────────────────────────────

export default function AiImport() {
  const [docText, setDocText] = useState('');
  const [pdfFile, setPdfFile] = useState<File | null>(null);
  const [dragOver, setDragOver] = useState(false);
  const [inputMode, setInputMode] = useState<'text' | 'pdf'>('text');
  const [parsing, setParsing] = useState(false);
  const [parseError, setParseError] = useState('');
  const [payload, setPayload] = useState<ParsedPayload | null>(null);
  const [commitStatus, setCommitStatus] = useState<CommitStatus>('idle');
  const [commitLog, setCommitLog] = useState<string[]>([]);
  const [editingQIdx, setEditingQIdx] = useState<number | null>(null);
  const [editingRuleIdx, setEditingRuleIdx] = useState<number | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    setDragOver(false);
    const file = e.dataTransfer.files[0];
    if (file?.type === 'application/pdf') {
      setPdfFile(file);
      setInputMode('pdf');
      setParseError('');
    } else {
      setParseError('Only PDF files are supported for upload.');
    }
  }, []);

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setPdfFile(file);
      setInputMode('pdf');
      setParseError('');
    }
  };

  const clearPdf = () => {
    setPdfFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  // ── Parse ────────────────────────────────────────────────────────────────

  const handleParse = async () => {
    const hasPdf = inputMode === 'pdf' && pdfFile;
    const hasText = inputMode === 'text' && docText.trim();
    if (!hasPdf && !hasText) return;

    setParsing(true);
    setParseError('');
    setPayload(null);
    setCommitStatus('idle');
    setCommitLog([]);

    try {
      const { data: { session } } = await supabase.auth.getSession();
      const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;

      let bodyPayload: Record<string, string>;
      if (hasPdf) {
        const base64 = await readFileAsBase64(pdfFile!);
        bodyPayload = { pdf_base64: base64 };
      } else {
        bodyPayload = { document_text: docText };
      }

      const res = await fetch(`${supabaseUrl}/functions/v1/parse-case-document`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${session?.access_token}`,
          'Apikey': import.meta.env.VITE_SUPABASE_ANON_KEY,
        },
        body: JSON.stringify(bodyPayload),
      });

      const json = await res.json();
      if (!res.ok || json.error) {
        setParseError(json.error || 'Unexpected error from AI service');
        return;
      }

      const result: ParsedPayload = json.result;

      // Normalize arrays
      result.questions = (result.questions || []).map(q => ({
        ...q,
        answer_options: Array.isArray(q.answer_options) ? q.answer_options : [],
      }));
      result.rules = (result.rules || []).map(r => ({
        ...r,
        value: r.value ?? '',
        value_list: Array.isArray(r.value_list) ? r.value_list : [],
      }));

      setPayload(result);
    } catch (e) {
      setParseError(String(e));
    } finally {
      setParsing(false);
    }
  };

  // ── Case field helpers ───────────────────────────────────────────────────

  const setCase = (patch: Partial<AiCase>) =>
    setPayload(p => p ? { ...p, case: { ...p.case, ...patch } } : p);

  // ── Question helpers ─────────────────────────────────────────────────────

  const setQuestion = (idx: number, patch: Partial<AiQuestion>) =>
    setPayload(p => {
      if (!p) return p;
      const questions = [...p.questions];
      questions[idx] = { ...questions[idx], ...patch };
      return { ...p, questions };
    });

  const removeQuestion = (idx: number) =>
    setPayload(p => p ? { ...p, questions: p.questions.filter((_, i) => i !== idx) } : p);

  const addQuestion = () => {
    const blank: AiQuestion = {
      question_text: 'New question',
      field_key: `field_${Date.now()}`,
      question_type: 'yes_no',
      answer_options: [],
      category: 'case_specific',
      help_text: '',
      required: true,
      is_profile_field: false,
    };
    setPayload(p => p ? { ...p, questions: [...p.questions, blank] } : p);
    setEditingQIdx((payload?.questions.length ?? 0));
  };

  // ── Rule helpers ─────────────────────────────────────────────────────────

  const setRule = (idx: number, patch: Partial<AiRule>) =>
    setPayload(p => {
      if (!p) return p;
      const rules = [...p.rules];
      rules[idx] = { ...rules[idx], ...patch };
      return { ...p, rules };
    });

  const removeRule = (idx: number) =>
    setPayload(p => p ? { ...p, rules: p.rules.filter((_, i) => i !== idx) } : p);

  const addRule = () => {
    setPayload(p => p ? {
      ...p,
      rules: [...p.rules, {
        field_key: '', operator: 'equals', value: '', value_list: [],
        points: 20, is_disqualifying: false, description: '',
      }]
    } : p);
    setEditingRuleIdx((payload?.rules.length ?? 0));
  };

  // ── Commit ───────────────────────────────────────────────────────────────

  const handleCommit = async () => {
    if (!payload) return;
    setCommitStatus('committing');
    setCommitLog([]);
    const log = (msg: string) => setCommitLog(l => [...l, msg]);

    try {
      // 1. Insert case
      log('Creating case...');
      const { data: caseRow, error: caseErr } = await supabase
        .from('cases')
        .insert({ ...payload.case })
        .select()
        .single();
      if (caseErr) throw new Error(`Case insert failed: ${caseErr.message}`);
      log(`✓ Case created: ${caseRow.name}`);

      // 2. Upsert questions (by field_key) and collect id map
      const fieldKeyToId: Record<string, string> = {};
      for (const q of payload.questions) {
        log(`Processing question: ${q.field_key}`);
        const { data: existing } = await supabase
          .from('questions')
          .select('id')
          .eq('field_key', q.field_key)
          .maybeSingle();

        let qId: string;
        if (existing) {
          qId = existing.id;
          log(`  → Reusing existing question (${q.field_key})`);
        } else {
          const { data: newQ, error: qErr } = await supabase
            .from('questions')
            .insert({
              question_text: q.question_text,
              field_key: q.field_key,
              question_type: q.question_type,
              answer_options: q.answer_options,
              category: q.category,
              help_text: q.help_text,
              required: q.required,
              is_profile_field: q.is_profile_field,
            })
            .select()
            .single();
          if (qErr) throw new Error(`Question insert failed: ${qErr.message}`);
          qId = newQ.id;
          log(`  ✓ Created question: ${q.field_key}`);
        }
        fieldKeyToId[q.field_key] = qId;
      }

      // 3. Link questions to case (case_questions)
      log('Linking questions to case...');
      for (let i = 0; i < payload.questions.length; i++) {
        const q = payload.questions[i];
        const qId = fieldKeyToId[q.field_key];
        if (!qId) continue;
        await supabase.from('case_questions').insert({
          case_id: caseRow.id,
          question_id: qId,
          display_order: i + 1,
          required_for_case: q.required,
        });
      }
      log(`✓ Linked ${payload.questions.length} questions`);

      // 4. Insert matching rules
      log('Creating matching rules...');
      for (const rule of payload.rules) {
        await supabase.from('matching_rules').insert({
          case_id: caseRow.id,
          rule_type: 'field_match',
          field_key: rule.field_key,
          operator: rule.operator,
          value: rule.value || null,
          value_list: rule.value_list?.length ? rule.value_list : null,
          points: rule.is_disqualifying ? 0 : rule.points,
          is_disqualifying: rule.is_disqualifying,
          description: rule.description,
        });
      }
      log(`✓ Created ${payload.rules.length} matching rules`);

      log('');
      log('All done! Case is live and ready.');
      setCommitStatus('done');
    } catch (e) {
      log(`Error: ${String(e)}`);
      setCommitStatus('error');
    }
  };

  const reset = () => {
    setDocText('');
    setPdfFile(null);
    setInputMode('text');
    setPayload(null);
    setParseError('');
    setCommitStatus('idle');
    setCommitLog([]);
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  // ── Render ───────────────────────────────────────────────────────────────

  return (
    <div className="p-4 sm:p-6 max-w-4xl">
      {/* Header */}
      <div className="flex items-start justify-between mb-6 gap-4">
        <div>
          <h1 className="text-lg sm:text-xl font-bold text-slate-900 flex items-center gap-2">
            <Sparkles size={20} className="text-blue-600" />
            AI Case Import
          </h1>
          <p className="text-sm text-slate-500 mt-1 leading-relaxed">
            Paste a qualification 1-pager, email, or criteria sheet. AI will extract the case, questions, and matching rules for your review.
          </p>
        </div>
        {payload && commitStatus === 'idle' && (
          <button onClick={reset} className="flex items-center gap-1.5 text-sm text-slate-500 hover:text-slate-700 px-3 py-2 rounded-xl hover:bg-slate-100 transition-colors shrink-0">
            <RotateCcw size={15} /> Start over
          </button>
        )}
      </div>

      {/* Input stage */}
      {!payload && commitStatus === 'idle' && (
        <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden">
          {/* Mode tabs */}
          <div className="flex border-b border-slate-200">
            <button
              onClick={() => setInputMode('text')}
              className={`flex items-center gap-2 px-5 py-3.5 text-sm font-medium transition-colors flex-1 justify-center ${inputMode === 'text' ? 'bg-white text-blue-700 border-b-2 border-blue-600' : 'text-slate-500 hover:text-slate-700 bg-slate-50'}`}
            >
              <FileText size={15} /> Paste Text
            </button>
            <button
              onClick={() => setInputMode('pdf')}
              className={`flex items-center gap-2 px-5 py-3.5 text-sm font-medium transition-colors flex-1 justify-center ${inputMode === 'pdf' ? 'bg-white text-blue-700 border-b-2 border-blue-600' : 'text-slate-500 hover:text-slate-700 bg-slate-50'}`}
            >
              <FilePlus2 size={15} /> Upload PDF
            </button>
          </div>

          <div className="p-5">
            {inputMode === 'text' && (
              <textarea
                value={docText}
                onChange={e => setDocText(e.target.value)}
                rows={14}
                placeholder={`Paste a qualification criteria sheet, email from a law firm, or case 1-pager here...

Example:
"Roundup Weedkiller Lawsuit — Qualification Criteria
We are currently accepting cases for individuals diagnosed with Non-Hodgkin's Lymphoma or Leukemia after using Roundup herbicide...
Qualifying criteria:
• Used Roundup regularly (10+ times) before 2015
• Diagnosed after at least 2 years of use
• No prior attorney representation
• Diagnosis confirmed by a physician..."`}
                className="w-full px-4 py-3 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none bg-slate-50 text-slate-800 placeholder:text-slate-400 leading-relaxed"
              />
            )}

            {inputMode === 'pdf' && (
              <>
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="application/pdf"
                  onChange={handleFileSelect}
                  className="hidden"
                />
                {!pdfFile ? (
                  <div
                    onDragOver={e => { e.preventDefault(); setDragOver(true); }}
                    onDragLeave={() => setDragOver(false)}
                    onDrop={handleFileDrop}
                    onClick={() => fileInputRef.current?.click()}
                    className={`flex flex-col items-center justify-center gap-4 border-2 border-dashed rounded-xl py-16 px-6 cursor-pointer transition-colors ${dragOver ? 'border-blue-500 bg-blue-50' : 'border-slate-300 bg-slate-50 hover:border-blue-400 hover:bg-blue-50/50'}`}
                  >
                    <div className={`w-14 h-14 rounded-2xl flex items-center justify-center transition-colors ${dragOver ? 'bg-blue-100' : 'bg-slate-100'}`}>
                      <Upload size={24} className={dragOver ? 'text-blue-600' : 'text-slate-400'} />
                    </div>
                    <div className="text-center">
                      <p className="text-sm font-semibold text-slate-700">Drop a PDF here or click to browse</p>
                      <p className="text-xs text-slate-400 mt-1">Qualification 1-pagers, firm emails, criteria sheets</p>
                    </div>
                  </div>
                ) : (
                  <div className="flex items-center gap-4 bg-blue-50 border border-blue-200 rounded-xl px-4 py-4">
                    <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center shrink-0">
                      <FileText size={18} className="text-blue-600" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-semibold text-slate-800 truncate">{pdfFile.name}</p>
                      <p className="text-xs text-slate-500 mt-0.5">{(pdfFile.size / 1024).toFixed(0)} KB · PDF</p>
                    </div>
                    <button
                      onClick={clearPdf}
                      className="w-9 h-9 flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors shrink-0"
                    >
                      <X size={16} />
                    </button>
                  </div>
                )}
              </>
            )}

            {parseError && (
              <div className="flex items-start gap-2.5 mt-3 bg-red-50 border border-red-200 rounded-xl px-4 py-3">
                <AlertCircle size={16} className="text-red-500 shrink-0 mt-0.5" />
                <p className="text-sm text-red-700">{parseError}</p>
              </div>
            )}

            <div className="flex items-center justify-between mt-4 gap-3">
              <p className="text-xs text-slate-400">
                {inputMode === 'text' ? 'Works with emails, bullet lists, or any text format.' : 'PDF is read natively by AI — no text extraction needed.'}
              </p>
              <button
                onClick={handleParse}
                disabled={parsing || (inputMode === 'text' ? !docText.trim() : !pdfFile)}
                className="flex items-center gap-2 bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 text-white font-semibold px-5 py-2.5 rounded-xl text-sm transition-colors min-h-[44px] shrink-0"
              >
                {parsing ? (
                  <><Loader2 size={16} className="animate-spin" /> Analyzing...</>
                ) : (
                  <><Sparkles size={16} /> Parse with AI</>
                )}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Review stage */}
      {payload && commitStatus === 'idle' && (
        <div className="space-y-4">
          {/* Alert banner */}
          <div className="flex items-center gap-3 bg-amber-50 border border-amber-200 rounded-xl px-4 py-3">
            <AlertCircle size={16} className="text-amber-500 shrink-0" />
            <p className="text-sm text-amber-800">
              Review and edit everything below before publishing. Nothing has been saved yet.
            </p>
          </div>

          {/* Case details */}
          <Section title="Case Details" count={1}>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {([
                ['name', 'Case Name', false],
                ['slug', 'Slug', false],
                ['short_description', 'Short Description', false],
                ['internal_notes', 'Internal Notes', true],
              ] as [keyof AiCase, string, boolean][]).map(([key, label, multi]) => (
                <div key={key} className={multi ? 'sm:col-span-2' : ''}>
                  <label className="block text-xs font-medium text-slate-500 mb-1">{label}</label>
                  <InlineEdit
                    value={String(payload.case[key] ?? '')}
                    onChange={v => setCase({ [key]: v })}
                    multiline={multi}
                  />
                </div>
              ))}
              <div>
                <label className="block text-xs font-medium text-slate-500 mb-1">Type</label>
                <select
                  value={payload.case.case_type}
                  onChange={e => setCase({ case_type: e.target.value })}
                  className="w-full px-2.5 py-1.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                >
                  <option value="mass_tort">Mass Tort</option>
                  <option value="class_action">Class Action</option>
                </select>
              </div>
              <div>
                <label className="block text-xs font-medium text-slate-500 mb-1">Est. Lead Value ($)</label>
                <InlineEdit
                  value={String(payload.case.estimated_lead_value ?? 0)}
                  onChange={v => setCase({ estimated_lead_value: Number(v) || 0 })}
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-slate-500 mb-1">Priority (0–100)</label>
                <InlineEdit
                  value={String(payload.case.priority_score ?? 50)}
                  onChange={v => setCase({ priority_score: Number(v) || 50 })}
                />
              </div>
            </div>
          </Section>

          {/* Questions */}
          <Section title="Questions" count={payload.questions.length} badge="intake form">
            {payload.questions.map((q, idx) => (
              <div key={idx} className="border border-slate-200 rounded-xl overflow-hidden">
                {/* Question header row */}
                <div className="flex items-start gap-3 p-3.5 bg-slate-50">
                  <span className="text-xs text-slate-400 font-mono mt-1 w-5 shrink-0 text-center">{idx + 1}</span>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-slate-800 leading-snug">{q.question_text}</p>
                    <div className="flex items-center gap-2 mt-1.5 flex-wrap">
                      <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${categoryColor[q.category] || 'bg-slate-100 text-slate-600'}`}>
                        {q.category.replace(/_/g, ' ')}
                      </span>
                      <span className="text-xs bg-slate-200 text-slate-600 px-2 py-0.5 rounded-full font-medium">
                        {q.question_type.replace(/_/g, ' ')}
                      </span>
                      <span className="font-mono text-xs text-slate-400">{q.field_key}</span>
                      {q.is_profile_field && <span className="text-xs text-emerald-600 font-medium">profile field</span>}
                    </div>
                  </div>
                  <div className="flex items-center gap-1 shrink-0">
                    <button
                      onClick={() => setEditingQIdx(editingQIdx === idx ? null : idx)}
                      className="w-9 h-9 flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                    >
                      <Pencil size={14} />
                    </button>
                    <button
                      onClick={() => removeQuestion(idx)}
                      className="w-9 h-9 flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
                    >
                      <Trash2 size={14} />
                    </button>
                  </div>
                </div>

                {/* Inline editor */}
                {editingQIdx === idx && (
                  <div className="p-4 border-t border-slate-200 bg-white space-y-3">
                    <div>
                      <label className="block text-xs font-medium text-slate-500 mb-1">Question Text</label>
                      <InlineEdit value={q.question_text} onChange={v => setQuestion(idx, { question_text: v })} multiline />
                    </div>
                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1">Field Key</label>
                        <InlineEdit
                          value={q.field_key}
                          onChange={v => setQuestion(idx, { field_key: v.toLowerCase().replace(/\s+/g, '_') })}
                          className="font-mono"
                        />
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1">Type</label>
                        <select
                          value={q.question_type}
                          onChange={e => setQuestion(idx, { question_type: e.target.value })}
                          className="w-full px-2.5 py-1.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                        >
                          {QUESTION_TYPES.map(t => <option key={t} value={t}>{t.replace(/_/g, ' ')}</option>)}
                        </select>
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1">Category</label>
                        <select
                          value={q.category}
                          onChange={e => setQuestion(idx, { category: e.target.value })}
                          className="w-full px-2.5 py-1.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                        >
                          {CATEGORIES.map(c => <option key={c} value={c}>{c.replace(/_/g, ' ')}</option>)}
                        </select>
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1">Help Text</label>
                        <InlineEdit value={q.help_text} onChange={v => setQuestion(idx, { help_text: v })} />
                      </div>
                    </div>
                    {['dropdown', 'multi_select'].includes(q.question_type) && (
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1.5">Answer Options</label>
                        <div className="flex flex-wrap gap-2 mb-2">
                          {q.answer_options.map((opt, oi) => (
                            <span key={oi} className="flex items-center gap-1.5 bg-slate-100 text-slate-700 text-xs px-2.5 py-1 rounded-lg">
                              {opt}
                              <button
                                onClick={() => setQuestion(idx, { answer_options: q.answer_options.filter((_, i) => i !== oi) })}
                                className="text-slate-400 hover:text-red-500"
                              >
                                <X size={11} />
                              </button>
                            </span>
                          ))}
                        </div>
                        <OptionAdder onAdd={opt => setQuestion(idx, { answer_options: [...q.answer_options, opt] })} />
                      </div>
                    )}
                    <div className="flex gap-4">
                      <label className="flex items-center gap-2 cursor-pointer text-xs text-slate-700">
                        <input type="checkbox" checked={q.required} onChange={e => setQuestion(idx, { required: e.target.checked })} className="rounded border-slate-300 text-blue-600 w-4 h-4" />
                        Required
                      </label>
                      <label className="flex items-center gap-2 cursor-pointer text-xs text-slate-700">
                        <input type="checkbox" checked={q.is_profile_field} onChange={e => setQuestion(idx, { is_profile_field: e.target.checked })} className="rounded border-slate-300 text-blue-600 w-4 h-4" />
                        Reusable profile field
                      </label>
                    </div>
                  </div>
                )}
              </div>
            ))}

            <button
              onClick={addQuestion}
              className="flex items-center gap-2 text-sm text-blue-700 hover:text-blue-800 font-medium px-3 py-2 rounded-xl hover:bg-blue-50 transition-colors"
            >
              <Plus size={15} /> Add question
            </button>
          </Section>

          {/* Rules */}
          <Section title="Matching Rules" count={payload.rules.length} badge="eligibility scoring">
            {payload.rules.map((rule, idx) => (
              <div key={idx} className={`border rounded-xl overflow-hidden ${rule.is_disqualifying ? 'border-red-200' : 'border-slate-200'}`}>
                <div className={`flex items-start gap-3 p-3.5 ${rule.is_disqualifying ? 'bg-red-50' : 'bg-slate-50'}`}>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap mb-1">
                      <span className={`text-xs font-semibold px-2.5 py-1 rounded-full border ${rule.is_disqualifying ? 'bg-red-100 text-red-700 border-red-300' : 'bg-emerald-50 text-emerald-700 border-emerald-200'}`}>
                        {rule.is_disqualifying ? 'Disqualifying' : `+${rule.points} pts`}
                      </span>
                    </div>
                    <div className="flex items-center gap-1.5 flex-wrap text-sm">
                      <span className="font-mono text-xs bg-white border border-slate-200 px-2 py-0.5 rounded-lg text-slate-700">{rule.field_key}</span>
                      <span className="text-slate-400 text-xs">{rule.operator}</span>
                      <span className="font-mono text-xs bg-blue-50 text-blue-700 px-2 py-0.5 rounded-lg">
                        {rule.value || rule.value_list?.slice(0, 2).join(', ')}
                        {(rule.value_list?.length || 0) > 2 && ` +${rule.value_list!.length - 2} more`}
                      </span>
                    </div>
                    {rule.description && <p className="text-xs text-slate-500 mt-1">{rule.description}</p>}
                  </div>
                  <div className="flex items-center gap-1 shrink-0">
                    <button
                      onClick={() => setEditingRuleIdx(editingRuleIdx === idx ? null : idx)}
                      className="w-9 h-9 flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                    >
                      <Pencil size={14} />
                    </button>
                    <button
                      onClick={() => removeRule(idx)}
                      className="w-9 h-9 flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
                    >
                      <Trash2 size={14} />
                    </button>
                  </div>
                </div>

                {editingRuleIdx === idx && (
                  <div className="p-4 border-t border-slate-200 bg-white space-y-3">
                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1">Field Key</label>
                        <select
                          value={rule.field_key}
                          onChange={e => setRule(idx, { field_key: e.target.value })}
                          className="w-full px-2.5 py-1.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white font-mono"
                        >
                          <option value="">Select field...</option>
                          {payload.questions.map(q => (
                            <option key={q.field_key} value={q.field_key}>{q.field_key}</option>
                          ))}
                        </select>
                      </div>
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1">Operator</label>
                        <select
                          value={rule.operator}
                          onChange={e => setRule(idx, { operator: e.target.value })}
                          className="w-full px-2.5 py-1.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
                        >
                          {OPERATORS.map(op => <option key={op} value={op}>{op.replace(/_/g, ' ')}</option>)}
                        </select>
                      </div>
                    </div>

                    {rule.operator !== 'in_list' ? (
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1">Match Value</label>
                        <InlineEdit value={rule.value} onChange={v => setRule(idx, { value: v })} />
                      </div>
                    ) : (
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1.5">Match Values</label>
                        <div className="flex flex-wrap gap-2 mb-2">
                          {rule.value_list.map((v, vi) => (
                            <span key={vi} className="flex items-center gap-1.5 bg-slate-100 text-xs px-2.5 py-1 rounded-lg">
                              {v}
                              <button onClick={() => setRule(idx, { value_list: rule.value_list.filter((_, i) => i !== vi) })} className="text-slate-400 hover:text-red-500"><X size={11} /></button>
                            </span>
                          ))}
                        </div>
                        <OptionAdder onAdd={v => setRule(idx, { value_list: [...rule.value_list, v] })} placeholder="Add value..." />
                      </div>
                    )}

                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <label className="block text-xs font-medium text-slate-500 mb-1">Points</label>
                        <InlineEdit
                          value={String(rule.points)}
                          onChange={v => setRule(idx, { points: Number(v) || 0 })}
                        />
                      </div>
                      <div className="flex items-center pt-5">
                        <label className="flex items-center gap-2 cursor-pointer text-xs text-slate-700">
                          <input
                            type="checkbox"
                            checked={rule.is_disqualifying}
                            onChange={e => setRule(idx, { is_disqualifying: e.target.checked })}
                            className="rounded border-slate-300 text-red-600 w-4 h-4"
                          />
                          Disqualifying rule
                        </label>
                      </div>
                    </div>
                    <div>
                      <label className="block text-xs font-medium text-slate-500 mb-1">Description</label>
                      <InlineEdit value={rule.description} onChange={v => setRule(idx, { description: v })} />
                    </div>
                  </div>
                )}
              </div>
            ))}

            <button
              onClick={addRule}
              className="flex items-center gap-2 text-sm text-blue-700 hover:text-blue-800 font-medium px-3 py-2 rounded-xl hover:bg-blue-50 transition-colors"
            >
              <Plus size={15} /> Add rule
            </button>
          </Section>

          {/* Summary + Commit */}
          <div className="bg-slate-900 rounded-2xl p-5 text-white">
            <div className="flex items-center justify-between flex-wrap gap-3 mb-4">
              <div>
                <h3 className="font-semibold text-sm">Ready to publish?</h3>
                <p className="text-xs text-slate-400 mt-0.5">
                  This will create the case, {payload.questions.length} questions, and {payload.rules.length} matching rules.
                  Existing questions with matching field keys will be reused.
                </p>
              </div>
              <div className="flex items-center gap-2 text-xs text-slate-400">
                <span className="bg-slate-800 px-2.5 py-1 rounded-lg">{payload.questions.length} questions</span>
                <span className="bg-slate-800 px-2.5 py-1 rounded-lg">{payload.rules.filter(r => !r.is_disqualifying).reduce((a, r) => a + r.points, 0)} pts max</span>
                <span className="bg-slate-800 px-2.5 py-1 rounded-lg">{payload.rules.filter(r => r.is_disqualifying).length} disqualifiers</span>
              </div>
            </div>
            <button
              onClick={handleCommit}
              className="flex items-center justify-center gap-2 w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold py-3.5 rounded-xl transition-colors text-sm min-h-[52px]"
            >
              <Upload size={17} /> Publish Case to Platform
              <ArrowRight size={17} />
            </button>
          </div>
        </div>
      )}

      {/* Committing / Done / Error */}
      {(commitStatus === 'committing' || commitStatus === 'done' || commitStatus === 'error') && (
        <div className="bg-white rounded-2xl border border-slate-200 p-6">
          <div className="flex items-center gap-3 mb-4">
            {commitStatus === 'committing' && <Loader2 size={20} className="animate-spin text-blue-600" />}
            {commitStatus === 'done' && <CheckCircle2 size={20} className="text-emerald-500" />}
            {commitStatus === 'error' && <AlertCircle size={20} className="text-red-500" />}
            <h3 className="font-semibold text-slate-900 text-sm">
              {commitStatus === 'committing' && 'Publishing case...'}
              {commitStatus === 'done' && 'Case published successfully!'}
              {commitStatus === 'error' && 'Something went wrong'}
            </h3>
          </div>

          <div className="bg-slate-950 rounded-xl p-4 font-mono text-xs leading-relaxed overflow-y-auto max-h-64">
            {commitLog.map((line, i) => (
              <div key={i} className={line.startsWith('✓') ? 'text-emerald-400' : line.startsWith('Error') ? 'text-red-400' : 'text-slate-300'}>
                {line || <br />}
              </div>
            ))}
            {commitStatus === 'committing' && (
              <span className="inline-block w-2 h-4 bg-slate-300 animate-pulse ml-0.5" />
            )}
          </div>

          {commitStatus === 'done' && (
            <div className="mt-4 flex gap-3">
              <a
                href="/admin/cases"
                className="flex-1 flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-semibold py-3 rounded-xl text-sm transition-colors"
              >
                <Check size={16} /> View Cases
              </a>
              <button
                onClick={reset}
                className="flex-1 flex items-center justify-center gap-2 border border-slate-300 text-slate-700 font-medium py-3 rounded-xl text-sm hover:bg-slate-50 transition-colors"
              >
                <Plus size={16} /> Import another
              </button>
            </div>
          )}

          {commitStatus === 'error' && (
            <button
              onClick={() => setCommitStatus('idle')}
              className="mt-4 w-full flex items-center justify-center gap-2 border border-slate-300 text-slate-700 font-medium py-3 rounded-xl text-sm hover:bg-slate-50 transition-colors"
            >
              <RotateCcw size={15} /> Back to review
            </button>
          )}
        </div>
      )}
    </div>
  );
}

// ── Option adder sub-component ─────────────────────────────────────────────

function OptionAdder({ onAdd, placeholder = 'Add option...' }: { onAdd: (v: string) => void; placeholder?: string }) {
  const [val, setVal] = useState('');
  const submit = () => { if (val.trim()) { onAdd(val.trim()); setVal(''); } };
  return (
    <div className="flex gap-2">
      <input
        value={val}
        onChange={e => setVal(e.target.value)}
        onKeyDown={e => { if (e.key === 'Enter') { e.preventDefault(); submit(); } }}
        placeholder={placeholder}
        className="flex-1 px-3 py-1.5 text-sm border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
      <button onClick={submit} className="w-9 h-9 flex items-center justify-center bg-blue-700 text-white rounded-lg hover:bg-blue-800 transition-colors shrink-0">
        <Plus size={15} />
      </button>
    </div>
  );
}
