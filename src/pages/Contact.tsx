import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowRight, User, Mail, Phone } from 'lucide-react';
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

export default function Contact() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (!user) { navigate('/auth?next=contact'); return; }
    loadProfile();
  }, [user]);

  const loadProfile = async () => {
    const { data } = await supabase.from('profiles').select('full_name, email, phone').eq('id', user!.id).maybeSingle();
    if (data) {
      if (data.full_name) setFullName(data.full_name);
      if (data.email) setEmail(data.email);
      else setEmail(user!.email || '');
      if (data.phone) setPhone(data.phone);

      // Already have all contact info — skip ahead
      if (data.full_name && (data.email || user!.email) && data.phone) {
        navigate('/results', { replace: true });
        return;
      }
    } else {
      setEmail(user!.email || '');
    }
    setLoading(false);
  };

  const formatPhone = (val: string) => {
    const digits = val.replace(/\D/g, '').slice(0, 10);
    if (digits.length <= 3) return digits;
    if (digits.length <= 6) return `(${digits.slice(0, 3)}) ${digits.slice(3)}`;
    return `(${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6)}`;
  };

  const validate = () => {
    const errs: Record<string, string> = {};
    if (!fullName.trim()) errs.fullName = 'Full name is required.';
    if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) errs.email = 'A valid email is required.';
    const digits = phone.replace(/\D/g, '');
    if (digits.length < 10) errs.phone = 'A valid 10-digit phone number is required.';
    return errs;
  };

  const handleSubmit = async () => {
    const errs = validate();
    if (Object.keys(errs).length) { setErrors(errs); return; }
    if (!user) return;

    setSaving(true);
    await supabase.from('profiles').update({
      full_name: fullName.trim(),
      email: email.trim(),
      phone: phone.replace(/\D/g, ''),
      updated_at: new Date().toISOString(),
    }).eq('id', user.id);

    setSaving(false);
    navigate('/results');
  };

  if (loading) return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  return (
    <div className="min-h-[calc(100vh-56px)] bg-slate-50 flex flex-col">
      <FlowStepper steps={FLOW_STEPS} currentStep={1} />
      <div className="max-w-lg mx-auto w-full px-4 sm:px-6 pt-4 pb-6 flex-1 flex flex-col">

        {/* Header */}
        <div className="mb-6">
          <p className="text-xs font-semibold text-blue-600 uppercase tracking-wider mb-2">Step 2 of 4 — Contact Info</p>
          <h1 className="text-2xl font-bold text-slate-900 leading-tight">How can we reach you?</h1>
          <p className="text-slate-500 text-sm mt-1.5 leading-relaxed">
            We need this to connect you with legal professionals. Your information is never sold.
          </p>
        </div>

        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-5 flex-1">

          {/* Full Name */}
          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1.5">
              Full Name <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <User size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none" />
              <input
                type="text"
                value={fullName}
                onChange={e => { setFullName(e.target.value); setErrors(p => ({ ...p, fullName: '' })); }}
                placeholder="Jane Smith"
                className={`w-full pl-10 pr-4 py-3 border rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors ${errors.fullName ? 'border-red-400 bg-red-50' : 'border-slate-300 hover:border-slate-400'}`}
              />
            </div>
            {errors.fullName && <p className="text-xs text-red-600 mt-1">{errors.fullName}</p>}
          </div>

          {/* Email */}
          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1.5">
              Email Address <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <Mail size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none" />
              <input
                type="email"
                value={email}
                onChange={e => { setEmail(e.target.value); setErrors(p => ({ ...p, email: '' })); }}
                placeholder="jane@example.com"
                className={`w-full pl-10 pr-4 py-3 border rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors ${errors.email ? 'border-red-400 bg-red-50' : 'border-slate-300 hover:border-slate-400'}`}
              />
            </div>
            {errors.email && <p className="text-xs text-red-600 mt-1">{errors.email}</p>}
          </div>

          {/* Phone */}
          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1.5">
              Phone Number <span className="text-red-500">*</span>
            </label>
            <div className="relative">
              <Phone size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none" />
              <input
                type="tel"
                value={phone}
                onChange={e => { setPhone(formatPhone(e.target.value)); setErrors(p => ({ ...p, phone: '' })); }}
                placeholder="(555) 123-4567"
                className={`w-full pl-10 pr-4 py-3 border rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors ${errors.phone ? 'border-red-400 bg-red-50' : 'border-slate-300 hover:border-slate-400'}`}
              />
            </div>
            {errors.phone && <p className="text-xs text-red-600 mt-1">{errors.phone}</p>}
            <p className="text-xs text-slate-400 mt-1.5">We may call or text to discuss your claim.</p>
          </div>

          <button
            onClick={handleSubmit}
            disabled={saving}
            className="w-full flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 disabled:cursor-not-allowed text-white font-semibold py-3.5 rounded-xl transition-colors text-sm min-h-[52px] mt-2"
          >
            {saving ? (
              <div className="w-5 h-5 border-2 border-white/40 border-t-white rounded-full animate-spin" />
            ) : (
              <>See My Matches <ArrowRight size={16} /></>
            )}
          </button>
        </div>

        <p className="text-xs text-slate-400 text-center mt-4 px-4 leading-relaxed">
          Your privacy is protected. We never sell your information to third parties.
        </p>
      </div>
    </div>
  );
}
