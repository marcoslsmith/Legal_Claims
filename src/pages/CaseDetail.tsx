import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import {
  ArrowLeft, FileText, ArrowRight, Upload, MapPin, Calendar,
  CheckCircle2, AlertCircle, Clock, Loader2, ChevronRight, DollarSign,
  Tag, ExternalLink, Shield,
} from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { MatchBadge } from '../components/MatchBadge';
import { StatusBadge } from '../components/StatusBadge';
import type { Case, Submission, UploadedDocument, MatchTier } from '../types/database';

interface SubWithDocs extends Submission {
  documents: UploadedDocument[];
}

export default function CaseDetail() {
  const { slug } = useParams<{ slug: string }>();
  const { user } = useAuth();
  const navigate = useNavigate();

  const [caseData, setCaseData] = useState<Case | null>(null);
  const [submission, setSubmission] = useState<SubWithDocs | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (slug && user) loadData();
  }, [slug, user]);

  const loadData = async () => {
    const [caseRes, subRes] = await Promise.all([
      supabase.from('cases').select('*').eq('slug', slug!).maybeSingle(),
      supabase
        .from('submissions')
        .select('*, uploaded_documents(*)')
        .eq('user_id', user!.id)
        .order('created_at', { ascending: false })
        .limit(1),
    ]);

    if (!caseRes.data) { navigate('/dashboard'); return; }
    setCaseData(caseRes.data);

    // Find the submission for this case
    const allSubs = subRes.data || [];
    const caseId = caseRes.data.id;
    const { data: caseSubs } = await supabase
      .from('submissions')
      .select('*, uploaded_documents(*)')
      .eq('user_id', user!.id)
      .eq('case_id', caseId)
      .order('created_at', { ascending: false })
      .limit(1);

    if (caseSubs?.[0]) {
      const s = caseSubs[0] as any;
      setSubmission({ ...s, documents: s.uploaded_documents || [] });
    }

    setLoading(false);
  };

  if (loading) return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <Loader2 size={24} className="animate-spin text-blue-600" />
    </div>
  );

  if (!caseData) return null;

  const isActive = caseData.status === 'active';
  const hasSubmission = !!submission;
  const isInProgress = submission?.status === 'in_progress';
  const isSubmitted = submission && ['submitted', 'under_review', 'routed', 'accepted'].includes(submission.status);

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      {/* Back */}
      <button
        onClick={() => navigate('/dashboard')}
        className="flex items-center gap-2 text-sm text-slate-500 hover:text-slate-700 mb-5 transition-colors"
      >
        <ArrowLeft size={16} /> Back to Dashboard
      </button>

      {/* Header */}
      <div className="bg-white rounded-2xl border border-slate-200 p-5 mb-4">
        <div className="flex items-start justify-between gap-3 mb-3">
          <div className="flex-1 min-w-0">
            <h1 className="text-lg font-bold text-slate-900 leading-snug mb-1">{caseData.name}</h1>
            <div className="flex items-center gap-2 flex-wrap">
              <span className={`text-xs px-2.5 py-1 rounded-full font-medium ${caseData.case_type === 'mass_tort' ? 'bg-blue-100 text-blue-700' : 'bg-teal-100 text-teal-700'}`}>
                {caseData.case_type === 'mass_tort' ? 'Mass Tort' : 'Class Action'}
              </span>
              {caseData.category && (
                <span className="text-xs px-2.5 py-1 rounded-full font-medium bg-slate-100 text-slate-700 flex items-center gap-1">
                  <Tag size={10} /> {caseData.category}
                </span>
              )}
              <span className={`text-xs px-2.5 py-1 rounded-full font-medium ${
                isActive ? 'bg-emerald-100 text-emerald-700' :
                caseData.status === 'paused' ? 'bg-amber-100 text-amber-700' :
                caseData.status === 'waitlist' ? 'bg-blue-100 text-blue-700' :
                'bg-slate-100 text-slate-500'
              }`}>
                {caseData.status === 'active' ? 'Accepting Claims' :
                 caseData.status === 'paused' ? 'Temporarily Paused' :
                 caseData.status === 'waitlist' ? 'Waitlist Open' : 'Closed'}
              </span>
            </div>
          </div>
          {submission && <StatusBadge status={submission.status} />}
        </div>

        {submission?.match_tier && (
          <div className="mb-3">
            <MatchBadge tier={submission.match_tier as MatchTier} />
          </div>
        )}

        {caseData.short_description && (
          <p className="text-sm text-slate-600 leading-relaxed">{caseData.short_description}</p>
        )}
      </div>

      {/* Submission status card */}
      {hasSubmission && (
        <div className={`rounded-2xl border p-4 mb-4 ${
          isInProgress ? 'bg-blue-50 border-blue-200' :
          isSubmitted ? 'bg-emerald-50 border-emerald-200' :
          'bg-slate-50 border-slate-200'
        }`}>
          <div className="flex items-center gap-3">
            {isInProgress
              ? <Clock size={18} className="text-blue-600 shrink-0" />
              : isSubmitted
              ? <CheckCircle2 size={18} className="text-emerald-600 shrink-0" />
              : <AlertCircle size={18} className="text-slate-400 shrink-0" />}
            <div className="flex-1 min-w-0">
              <p className="text-sm font-semibold text-slate-900">
                {isInProgress ? 'Your intake is in progress' :
                 isSubmitted ? 'Your claim has been submitted' :
                 'Claim status: ' + submission.status}
              </p>
              <div className="flex items-center gap-3 mt-0.5 text-xs text-slate-500 flex-wrap">
                <span>Started {new Date(submission.created_at!).toLocaleDateString()}</span>
                {submission.submitted_at && <span>Submitted {new Date(submission.submitted_at).toLocaleDateString()}</span>}
                {submission.documents.length > 0 && <span>{submission.documents.length} document{submission.documents.length !== 1 ? 's' : ''} uploaded</span>}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Actions */}
      <div className="flex gap-3 mb-6">
        {isInProgress && (
          <Link
            to={`/intake/${caseData.slug}`}
            className="flex-1 flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-semibold py-3.5 rounded-xl text-sm transition-colors min-h-[52px]"
          >
            Continue Intake <ArrowRight size={15} />
          </Link>
        )}
        {!hasSubmission && isActive && (
          <Link
            to={`/intake/${caseData.slug}`}
            className="flex-1 flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-semibold py-3.5 rounded-xl text-sm transition-colors min-h-[52px]"
          >
            Start Intake <ArrowRight size={15} />
          </Link>
        )}
        {hasSubmission && (
          <Link
            to={`/documents/${caseData.slug}`}
            className={`flex items-center justify-center gap-2 border border-slate-200 text-slate-700 font-medium py-3.5 px-5 rounded-xl text-sm hover:bg-slate-50 transition-colors min-h-[52px] ${isInProgress ? '' : 'flex-1'}`}
          >
            <Upload size={15} /> Upload Docs
          </Link>
        )}
      </div>

      {/* Payout — prefer numeric range, fall back to descriptive language */}
      {caseData.payout_range ? (
        <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-5 mb-4">
          <div className="flex items-center gap-2 mb-2">
            <DollarSign size={16} className="text-emerald-600 shrink-0" />
            <h2 className="font-semibold text-emerald-900 text-sm">Potential Compensation Range</h2>
          </div>
          <p className="text-xl font-bold text-emerald-800 mb-2">{caseData.payout_range}</p>
          <p className="text-xs text-emerald-700 leading-relaxed">
            Potential compensation may vary significantly based on your specific facts, medical history, and legal review. These figures are not a guarantee of recovery.
          </p>
        </div>
      ) : caseData.payout_language ? (
        <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-5 mb-4">
          <div className="flex items-center gap-2 mb-2">
            <DollarSign size={16} className="text-emerald-600 shrink-0" />
            <h2 className="font-semibold text-emerald-900 text-sm">About Potential Compensation</h2>
          </div>
          <p className="text-sm text-emerald-800 leading-relaxed">{caseData.payout_language}</p>
        </div>
      ) : null}

      {/* What may qualify (admin-curated) */}
      {caseData.core_qualifications && (
        <div className="bg-white rounded-2xl border border-slate-200 p-5 mb-4">
          <h2 className="font-semibold text-slate-900 text-sm mb-2 flex items-center gap-2">
            <CheckCircle2 size={15} className="text-emerald-500" /> What May Qualify
          </h2>
          <p className="text-sm text-slate-600 leading-relaxed">{caseData.core_qualifications}</p>
        </div>
      )}

      {/* Long description */}
      {caseData.long_description && (
        <div className="bg-white rounded-2xl border border-slate-200 p-5 mb-4">
          <h2 className="font-semibold text-slate-900 text-sm mb-3 flex items-center gap-2">
            <FileText size={15} className="text-slate-400" /> About This Case
          </h2>
          <p className="text-sm text-slate-600 leading-relaxed whitespace-pre-wrap">{caseData.long_description}</p>
        </div>
      )}

      {/* Eligibility info */}
      {((caseData.allowed_states?.length ?? 0) > 0 || caseData.exposure_date_start || caseData.diagnosis_date_start) && (
        <div className="bg-white rounded-2xl border border-slate-200 p-5 mb-4">
          <h2 className="font-semibold text-slate-900 text-sm mb-3 flex items-center gap-2">
            <CheckCircle2 size={15} className="text-slate-400" /> Eligibility Information
          </h2>
          <div className="space-y-3">
            {(caseData.allowed_states?.length ?? 0) > 0 && (
              <div>
                <div className="flex items-center gap-1.5 mb-1.5">
                  <MapPin size={13} className="text-slate-400" />
                  <span className="text-xs font-medium text-slate-500">Eligible States</span>
                </div>
                <div className="flex flex-wrap gap-1.5">
                  {caseData.allowed_states!.map(s => (
                    <span key={s} className="text-xs bg-slate-100 text-slate-700 px-2 py-0.5 rounded-lg font-medium">{s}</span>
                  ))}
                </div>
              </div>
            )}
            {(caseData.exposure_date_start || caseData.exposure_date_end) && (
              <div className="flex items-start gap-1.5">
                <Calendar size={13} className="text-slate-400 mt-0.5 shrink-0" />
                <div>
                  <span className="text-xs font-medium text-slate-500 block mb-0.5">Exposure Period</span>
                  <span className="text-sm text-slate-700">
                    {caseData.exposure_date_start ?? '—'} to {caseData.exposure_date_end ?? 'present'}
                  </span>
                </div>
              </div>
            )}
            {(caseData.diagnosis_date_start || caseData.diagnosis_date_end) && (
              <div className="flex items-start gap-1.5">
                <Calendar size={13} className="text-slate-400 mt-0.5 shrink-0" />
                <div>
                  <span className="text-xs font-medium text-slate-500 block mb-0.5">Diagnosis Period</span>
                  <span className="text-sm text-slate-700">
                    {caseData.diagnosis_date_start ?? '—'} to {caseData.diagnosis_date_end ?? 'present'}
                  </span>
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Uploaded documents */}
      {(submission?.documents.length ?? 0) > 0 && (
        <div className="bg-white rounded-2xl border border-slate-200 p-5 mb-4">
          <div className="flex items-center justify-between mb-3">
            <h2 className="font-semibold text-slate-900 text-sm flex items-center gap-2">
              <Upload size={15} className="text-slate-400" /> Your Documents
              <span className="text-xs bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full font-medium">{submission!.documents.length}</span>
            </h2>
            <Link to={`/documents/${caseData.slug}`} className="text-xs text-blue-600 hover:text-blue-700 font-medium flex items-center gap-1">
              Add more <ChevronRight size={11} />
            </Link>
          </div>
          <div className="space-y-2">
            {submission!.documents.map(doc => (
              <div key={doc.id} className="flex items-center gap-3 p-2.5 rounded-xl bg-slate-50">
                <FileText size={14} className="text-slate-400 shrink-0" />
                <div className="flex-1 min-w-0">
                  <p className="text-sm text-slate-700 truncate">{doc.file_name}</p>
                  <p className="text-xs text-slate-400">{doc.document_type} &bull; {doc.file_size ? `${(doc.file_size / 1024).toFixed(0)} KB` : ''}</p>
                </div>
                <CheckCircle2 size={14} className="text-emerald-500 shrink-0" />
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Public source references for transparency */}
      {(caseData.source_urls?.length ?? 0) > 0 && (
        <div className="bg-white rounded-2xl border border-slate-200 p-5 mb-4">
          <h2 className="font-semibold text-slate-900 text-sm mb-2 flex items-center gap-2">
            <Shield size={15} className="text-slate-400" /> Public References
          </h2>
          <p className="text-xs text-slate-500 mb-3 leading-relaxed">
            We only summarize public reporting and court records. Click any link to view the original source.
          </p>
          <ul className="space-y-1.5">
            {caseData.source_urls!.map(url => (
              <li key={url}>
                <a
                  href={url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-xs text-blue-700 hover:text-blue-800 hover:underline break-all flex items-start gap-1.5"
                >
                  <ExternalLink size={11} className="shrink-0 mt-0.5" /> {url}
                </a>
              </li>
            ))}
          </ul>
        </div>
      )}

      <div className="bg-slate-100 rounded-xl p-4">
        <p className="text-xs text-slate-500 leading-relaxed">
          <strong>Disclaimer:</strong> This is not legal advice. Submitting information does not create an attorney-client relationship. A legal professional must review your information before any eligibility determination.
        </p>
      </div>
    </div>
  );
}
