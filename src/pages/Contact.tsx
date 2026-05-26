import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowRight, User, Mail, Phone, Shield, DollarSign, Scale, CheckCircle } from 'lucide-react';
import { FlowStepper } from '../components/FlowStepper';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { trackLeadCaptured, updateMetaAdvancedMatching } from '../lib/metaPixel';

const FLOW_STEPS = [
  { label: 'Eligibility' },
  { label: 'Contact' },
  { label: 'Intake' },
  { label: 'Consent' },
  { label: 'Done' },
];

const trustPoints = [
  {
    icon: DollarSign,
    title: 'You never pay out of pocket',
    desc: 'Attorneys in mass tort and class action cases only get paid if they win compensation for you. No win, no fee — ever.',
  },
  {
    icon: Scale,
    title: 'Average settlements range from $25,000 to $500,000+',
    desc: 'Depending on the case, claimants have received significant compensation for injuries caused by defective products, drugs, and corporate misconduct.',
  },
  {
    icon: Shield,
    title: 'Your information is private and secure',
    desc: 'We use your contact details solely to connect you with a licensed attorney for your case. We never sell your data to marketers or third parties.',
  },
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

    updateMetaAdvancedMatching({
      email: email.trim(),
      phone: phone.replace(/\D/g, ''),
      firstName: fullName.trim().split(/\s+/)[0],
      lastName: fullName.trim().split(/\s+/).slice(1).join(' '),
      externalId: user.id,
    });
    trackLeadCaptured({
      email: email.trim(),
      phone: phone.replace(/\D/g, ''),
      firstName: fullName.trim().split(/\s+/)[0],
      lastName: fullName.trim().split(/\s+/).slice(1).join(' '),
      externalId: user.id,
    });

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
      <div className="max-w-lg mx-auto w-full px-4 sm:px-6 pt-4 pb-8 flex-1 flex flex-col">

        {/* Header */}
        <div className="mb-5">
          <p className="text-xs font-semibold text-blue-600 uppercase tracking-wider mb-2">Step 2 of 4 — Contact Info</p>
          <h1 className="text-2xl font-bold text-slate-900 leading-tight">One step away from your results</h1>
          <p className="text-slate-500 text-sm mt-1.5 leading-relaxed">
            We use this to connect you with a licensed attorney for any claims you qualify for. No spam, no sales calls.
          </p>
        </div>

        {/* Trust signals */}
        <div className="space-y-3 mb-5">
          {trustPoints.map(({ icon: Icon, title, desc }) => (
            <div key={title} className="flex items-start gap-3 bg-white rounded-2xl border border-slate-200 p-4">
              <div className="w-9 h-9 bg-blue-100 rounded-xl flex items-center justify-center shrink-0 mt-0.5">
                <Icon size={16} className="text-blue-700" />
              </div>
              <div>
                <p className="text-sm font-semibold text-slate-900 leading-snug">{title}</p>
                <p className="text-xs text-slate-500 mt-0.5 leading-relaxed">{desc}</p>
              </div>
            </div>
          ))}
        </div>

        {/* Form */}
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-5 space-y-4">

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
            <p className="text-xs text-slate-400 mt-1.5">
              An attorney may call or text to discuss your case. Standard messaging rates may apply.
            </p>
          </div>

          <button
            onClick={handleSubmit}
            disabled={saving}
            className="w-full flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 disabled:bg-slate-300 disabled:cursor-not-allowed text-white font-semibold py-3.5 rounded-xl transition-colors text-sm min-h-[52px] mt-1"
          >
            {saving ? (
              <div className="w-5 h-5 border-2 border-white/40 border-t-white rounded-full animate-spin" />
            ) : (
              <>See My Matches <ArrowRight size={16} /></>
            )}
          </button>
        </div>

        {/* Bottom trust strip */}
        <div className="flex flex-wrap items-center justify-center gap-x-4 gap-y-1.5 mt-4 px-2">
          {[
            'No fees unless you win',
            'Never sold to marketers',
            'Attorney review included',
          ].map(t => (
            <span key={t} className="flex items-center gap-1 text-xs text-slate-400">
              <CheckCircle size={11} className="text-emerald-500 shrink-0" />
              {t}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}
