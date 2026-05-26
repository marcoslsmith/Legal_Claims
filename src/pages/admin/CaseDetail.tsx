import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import {
  ArrowLeft, Pencil, X, Users, FileText, CheckCircle2,
  AlertTriangle, BarChart2, DollarSign, MapPin, Calendar,
  Shield, HelpCircle, GitBranch, Loader2, Plus, ExternalLink, Tag,
} from 'lucide-react';
import { supabase } from '../../lib/supabase';
import type { Case, Question, MatchingRule } from '../../types/database';
import { DocRequirementsFields } from './DocRequirementsFields';

interface CaseQuestion {
  id: string;
  display_order: number | null;
  required_for_case: boolean | null;
  question: Question;
}

interface SubmissionStats {
  total: number;
  submitted: number;
  in_progress: number;
  accepted: number;
}

const statusColors: Record<string, string> = {
  active: 'bg-emerald-100 text-emerald-700',
  paused: 'bg-amber-100 text-amber-700',
  closed: 'bg-slate-100 text-slate-500',
  waitlist: 'bg-blue-100 text-blue-700',
};

const EMPTY_FORM: Partial<Case> = {
  name: '', slug: '', case_type: 'mass_tort', status: 'active',
  short_description: '', long_description: '', priority_score: 50,
  allowed_states: [], disqualifying_states: [],
  estimated_lead_value: 0, internal_notes: '',
  require_medical_docs: false, required_doc_types: [],
};

function Stat({ icon: Icon, label, value, sub }: { icon: React.ElementType; label: string; value: string | number; sub?: string }) {
  return (
    <div className="bg-white rounded-xl border border-slate-200 p-4">
      <div className="flex items-center gap-2 mb-2">
        <Icon size={15} className="text-slate-400" />
        <span className="text-xs text-slate-500 font-medium">{label}</span>
      </div>
      <div className="text-xl font-bold text-slate-900">{value}</div>
      {sub && <div className="text-xs text-slate-400 mt-0.5">{sub}</div>}
    </div>
  );
}

export default function AdminCaseDetail() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const [caseData, setCaseData] = useState<Case | null>(null);
  const [questions, setQuestions] = useState<CaseQuestion[]>([]);
  const [rules, setRules] = useState<MatchingRule[]>([]);
  const [stats, setStats] = useState<SubmissionStats>({ total: 0, submitted: 0, in_progress: 0, accepted: 0 });
  const [loading, setLoading] = useState(true);

  const [showEdit, setShowEdit] = useState(false);
  const [form, setForm] = useState<Partial<Case>>(EMPTY_FORM);
  const [saving, setSaving] = useState(false);

  useEffect(() => { if (id) loadAll(); }, [id]);

  const loadAll = async () => {
    const [caseRes, cqRes, rulesRes, subsRes] = await Promise.all([
      supabase.from('cases').select('*').eq('id', id!).maybeSingle(),
      supabase.from('case_questions').select('*, question:questions(*)').eq('case_id', id!).order('display_order'),
      supabase.from('matching_rules').select('*').eq('case_id', id!),
      supabase.from('submissions').select('status').eq('case_id', id!),
    ]);

    if (!caseRes.data) { navigate('/admin/cases'); return; }
    setCaseData(caseRes.data);
    setForm(caseRes.data);
    setQuestions((cqRes.data || []) as unknown as CaseQuestion[]);
    setRules(rulesRes.data || []);

    const subs = subsRes.data || [];
    setStats({
      total: subs.length,
      submitted: subs.filter(s => ['submitted', 'under_review', 'routed'].includes(s.status)).length,
      in_progress: subs.filter(s => s.status === 'in_progress').length,
      accepted: subs.filter(s => s.status === 'accepted').length,
    });
    setLoading(false);
  };

  const handleSave = async () => {
    if (!caseData) return;
    setSaving(true);
    await supabase.from('cases').update({ ...form, updated_at: new Date().toISOString() }).eq('id', caseData.id);
    await loadAll();
    setShowEdit(false);
    setSaving(false);
  };

  if (loading) return (
    <div className="flex items-center justify-center py-24">
      <Loader2 size={24} className="animate-spin text-blue-600" />
    </div>
  );

  if (!caseData) return null;

  const disqualifying = rules.filter(r => r.is_disqualifying);
  const scoring = rules.filter(r => !r.is_disqualifying);
  const maxPoints = scoring.reduce((a, r) => a + (r.points || 0), 0);

  return (
    <div className="p-4 sm:p-6 max-w-4xl">
      {/* Header */}
      <div className="flex items-start gap-3 mb-6">
        <button
          onClick={() => navigate('/admin/cases')}
          className="w-9 h-9 flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-xl transition-colors shrink-0 mt-0.5"
        >
          <ArrowLeft size={18} />
        </button>
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap mb-1">
            <h1 className="text-lg sm:text-xl font-bold text-slate-900 truncate">{caseData.name}</h1>
            <span className={`text-xs px-2 py-0.5 rounded-full font-medium shrink-0 ${statusColors[caseData.status] || 'bg-slate-100 text-slate-600'}`}>
              {caseData.status}
            </span>
          </div>
          <div className="flex items-center gap-2 text-xs text-slate-400 flex-wrap">
            <span className={`px-2 py-0.5 rounded-full font-medium ${caseData.case_type === 'mass_tort' ? 'bg-blue-100 text-blue-700' : 'bg-teal-100 text-teal-700'}`}>
              {caseData.case_type === 'mass_tort' ? 'Mass Tort' : 'Class Action'}
            </span>
            {caseData.category && (
              <span className="px-2 py-0.5 rounded-full font-medium bg-slate-100 text-slate-700 flex items-center gap-1">
                <Tag size={10} /> {caseData.category}
              </span>
            )}
            <span className="font-mono">/{caseData.slug}</span>
          </div>
        </div>
        <button
          onClick={() => { setForm(caseData); setShowEdit(true); }}
          className="flex items-center gap-2 text-sm font-semibold text-blue-700 hover:text-blue-800 border border-blue-200 hover:border-blue-300 bg-blue-50 hover:bg-blue-100 px-4 py-2 rounded-xl transition-colors shrink-0"
        >
          <Pencil size={14} /> Edit
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6">
        <Stat icon={Users} label="Total Leads" value={stats.total} />
        <Stat icon={FileText} label="Submitted" value={stats.submitted} />
        <Stat icon={CheckCircle2} label="Accepted" value={stats.accepted} />
        <Stat icon={DollarSign} label="Lead Value" value={`$${(caseData.estimated_lead_value || 0).toLocaleString()}`} sub="per lead" />
      </div>

      <div className="space-y-4">
        {/* Research-grade banner */}
        {caseData.is_research_grade && (
          <div className="bg-amber-50 border border-amber-300 rounded-2xl p-4 flex items-start gap-3">
            <AlertTriangle size={18} className="text-amber-600 shrink-0 mt-0.5" />
            <div className="flex-1 min-w-0">
              <p className="text-sm font-bold text-amber-900">Research-grade — pending attorney review</p>
              <p className="text-xs text-amber-800 mt-0.5 leading-relaxed">
                {caseData.admin_review_notes || 'Eligibility logic compiled from public sources. Have counsel review intake criteria, payout language, and source URLs before fully publishing or routing leads.'}
              </p>
              {caseData.confidence_label && (
                <p className="text-xs text-amber-700 mt-1.5 font-medium">Source confidence: {caseData.confidence_label}</p>
              )}
            </div>
          </div>
        )}

        {/* Eligibility intake criteria (read-only summary from spreadsheet seed) */}
        {(caseData.core_qualifications || caseData.disqualifiers_summary || caseData.likely_documents || caseData.deadline_or_timing || caseData.payout_language) && (
          <div className="bg-white rounded-2xl border border-slate-200 p-5 space-y-4">
            <h2 className="font-semibold text-slate-900 text-sm flex items-center gap-2">
              <FileText size={15} className="text-slate-400" /> Intake Criteria & Guidance
            </h2>
            {caseData.core_qualifications && (
              <div>
                <p className="text-xs font-semibold text-emerald-700 uppercase tracking-wide mb-1">Core Qualifications</p>
                <p className="text-sm text-slate-700 leading-relaxed">{caseData.core_qualifications}</p>
              </div>
            )}
            {caseData.disqualifiers_summary && (
              <div>
                <p className="text-xs font-semibold text-red-700 uppercase tracking-wide mb-1">Disqualifiers</p>
                <p className="text-sm text-slate-700 leading-relaxed">{caseData.disqualifiers_summary}</p>
              </div>
            )}
            {caseData.likely_documents && (
              <div>
                <p className="text-xs font-semibold text-blue-700 uppercase tracking-wide mb-1">Likely Documents</p>
                <p className="text-sm text-slate-700 leading-relaxed">{caseData.likely_documents}</p>
              </div>
            )}
            {caseData.deadline_or_timing && (
              <div>
                <p className="text-xs font-semibold text-amber-700 uppercase tracking-wide mb-1">Deadline / Timing</p>
                <p className="text-sm text-slate-700 leading-relaxed">{caseData.deadline_or_timing}</p>
              </div>
            )}
            {caseData.payout_language && (
              <div>
                <p className="text-xs font-semibold text-slate-600 uppercase tracking-wide mb-1">Payout Language (consumer-safe)</p>
                <p className="text-sm text-slate-700 leading-relaxed">{caseData.payout_language}</p>
              </div>
            )}
          </div>
        )}

        {/* Source URLs */}
        {(caseData.source_urls?.length ?? 0) > 0 && (
          <div className="bg-white rounded-2xl border border-slate-200 p-5">
            <h2 className="font-semibold text-slate-900 text-sm mb-3 flex items-center gap-2">
              <ExternalLink size={15} className="text-slate-400" /> Source References
            </h2>
            <ul className="space-y-1.5">
              {caseData.source_urls!.map(url => (
                <li key={url}>
                  <a
                    href={url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-sm text-blue-700 hover:text-blue-800 hover:underline break-all flex items-start gap-1.5"
                  >
                    <ExternalLink size={11} className="shrink-0 mt-1" /> {url}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        )}

        {/* Doc requirements badge */}
        {caseData.require_medical_docs && (
          <div className="bg-blue-50 border border-blue-200 rounded-2xl p-4 flex items-start gap-3">
            <FileText size={15} className="text-blue-600 shrink-0 mt-0.5" />
            <div>
              <p className="text-sm font-semibold text-blue-800">Document upload required</p>
              {(caseData.required_doc_types?.length ?? 0) > 0 ? (
                <div className="flex flex-wrap gap-1.5 mt-1.5">
                  {caseData.required_doc_types!.map(t => (
                    <span key={t} className="text-xs bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full font-medium">{t.replace(/_/g, ' ')}</span>
                  ))}
                </div>
              ) : (
                <p className="text-xs text-blue-600 mt-0.5">No specific types configured — users will be blocked without guidance.</p>
              )}
            </div>
          </div>
        )}

        {/* Descriptions */}
        <div className="bg-white rounded-2xl border border-slate-200 p-5">
          <h2 className="font-semibold text-slate-900 text-sm mb-3 flex items-center gap-2">
            <FileText size={15} className="text-slate-400" /> Description
          </h2>
          {caseData.short_description && (
            <p className="text-sm font-medium text-slate-800 mb-2">{caseData.short_description}</p>
          )}
          {caseData.long_description && (
            <p className="text-sm text-slate-600 leading-relaxed whitespace-pre-wrap">{caseData.long_description}</p>
          )}
          {!caseData.short_description && !caseData.long_description && (
            <p className="text-sm text-slate-400 italic">No description added.</p>
          )}
        </div>

        {/* Scoring + priority */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div className="bg-white rounded-2xl border border-slate-200 p-5">
            <h2 className="font-semibold text-slate-900 text-sm mb-3 flex items-center gap-2">
              <BarChart2 size={15} className="text-slate-400" /> Scoring
            </h2>
            <div className="space-y-2">
              <div className="flex items-center justify-between text-sm">
                <span className="text-slate-500">Priority Score</span>
                <span className="font-semibold text-slate-900">{caseData.priority_score ?? 0} / 100</span>
              </div>
              <div className="w-full bg-slate-100 rounded-full h-2">
                <div className="bg-blue-600 h-2 rounded-full transition-all" style={{ width: `${caseData.priority_score ?? 0}%` }} />
              </div>
              <div className="flex items-center justify-between text-sm pt-1">
                <span className="text-slate-500">Max Match Points</span>
                <span className="font-semibold text-slate-900">{maxPoints} pts</span>
              </div>
              <div className="flex items-center justify-between text-sm">
                <span className="text-slate-500">Scoring Rules</span>
                <span className="font-semibold text-slate-900">{scoring.length}</span>
              </div>
              <div className="flex items-center justify-between text-sm">
                <span className="text-slate-500">Disqualifiers</span>
                <span className="font-semibold text-red-600">{disqualifying.length}</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-2xl border border-slate-200 p-5">
            <h2 className="font-semibold text-slate-900 text-sm mb-3 flex items-center gap-2">
              <Calendar size={15} className="text-slate-400" /> Date Ranges
            </h2>
            <div className="space-y-2 text-sm">
              {(caseData.exposure_date_start || caseData.exposure_date_end) ? (
                <div>
                  <span className="text-slate-500 block mb-0.5">Exposure</span>
                  <span className="font-medium text-slate-800">
                    {caseData.exposure_date_start ?? '—'} → {caseData.exposure_date_end ?? 'present'}
                  </span>
                </div>
              ) : null}
              {(caseData.diagnosis_date_start || caseData.diagnosis_date_end) ? (
                <div>
                  <span className="text-slate-500 block mb-0.5">Diagnosis</span>
                  <span className="font-medium text-slate-800">
                    {caseData.diagnosis_date_start ?? '—'} → {caseData.diagnosis_date_end ?? 'present'}
                  </span>
                </div>
              ) : null}
              {!caseData.exposure_date_start && !caseData.exposure_date_end && !caseData.diagnosis_date_start && !caseData.diagnosis_date_end && (
                <p className="text-slate-400 italic">No date ranges set.</p>
              )}
            </div>
          </div>
        </div>

        {/* States */}
        {((caseData.allowed_states?.length ?? 0) > 0 || (caseData.disqualifying_states?.length ?? 0) > 0) && (
          <div className="bg-white rounded-2xl border border-slate-200 p-5">
            <h2 className="font-semibold text-slate-900 text-sm mb-3 flex items-center gap-2">
              <MapPin size={15} className="text-slate-400" /> State Eligibility
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {(caseData.allowed_states?.length ?? 0) > 0 && (
                <div>
                  <p className="text-xs font-medium text-emerald-700 mb-2">Allowed States</p>
                  <div className="flex flex-wrap gap-1.5">
                    {caseData.allowed_states!.map(s => (
                      <span key={s} className="text-xs bg-emerald-50 text-emerald-700 px-2 py-0.5 rounded-lg font-medium">{s}</span>
                    ))}
                  </div>
                </div>
              )}
              {(caseData.disqualifying_states?.length ?? 0) > 0 && (
                <div>
                  <p className="text-xs font-medium text-red-700 mb-2">Disqualifying States</p>
                  <div className="flex flex-wrap gap-1.5">
                    {caseData.disqualifying_states!.map(s => (
                      <span key={s} className="text-xs bg-red-50 text-red-700 px-2 py-0.5 rounded-lg font-medium">{s}</span>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

        {/* Questions */}
        <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden">
          <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
            <h2 className="font-semibold text-slate-900 text-sm flex items-center gap-2">
              <HelpCircle size={15} className="text-slate-400" /> Intake Questions
              <span className="text-xs bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full font-medium">{questions.length}</span>
            </h2>
            <Link
              to="/admin/case-forms"
              className="text-xs text-blue-600 hover:text-blue-700 font-medium flex items-center gap-1"
            >
              Manage <Plus size={11} />
            </Link>
          </div>
          {questions.length === 0 ? (
            <p className="text-sm text-slate-400 italic p-5">No questions linked to this case.</p>
          ) : (
            <div className="divide-y divide-slate-100">
              {questions.map((cq, idx) => (
                <div key={cq.id} className="px-5 py-3 flex items-start gap-3">
                  <span className="text-xs text-slate-400 font-mono w-5 shrink-0 mt-0.5 text-center">{idx + 1}</span>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm text-slate-800">{cq.question.question_text}</p>
                    <div className="flex items-center gap-2 mt-1 flex-wrap">
                      <span className="text-xs bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full">{cq.question.question_type.replace(/_/g, ' ')}</span>
                      <span className="font-mono text-xs text-slate-400">{cq.question.field_key}</span>
                      {cq.required_for_case && <span className="text-xs text-blue-600 font-medium">required</span>}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Matching Rules */}
        <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden">
          <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
            <h2 className="font-semibold text-slate-900 text-sm flex items-center gap-2">
              <GitBranch size={15} className="text-slate-400" /> Matching Rules
              <span className="text-xs bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full font-medium">{rules.length}</span>
            </h2>
            <Link
              to="/admin/rules"
              className="text-xs text-blue-600 hover:text-blue-700 font-medium flex items-center gap-1"
            >
              Manage <Plus size={11} />
            </Link>
          </div>
          {rules.length === 0 ? (
            <p className="text-sm text-slate-400 italic p-5">No matching rules configured.</p>
          ) : (
            <div className="divide-y divide-slate-100">
              {rules.map(rule => (
                <div key={rule.id} className={`px-5 py-3 flex items-start gap-3 ${rule.is_disqualifying ? 'bg-red-50/50' : ''}`}>
                  <div className="shrink-0 mt-0.5">
                    {rule.is_disqualifying
                      ? <AlertTriangle size={13} className="text-red-500" />
                      : <Shield size={13} className="text-emerald-500" />}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="font-mono text-xs bg-white border border-slate-200 px-2 py-0.5 rounded-lg text-slate-700">{rule.field_key}</span>
                      <span className="text-xs text-slate-400">{rule.operator}</span>
                      <span className="font-mono text-xs bg-blue-50 text-blue-700 px-2 py-0.5 rounded-lg">
                        {rule.value || rule.value_list?.slice(0, 3).join(', ')}
                        {(rule.value_list?.length || 0) > 3 && ` +${rule.value_list!.length - 3}`}
                      </span>
                      {rule.is_disqualifying
                        ? <span className="text-xs font-semibold text-red-600">Disqualifying</span>
                        : <span className="text-xs font-semibold text-emerald-600">+{rule.points} pts</span>}
                    </div>
                    {rule.description && <p className="text-xs text-slate-500 mt-1">{rule.description}</p>}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Internal Notes */}
        {caseData.internal_notes && (
          <div className="bg-amber-50 border border-amber-200 rounded-2xl p-5">
            <h2 className="font-semibold text-amber-900 text-sm mb-2 flex items-center gap-2">
              <Shield size={15} /> Internal Notes
            </h2>
            <p className="text-sm text-amber-800 leading-relaxed whitespace-pre-wrap">{caseData.internal_notes}</p>
          </div>
        )}

        {/* Quick links */}
        <div className="flex gap-3">
          <Link
            to={`/admin/leads?case=${caseData.id}`}
            className="flex-1 flex items-center justify-center gap-2 bg-white border border-slate-200 hover:border-slate-300 text-slate-700 font-medium text-sm py-3 rounded-xl transition-colors"
          >
            <Users size={15} /> View Leads
          </Link>
          <Link
            to={`/intake/${caseData.slug}`}
            target="_blank"
            rel="noopener noreferrer"
            className="flex-1 flex items-center justify-center gap-2 bg-white border border-slate-200 hover:border-slate-300 text-slate-700 font-medium text-sm py-3 rounded-xl transition-colors"
          >
            <FileText size={15} /> Preview Intake
          </Link>
        </div>
      </div>

      {/* Edit modal */}
      {showEdit && (
        <div className="fixed inset-0 z-50 flex flex-col lg:items-center lg:justify-start lg:pt-8 lg:bg-black/50 lg:px-4 lg:pb-8 lg:overflow-y-auto">
          <div className="bg-white w-full lg:max-w-2xl lg:rounded-2xl flex flex-col h-full lg:h-auto shadow-xl">
            <div className="sticky top-0 bg-white lg:rounded-t-2xl border-b border-slate-200 px-5 py-4 flex items-center justify-between">
              <h2 className="font-bold text-slate-900">Edit Case</h2>
              <button onClick={() => setShowEdit(false)} className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-xl transition-colors">
                <X size={20} />
              </button>
            </div>
            <div className="flex-1 overflow-y-auto p-5 space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Case Name</label>
                <input value={form.name || ''} onChange={e => setForm(f => ({ ...f, name: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Slug</label>
                  <input value={form.slug || ''} onChange={e => setForm(f => ({ ...f, slug: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Type</label>
                  <select value={form.case_type || 'mass_tort'} onChange={e => setForm(f => ({ ...f, case_type: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white">
                    <option value="mass_tort">Mass Tort</option>
                    <option value="class_action">Class Action</option>
                  </select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Status</label>
                  <select value={form.status || 'active'} onChange={e => setForm(f => ({ ...f, status: e.target.value }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white">
                    <option value="active">Active</option>
                    <option value="paused">Paused</option>
                    <option value="closed">Closed</option>
                    <option value="waitlist">Waitlist</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1.5">Priority (0–100)</label>
                  <input type="number" value={form.priority_score || 50} min={0} max={100}
                    onChange={e => setForm(f => ({ ...f, priority_score: parseInt(e.target.value) }))}
                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Est. Lead Value ($)</label>
                <input type="number" value={form.estimated_lead_value || 0} min={0}
                  onChange={e => setForm(f => ({ ...f, estimated_lead_value: parseFloat(e.target.value) }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Short Description</label>
                <input value={form.short_description || ''} onChange={e => setForm(f => ({ ...f, short_description: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Long Description</label>
                <textarea rows={4} value={form.long_description || ''} onChange={e => setForm(f => ({ ...f, long_description: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none" />
              </div>
              <DocRequirementsFields
                requireDocs={form.require_medical_docs ?? false}
                requiredDocTypes={form.required_doc_types ?? []}
                onRequireDocsChange={v => setForm(f => ({ ...f, require_medical_docs: v }))}
                onRequiredDocTypesChange={v => setForm(f => ({ ...f, required_doc_types: v }))}
              />

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1.5">Internal Notes</label>
                <textarea rows={2} value={form.internal_notes || ''} onChange={e => setForm(f => ({ ...f, internal_notes: e.target.value }))}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none" />
              </div>
            </div>
            <div className="sticky bottom-0 bg-white border-t border-slate-100 p-4 flex gap-3">
              <button onClick={() => setShowEdit(false)}
                className="flex-1 min-h-[48px] border border-slate-300 text-slate-700 font-medium rounded-xl text-sm hover:bg-slate-50 transition-colors">
                Cancel
              </button>
              <button onClick={handleSave} disabled={saving || !form.name || !form.slug}
                className="flex-1 min-h-[48px] bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 text-white font-semibold rounded-xl text-sm transition-colors">
                {saving ? 'Saving...' : 'Save Changes'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
