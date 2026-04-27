import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Shield, AlertCircle } from 'lucide-react';
import { FlowStepper } from '../components/FlowStepper';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

const FLOW_STEPS = [
  { label: 'Eligibility' },
  { label: 'Contact' },
  { label: 'Intake' },
  { label: 'Consent' },
  { label: 'Done' },
];

const CONSENTS = [
  { key: 'consent_contact', label: 'I agree to be contacted by phone, SMS, and email about potential legal claims.' },
  { key: 'consent_not_legal_advice', label: 'I understand this is not legal advice.' },
  { key: 'consent_no_attorney_client', label: 'I understand that submitting this information does not create an attorney-client relationship.' },
  { key: 'consent_accuracy', label: 'I certify that the information I provided is accurate to the best of my knowledge.' },
];

export default function Consent() {
  const { slug } = useParams<{ slug: string }>();
  const { user } = useAuth();
  const navigate = useNavigate();
  const [checks, setChecks] = useState<Record<string, boolean>>({});
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [submissionId, setSubmissionId] = useState<string | null>(null);

  useEffect(() => {
    if (!user) { navigate('/auth'); return; }
    loadSubmission();
  }, [user, slug]);

  const loadSubmission = async () => {
    const { data: caseRow } = await supabase.from('cases').select('id').eq('slug', slug).maybeSingle();
    if (!caseRow) return;
    const { data: sub } = await supabase.from('submissions').select('*').eq('user_id', user!.id).eq('case_id', caseRow.id).maybeSingle();
    if (sub) setSubmissionId(sub.id);
  };

  const allChecked = CONSENTS.every(c => checks[c.key]);

  const handleSubmit = async () => {
    if (!allChecked || !user || !submissionId) { setError('Please complete all required checkboxes.'); return; }
    setSubmitting(true);
    setError('');

    await supabase.from('consents').insert({
      user_id: user.id,
      submission_id: submissionId,
      consent_contact: checks.consent_contact || false,
      consent_not_legal_advice: checks.consent_not_legal_advice || false,
      consent_no_attorney_client: checks.consent_no_attorney_client || false,
      consent_accuracy: checks.consent_accuracy || false,
      user_agent: navigator.userAgent,
    });

    await supabase.from('submissions').update({
      status: 'submitted',
      submitted_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }).eq('id', submissionId);

    // Record status history
    await supabase.from('lead_status_history').insert({
      submission_id: submissionId,
      old_status: 'in_progress',
      new_status: 'submitted',
      note: 'Submitted by user',
    });

    setSubmitting(false);
    navigate(`/confirmation/${slug}`);
  };

  return (
    <div className="bg-slate-50 min-h-[calc(100vh-56px)]">
      <FlowStepper steps={FLOW_STEPS} currentStep={3} />
    <div className="max-w-xl mx-auto px-4 sm:px-6 py-6">
      <div className="flex items-center gap-3 mb-6">
        <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
          <Shield size={20} className="text-blue-700" />
        </div>
        <div>
          <h1 className="text-xl font-bold text-slate-900">Final Step: Your Consent</h1>
          <p className="text-sm text-slate-500">Please review and agree to the following before submitting.</p>
        </div>
      </div>

      <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-6">
        <div className="flex items-start gap-2">
          <AlertCircle size={16} className="text-amber-600 mt-0.5 shrink-0" />
          <div className="text-xs text-amber-800 leading-relaxed space-y-1">
            <p><strong>Important legal notices:</strong></p>
            <ul className="list-disc list-inside space-y-0.5">
              <li>This is not legal advice and does not constitute a legal opinion.</li>
              <li>No attorney-client relationship is formed by submitting your information.</li>
              <li>Claim availability and eligibility may change at any time.</li>
              <li>A licensed legal professional must review your information before eligibility can be determined.</li>
            </ul>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-2xl border border-slate-200 p-6 space-y-4 mb-6">
        {CONSENTS.map(c => (
          <label key={c.key} className={`flex items-start gap-3 cursor-pointer p-4 rounded-xl transition-colors min-h-[56px] ${checks[c.key] ? 'bg-blue-50 border border-blue-200' : 'hover:bg-slate-50 border border-transparent'}`}>
            <input type="checkbox" checked={checks[c.key] || false}
              onChange={e => setChecks(prev => ({ ...prev, [c.key]: e.target.checked }))}
              className="mt-0.5 w-5 h-5 rounded border-slate-300 text-blue-600 focus:ring-blue-500 shrink-0" />
            <span className="text-sm text-slate-700 leading-relaxed">{c.label}</span>
          </label>
        ))}
      </div>

      {error && (
        <div className="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 rounded-xl p-3 mb-4 text-sm">
          <AlertCircle size={15} /> {error}
        </div>
      )}

      {!submissionId && (
        <div className="bg-amber-50 border border-amber-200 rounded-xl p-3 mb-4">
          <p className="text-xs text-amber-800">No intake submission found. Please complete the intake form first.</p>
        </div>
      )}

      <button
        onClick={handleSubmit}
        disabled={!allChecked || submitting || !submissionId}
        className="w-full bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 disabled:cursor-not-allowed text-white font-semibold py-4 rounded-xl transition-colors text-sm min-h-[56px]"
      >
        {submitting ? 'Submitting...' : 'Submit My Claim Information'}
      </button>

      <p className="text-xs text-slate-400 text-center mt-4">
        Your information is kept private and will only be shared with qualified legal professionals.
      </p>
    </div>
    </div>
  );
}
