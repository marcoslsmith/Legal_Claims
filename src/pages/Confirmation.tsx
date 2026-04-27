import { useParams, Link } from 'react-router-dom';
import { CheckCircle, LayoutDashboard, ArrowRight } from 'lucide-react';
import { FlowStepper } from '../components/FlowStepper';

const FLOW_STEPS = [
  { label: 'Eligibility' },
  { label: 'Contact' },
  { label: 'Intake' },
  { label: 'Consent' },
  { label: 'Done' },
];

export default function Confirmation() {
  const { slug } = useParams<{ slug: string }>();

  return (
    <div className="bg-slate-50 min-h-[calc(100vh-56px)] flex flex-col">
      <FlowStepper steps={FLOW_STEPS} currentStep={4} />
    <div className="flex-1 flex items-center justify-center px-4 py-12">
      <div className="max-w-lg w-full text-center">
        <div className="w-16 h-16 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-6">
          <CheckCircle size={32} className="text-emerald-600" />
        </div>

        <h1 className="text-2xl sm:text-3xl font-bold text-slate-900 mb-3">
          Claim Information Submitted
        </h1>
        <p className="text-slate-600 mb-2 leading-relaxed">
          Your claim information has been submitted for review. A member of our team will evaluate your submission.
        </p>
        <p className="text-slate-500 text-sm mb-8 leading-relaxed">
          We may contact you if more information is needed. You can check the status of your claim at any time from your dashboard.
        </p>

        <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-8 text-left">
          <p className="text-xs text-amber-800 leading-relaxed">
            <strong>Reminder:</strong> This submission does not constitute legal advice or create an attorney-client relationship. Claim availability and eligibility may change. A licensed legal professional will review your information before any eligibility determination is made.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row gap-3 justify-center">
          <Link to="/dashboard" className="flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-semibold px-6 py-3 rounded-xl transition-colors text-sm">
            <LayoutDashboard size={16} /> Go to My Dashboard
          </Link>
          <Link to="/results" className="flex items-center justify-center gap-2 border border-slate-300 text-slate-700 font-medium px-6 py-3 rounded-xl hover:bg-slate-50 transition-colors text-sm">
            View Other Claims <ArrowRight size={15} />
          </Link>
        </div>
      </div>
    </div>
    </div>
  );
}
