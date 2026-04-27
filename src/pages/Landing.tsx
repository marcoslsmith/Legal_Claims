import { Link } from 'react-router-dom';
import {
  ArrowRight, Shield, Clock, Users, CheckCircle, AlertCircle,
  DollarSign, Scale, FileCheck, TrendingUp, ChevronRight, Info,
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

const compensationExamples = [
  { name: 'Roundup Weedkiller', range: '$20,000 – $250,000+', type: 'Mass Tort', desc: 'Non-Hodgkin Lymphoma linked to glyphosate herbicide' },
  { name: 'AFFF Firefighting Foam', range: '$30,000 – $300,000+', type: 'Mass Tort', desc: 'PFAS-related cancers from firefighting foam exposure' },
  { name: 'Hair Relaxer', range: '$20,000 – $500,000+', type: 'Mass Tort', desc: 'Uterine cancer and fibroids linked to chemical relaxers' },
  { name: 'Depo-Provera', range: '$25,000 – $400,000+', type: 'Mass Tort', desc: 'Meningioma brain tumors linked to birth control injections' },
  { name: 'Camp Lejeune', range: '$25,000 – $550,000+', type: 'Mass Tort', desc: 'Toxic water contamination exposure 1953–1987' },
  { name: 'Hernia Mesh', range: '$50,000 – $250,000+', type: 'Mass Tort', desc: 'Defective mesh causing chronic pain and complications' },
  { name: 'Ozempic / GLP-1', range: '$10,000 – $200,000+', type: 'Mass Tort', desc: 'Gastroparesis and serious GI injuries from GLP-1 drugs' },
  { name: 'Data Breach', range: '$50 – $10,000+', type: 'Class Action', desc: 'Compensation for exposed personal or financial data' },
  { name: 'Wage & Hour', range: 'Varies by claim', type: 'Class Action', desc: 'Unpaid wages, overtime, and labor law violations' },
];

const steps = [
  { n: '1', title: 'Answer a few questions', desc: 'Takes about 2 minutes. Plain language — no legal jargon required.' },
  { n: '2', title: 'See which claims may match', desc: 'We show you active cases that may apply to your specific situation.' },
  { n: '3', title: 'Submit your intake for review', desc: 'A legal professional reviews your information to assess eligibility.' },
];

const whyCheck = [
  {
    icon: TrendingUp,
    title: 'Billions recovered annually',
    desc: 'Mass tort and class action settlements have returned billions to everyday Americans harmed by corporations.',
  },
  {
    icon: Users,
    title: 'Most people never check',
    desc: 'Millions of people qualify for active legal claims each year but never take the 2 minutes to find out.',
  },
  {
    icon: Clock,
    title: 'Deadlines are real',
    desc: 'Legal claim windows close. Statutes of limitations and case cutoff dates mean waiting can cost you your right to recover.',
  },
  {
    icon: Scale,
    title: 'No fees unless you win',
    desc: 'Most mass tort and class action cases are handled on contingency — you pay nothing unless compensation is recovered.',
  },
];

export default function Landing() {
  const { user } = useAuth();
  const ctaLink = user ? '/quiz' : '/auth?mode=signup&next=quiz';

  return (
    <div>
      {/* Hero */}
      <section className="relative bg-gradient-to-br from-slate-950 via-slate-900 to-slate-800 text-white overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(59,130,246,0.12),transparent_60%)]" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 py-20 sm:py-28 text-center">
          <div className="inline-flex items-center gap-2 bg-blue-500/15 border border-blue-400/25 text-blue-300 text-xs font-semibold px-4 py-2 rounded-full mb-7 tracking-wide uppercase">
            <span className="w-1.5 h-1.5 bg-blue-400 rounded-full animate-pulse" />
            9 Active Legal Claims — Updated 2026
          </div>
          <h1 className="text-4xl sm:text-5xl md:text-6xl font-bold leading-tight mb-6 tracking-tight">
            Millions of Americans may qualify for{' '}
            <span className="text-blue-400">legal compensation</span>{' '}
            and don't know it
          </h1>
          <p className="text-slate-300 text-lg sm:text-xl max-w-2xl mx-auto mb-10 leading-relaxed">
            Check active mass torts and class action lawsuits in under 2 minutes. Free to check — no commitment, no fees, no obligation.
          </p>
          <div className="flex flex-col sm:flex-row gap-3 justify-center mb-8">
            <Link
              to={ctaLink}
              className="inline-flex items-center justify-center gap-2 bg-blue-600 hover:bg-blue-500 text-white font-bold px-9 py-4 rounded-xl transition-all duration-200 text-base shadow-xl hover:shadow-blue-500/30 hover:-translate-y-0.5"
            >
              Check My Matches — Free <ArrowRight size={18} />
            </Link>
            {user ? (
              <Link
                to="/dashboard"
                className="inline-flex items-center justify-center gap-2 bg-white/10 hover:bg-white/20 text-white font-medium px-8 py-4 rounded-xl transition-all duration-200 text-base border border-white/20"
              >
                My Dashboard
              </Link>
            ) : (
              <Link
                to="/auth"
                className="inline-flex items-center justify-center gap-2 bg-white/10 hover:bg-white/20 text-white font-medium px-8 py-4 rounded-xl transition-all duration-200 text-base border border-white/20"
              >
                Sign In
              </Link>
            )}
          </div>
          {/* Trust micro-proof */}
          <div className="flex flex-wrap items-center justify-center gap-5 text-xs text-slate-400">
            <span className="flex items-center gap-1.5"><CheckCircle size={13} className="text-emerald-400" /> Free eligibility check</span>
            <span className="flex items-center gap-1.5"><CheckCircle size={13} className="text-emerald-400" /> No attorney fees unless you win</span>
            <span className="flex items-center gap-1.5"><CheckCircle size={13} className="text-emerald-400" /> Results in under 2 minutes</span>
            <span className="flex items-center gap-1.5"><CheckCircle size={13} className="text-emerald-400" /> We will never ask for payment or a credit card</span>
          </div>
        </div>
      </section>

      {/* Stats bar */}
      <section className="bg-blue-700 text-white">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 py-5">
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 text-center">
            {[
              { value: '9', label: 'Active Claims' },
              { value: '2 min', label: 'Average Check Time' },
              { value: '$0', label: 'Cost to Check' },
              { value: '100%', label: 'Free, No Obligation' },
            ].map(({ value, label }) => (
              <div key={label}>
                <div className="text-2xl font-bold">{value}</div>
                <div className="text-blue-200 text-xs mt-0.5">{label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Why Check */}
      <section className="py-16 sm:py-20 bg-white">
        <div className="max-w-5xl mx-auto px-4 sm:px-6">
          <div className="text-center mb-12">
            <h2 className="text-2xl sm:text-3xl font-bold text-slate-900 mb-3">Why check your eligibility?</h2>
            <p className="text-slate-500 max-w-xl mx-auto text-base">
              Most people affected by dangerous products, medications, and corporate misconduct never collect what they may be owed.
            </p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
            {whyCheck.map(({ icon: Icon, title, desc }) => (
              <div key={title} className="flex gap-4 bg-slate-50 rounded-2xl p-5 border border-slate-100">
                <div className="w-11 h-11 bg-blue-100 rounded-xl flex items-center justify-center shrink-0">
                  <Icon size={20} className="text-blue-700" />
                </div>
                <div>
                  <h3 className="font-semibold text-slate-900 mb-1 text-sm">{title}</h3>
                  <p className="text-slate-500 text-sm leading-relaxed">{desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Compensation examples */}
      <section className="py-16 sm:py-20 bg-slate-50">
        <div className="max-w-5xl mx-auto px-4 sm:px-6">
          <div className="text-center mb-4">
            <h2 className="text-2xl sm:text-3xl font-bold text-slate-900 mb-3">Potential compensation ranges</h2>
            <p className="text-slate-500 max-w-2xl mx-auto text-base leading-relaxed">
              These are estimated ranges based on past settlements and verdicts. Actual compensation varies based on your specific facts, medical history, and legal review.
            </p>
          </div>
          <div className="flex items-center justify-center gap-2 mb-10 text-xs text-amber-700 bg-amber-50 border border-amber-200 rounded-xl px-4 py-2.5 max-w-xl mx-auto">
            <Info size={13} className="shrink-0" />
            Potential compensation may vary significantly. These figures are not guarantees. Legal review required to determine eligibility.
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {compensationExamples.map((c) => (
              <div key={c.name} className="bg-white rounded-2xl border border-slate-200 p-5 hover:border-blue-200 hover:shadow-md transition-all duration-200 group">
                <div className="flex items-start justify-between gap-2 mb-3">
                  <h3 className="font-bold text-slate-900 text-sm leading-snug group-hover:text-blue-700 transition-colors">{c.name}</h3>
                  <span className={`text-xs px-2 py-0.5 rounded-full font-medium shrink-0 ${c.type === 'Mass Tort' ? 'bg-blue-100 text-blue-700' : 'bg-teal-100 text-teal-700'}`}>{c.type}</span>
                </div>
                <p className="text-xs text-slate-500 leading-relaxed mb-3">{c.desc}</p>
                <div className="flex items-center gap-2 bg-emerald-50 rounded-lg px-3 py-2 border border-emerald-100">
                  <DollarSign size={13} className="text-emerald-600 shrink-0" />
                  <div>
                    <div className="text-xs text-emerald-600 font-medium">Potential compensation</div>
                    <div className="text-sm font-bold text-emerald-800">{c.range}</div>
                  </div>
                </div>
              </div>
            ))}
          </div>
          <div className="text-center mt-10">
            <Link
              to={ctaLink}
              className="inline-flex items-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-bold px-9 py-4 rounded-xl transition-all duration-200 shadow-md hover:-translate-y-0.5"
            >
              Check If I Qualify <ArrowRight size={18} />
            </Link>
            <p className="mt-3 text-xs text-slate-400">Free check · No fees unless you win · Takes 2 minutes</p>
          </div>
        </div>
      </section>

      {/* How it works */}
      <section className="py-16 sm:py-20 bg-white">
        <div className="max-w-5xl mx-auto px-4 sm:px-6">
          <div className="text-center mb-12">
            <h2 className="text-2xl sm:text-3xl font-bold text-slate-900 mb-3">How it works</h2>
            <p className="text-slate-600 max-w-xl mx-auto">A simple, guided process that takes under 2 minutes to complete.</p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-5 mb-12">
            {steps.map((s, i) => (
              <div key={s.n} className="relative bg-slate-50 rounded-2xl p-6 border border-slate-200">
                {i < steps.length - 1 && (
                  <div className="hidden sm:block absolute top-8 -right-3 z-10">
                    <ChevronRight size={20} className="text-slate-300" />
                  </div>
                )}
                <div className="w-10 h-10 bg-blue-700 rounded-xl flex items-center justify-center text-white font-bold text-sm mb-4">{s.n}</div>
                <h3 className="font-semibold text-slate-900 mb-2 text-sm">{s.title}</h3>
                <p className="text-slate-500 text-sm leading-relaxed">{s.desc}</p>
              </div>
            ))}
          </div>
          <div className="text-center">
            <Link
              to={ctaLink}
              className="inline-flex items-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-bold px-9 py-4 rounded-xl transition-all duration-200 shadow-md hover:-translate-y-0.5"
            >
              Start My Free Check <ArrowRight size={18} />
            </Link>
          </div>
        </div>
      </section>

      {/* Urgency / social proof */}
      <section className="bg-slate-900 text-white py-10">
        <div className="max-w-5xl mx-auto px-4 sm:px-6">
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 text-center">
            {[
              { icon: Clock, text: 'Claim deadlines may apply — eligibility windows can close without notice' },
              { icon: FileCheck, text: 'New cases open regularly as litigation expands to new products and injuries' },
              { icon: Shield, text: 'Your information is private and secure — we never sell your data' },
            ].map(({ icon: Icon, text }) => (
              <div key={text} className="flex flex-col items-center gap-3 px-4 py-2">
                <div className="w-10 h-10 bg-white/10 rounded-xl flex items-center justify-center">
                  <Icon size={18} className="text-blue-300" />
                </div>
                <p className="text-slate-300 text-sm leading-relaxed">{text}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Disclaimer */}
      <section className="py-8 bg-amber-50 border-y border-amber-200">
        <div className="max-w-4xl mx-auto px-4 sm:px-6">
          <div className="flex items-start gap-3">
            <AlertCircle size={17} className="text-amber-600 mt-0.5 shrink-0" />
            <div className="text-xs text-amber-800 leading-relaxed space-y-1">
              <p className="font-semibold">Important Legal Disclaimers:</p>
              <ul className="list-disc list-inside space-y-0.5 text-amber-700">
                <li>This is not legal advice and does not constitute a legal opinion.</li>
                <li>Submitting information does not create an attorney-client relationship.</li>
                <li>Legal professionals may review submitted claim information.</li>
                <li>Compensation ranges shown are estimates only and are not guarantees of recovery.</li>
                <li>Claim availability and eligibility criteria may change based on case status and jurisdiction.</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* Final CTA */}
      <section className="py-16 sm:py-20 bg-gradient-to-br from-blue-700 to-blue-900 text-white text-center">
        <div className="max-w-2xl mx-auto px-4 sm:px-6">
          <CheckCircle size={44} className="text-blue-200 mx-auto mb-5" />
          <h2 className="text-2xl sm:text-3xl font-bold mb-4 leading-tight">Don't wait to find out if you qualify</h2>
          <p className="text-blue-200 mb-8 text-base leading-relaxed max-w-lg mx-auto">
            Claim windows close. Deadlines apply. It costs nothing to check, and it only takes 2 minutes.
          </p>
          <Link
            to={ctaLink}
            className="inline-flex items-center gap-2 bg-white text-blue-800 hover:bg-blue-50 font-bold px-10 py-4 rounded-xl transition-all duration-200 shadow-lg hover:-translate-y-0.5 text-base"
          >
            Check My Eligibility Now <ArrowRight size={18} />
          </Link>
          <p className="mt-4 text-blue-300 text-xs">Free · No obligation · No attorney fees unless you win</p>
        </div>
      </section>
    </div>
  );
}