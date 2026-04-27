import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Upload, X, FileText, CheckCircle, AlertCircle, ShieldCheck } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import type { UploadedDocument } from '../types/database';

const DOC_TYPES = [
  { value: 'diagnosis_proof', label: 'Diagnosis / Medical Records' },
  { value: 'prescription_records', label: 'Prescription Records' },
  { value: 'proof_of_purchase', label: 'Proof of Purchase' },
  { value: 'employment_docs', label: 'Employment Documents' },
  { value: 'data_breach_notice', label: 'Data Breach Notice' },
  { value: 'other', label: 'Other Supporting Documents' },
];

interface CaseDocConfig {
  require_medical_docs: boolean;
  required_doc_types: string[];
}

export default function Documents() {
  const { slug } = useParams<{ slug: string }>();
  const { user } = useAuth();
  const navigate = useNavigate();

  const [submissionId, setSubmissionId] = useState<string | null>(null);
  const [docs, setDocs] = useState<UploadedDocument[]>([]);
  const [uploading, setUploading] = useState(false);
  const [docType, setDocType] = useState('diagnosis_proof');
  const [dragOver, setDragOver] = useState(false);
  const [error, setError] = useState('');
  const [caseConfig, setCaseConfig] = useState<CaseDocConfig>({ require_medical_docs: false, required_doc_types: [] });

  useEffect(() => {
    if (!user) { navigate('/auth'); return; }
    loadSubmission();
  }, [user, slug]);

  const loadSubmission = async () => {
    const { data: caseRow } = await supabase
      .from('cases')
      .select('id, require_medical_docs, required_doc_types')
      .eq('slug', slug)
      .maybeSingle();
    if (!caseRow) return;

    setCaseConfig({
      require_medical_docs: caseRow.require_medical_docs ?? false,
      required_doc_types: caseRow.required_doc_types ?? [],
    });

    const { data: sub } = await supabase
      .from('submissions')
      .select('*')
      .eq('user_id', user!.id)
      .eq('case_id', caseRow.id)
      .maybeSingle();

    if (sub) {
      setSubmissionId(sub.id);
      const { data: docData } = await supabase
        .from('uploaded_documents')
        .select('*')
        .eq('submission_id', sub.id);
      setDocs(docData || []);
    }
  };

  const handleFileSelect = async (files: FileList | null) => {
    if (!files || !user || !submissionId) return;
    setError('');
    setUploading(true);

    for (const file of Array.from(files)) {
      if (file.size > 10 * 1024 * 1024) {
        setError(`File "${file.name}" exceeds 10MB limit.`);
        continue;
      }
      const path = `${user.id}/${submissionId}/${Date.now()}_${file.name}`;
      const { error: uploadErr } = await supabase.storage.from('documents').upload(path, file);
      if (uploadErr) {
        setError(`Upload failed: ${uploadErr.message}`);
        continue;
      }
      const { data: docRow } = await supabase.from('uploaded_documents').insert({
        user_id: user.id,
        submission_id: submissionId,
        document_type: docType,
        file_name: file.name,
        file_path: path,
        file_size: file.size,
        mime_type: file.type,
      }).select().single();
      if (docRow) setDocs(prev => [...prev, docRow]);
    }
    setUploading(false);
  };

  const handleRemove = async (doc: UploadedDocument) => {
    await supabase.storage.from('documents').remove([doc.file_path]);
    await supabase.from('uploaded_documents').delete().eq('id', doc.id);
    setDocs(prev => prev.filter(d => d.id !== doc.id));
  };

  const formatSize = (bytes: number) => {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  };

  const uploadedTypes = new Set(docs.map(d => d.document_type));
  const missingRequired = caseConfig.required_doc_types.filter(t => !uploadedTypes.has(t));
  const canContinue = !caseConfig.require_medical_docs || missingRequired.length === 0;

  return (
    <div className="max-w-xl mx-auto px-4 sm:px-6 py-10">
      <h1 className="text-2xl font-bold text-slate-900 mb-2">Upload Documents</h1>

      {caseConfig.require_medical_docs ? (
        <p className="text-slate-500 text-sm mb-5">
          This case requires supporting documents to proceed. Please upload all required documents below.
        </p>
      ) : (
        <p className="text-slate-500 text-sm mb-5">
          Supporting documents can strengthen your claim. You may skip this step and upload later from your dashboard.
        </p>
      )}

      {/* Required docs checklist */}
      {caseConfig.required_doc_types.length > 0 && (
        <div className="bg-blue-50 border border-blue-200 rounded-2xl p-4 mb-5">
          <div className="flex items-center gap-2 mb-3">
            <ShieldCheck size={15} className="text-blue-600 shrink-0" />
            <span className="text-sm font-semibold text-blue-800">Required Documents</span>
          </div>
          <div className="space-y-2">
            {caseConfig.required_doc_types.map(type => {
              const label = DOC_TYPES.find(t => t.value === type)?.label ?? type;
              const done = uploadedTypes.has(type);
              return (
                <div key={type} className={`flex items-center gap-2.5 text-sm rounded-xl px-3 py-2 ${done ? 'bg-emerald-50 text-emerald-800' : 'bg-white text-slate-700 border border-slate-200'}`}>
                  {done
                    ? <CheckCircle size={14} className="text-emerald-500 shrink-0" />
                    : <div className="w-3.5 h-3.5 rounded-full border-2 border-slate-300 shrink-0" />}
                  <span className={done ? 'line-through text-emerald-600' : ''}>{label}</span>
                </div>
              );
            })}
          </div>
        </div>
      )}

      <div className="bg-white rounded-2xl border border-slate-200 p-6 mb-6 space-y-4">
        <div>
          <label className="block text-sm font-medium text-slate-700 mb-1.5">Document Type</label>
          <select
            value={docType}
            onChange={e => setDocType(e.target.value)}
            className="w-full px-3.5 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
          >
            {DOC_TYPES.map(t => <option key={t.value} value={t.value}>{t.label}</option>)}
          </select>
        </div>

        <div
          className={`border-2 border-dashed rounded-xl p-8 text-center transition-all duration-200 ${dragOver ? 'border-blue-400 bg-blue-50' : 'border-slate-300 hover:border-blue-300'}`}
          onDragOver={e => { e.preventDefault(); setDragOver(true); }}
          onDragLeave={() => setDragOver(false)}
          onDrop={e => { e.preventDefault(); setDragOver(false); handleFileSelect(e.dataTransfer.files); }}
        >
          <Upload size={32} className="mx-auto text-slate-400 mb-3" />
          <p className="text-sm font-medium text-slate-700 mb-1">Drag & drop files here</p>
          <p className="text-xs text-slate-500 mb-4">PDF, JPG, PNG, DOC up to 10MB</p>
          <label className="cursor-pointer inline-flex items-center gap-2 bg-blue-700 hover:bg-blue-800 text-white text-sm font-medium px-4 py-2 rounded-xl transition-colors">
            <Upload size={14} /> Choose Files
            <input
              type="file"
              multiple
              className="hidden"
              accept=".pdf,.jpg,.jpeg,.png,.doc,.docx"
              onChange={e => handleFileSelect(e.target.files)}
            />
          </label>
        </div>

        {uploading && (
          <div className="flex items-center gap-2 text-sm text-blue-600">
            <div className="w-4 h-4 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
            Uploading...
          </div>
        )}

        {error && (
          <div className="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 rounded-xl p-3 text-sm">
            <AlertCircle size={15} /> {error}
          </div>
        )}
      </div>

      {docs.length > 0 && (
        <div className="bg-white rounded-2xl border border-slate-200 p-6 mb-6">
          <h2 className="font-semibold text-slate-900 text-sm mb-3">Uploaded Documents ({docs.length})</h2>
          <div className="space-y-2">
            {docs.map(doc => (
              <div key={doc.id} className="flex items-center justify-between bg-slate-50 rounded-xl p-3">
                <div className="flex items-center gap-2 min-w-0">
                  <FileText size={16} className="text-blue-600 shrink-0" />
                  <div className="min-w-0">
                    <p className="text-sm font-medium text-slate-800 truncate">{doc.file_name}</p>
                    <p className="text-xs text-slate-500">
                      {DOC_TYPES.find(t => t.value === doc.document_type)?.label} &bull; {formatSize(doc.file_size || 0)}
                    </p>
                  </div>
                </div>
                <button
                  onClick={() => handleRemove(doc)}
                  className="p-1.5 text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
                >
                  <X size={15} />
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {!submissionId && (
        <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-6">
          <div className="flex items-start gap-2">
            <AlertCircle size={15} className="text-amber-600 mt-0.5 shrink-0" />
            <p className="text-xs text-amber-800">
              You need to complete the intake form before uploading documents. Go back and complete the questionnaire first.
            </p>
          </div>
        </div>
      )}

      {/* Blocked notice when required docs missing */}
      {caseConfig.require_medical_docs && missingRequired.length > 0 && docs.length > 0 && (
        <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-6">
          <div className="flex items-start gap-2">
            <AlertCircle size={15} className="text-amber-600 mt-0.5 shrink-0" />
            <p className="text-xs text-amber-800">
              Please upload the remaining required document{missingRequired.length > 1 ? 's' : ''} to continue.
            </p>
          </div>
        </div>
      )}

      <div className="flex gap-3">
        <button
          onClick={() => navigate(-1)}
          className="flex-1 border border-slate-300 text-slate-700 font-medium py-3 rounded-xl hover:bg-slate-50 transition-colors text-sm"
        >
          Back
        </button>
        <button
          disabled={!canContinue}
          onClick={() => slug && navigate(`/consent/${slug}`)}
          className="flex-1 bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 disabled:cursor-not-allowed text-white font-semibold py-3 rounded-xl transition-colors text-sm flex items-center justify-center gap-2"
        >
          {docs.length > 0 ? <><CheckCircle size={16} /> Continue</> : caseConfig.require_medical_docs ? 'Upload Required Docs' : 'Skip for Now →'}
        </button>
      </div>
    </div>
  );
}
