import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { CheckCircle, LayoutDashboard, ArrowRight, DollarSign, Sparkles } from 'lucide-react';
import { FlowStepper } from '../components/FlowStepper';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import type { Case } from '../types/database';

const FLOW_STEPS = [
  { label: 'Eligibility' },
  { label: 'Contact' },
  { label: 'Intake' },
  { label: 'Consent' },
  { label: 'Done' },
];

export default function Confirmation() {
  const { slug } = useParams<{ slug: string }>();
  const { user } = useAuth();
  const [suggestedCases, setSuggestedCases] = useState<Case[]>([]);

  useEffect(() => {
    if (user) loadSuggestions();
  }, [user]);

  const loadSuggestions = async () => {
    const [{ data: activeCases }, { data: subs }] = await Promise.all([
      supabase.from('cases').select('*').eq('status', 'active').order('priority_score', { ascending: false }),
      supabase.from('submissions').select('case_id, status').eq('user_id', user!.id),
    ]);

    // Find the current case's ID so we can exclude it
    const currentCase = (activeCases || []).find(c => c.slug === slug);
    const touchedCaseIds = new Set((subs || []).map(s => s.case_id));
    if (currentCase) touchedCaseIds.add(currentCase.id);

    const notStarted = (activeCases || []).filter(c => !touchedCaseIds.has(c.id));
    setSuggestedCases(notStarted.slice(0, 3));
  };

  return (
    <div className="bg-slate-50 min-h-[calc(100vh-56px)] flex flex-col">
      <FlowStepper steps={FLOW_STEPS} currentStep={4} />
      <div className="flex-1 px-4 py-10">
        <div className="max-w-lg mx-auto text-center">
          {/* Success header */}
          <div className="w-16 h-16 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <CheckCircle size={32} className="text-emerald-600" />
          </div>
          <h1 className="text-2xl sm:text-3xl font-bold text-slate-900 mb-3">
            Claim Information Submitted
          </h1>
          <p className="text-slate-600 mb-2 leading-relaxed">
            Your claim information has been submitted for review. A member of our team will evaluate your submission.
          </p>
          <p className="text-slate-500 text-sm mb-6 leading-relaxed">
            We may contact you if more information is needed. You can check the status of your claim at any time from your dashboard.
          </p>

          <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-8 text-left">
            <p className="text-xs text-amber-800 leading-relaxed">
              <strong>Reminder:</strong> This submission does not constitute legal advice or create an attorney-client relationship. Claim availability and eligibility may change. A licensed legal professional will review your information before any eligibility determination is made.
            </p>
          </div>

          <div className="flex flex-col sm:flex-row gap-3 justify-center mb-10">
            <Link
              to="/dashboard"
              className="flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-semibold px-6 py-3 rounded-xl transition-colors text-sm"
            >
              <LayoutDashboard size={16} /> Go to My Dashboard
            </Link>
            <Link
              to="/results"
              className="flex items-center justify-center gap-2 border border-slate-300 text-slate-700 font-medium px-6 py-3 rounded-xl hover:bg-slate-50 transition-colors text-sm"
            >
              View All My Matches <ArrowRight size={15} />
            </Link>
          </div>
        </div>

        {/* Cross-sell: other cases they haven't started */}
        {suggestedCases.length > 0 && (
          <div className="max-w-lg mx-auto">
            <div className="flex items-center gap-2 mb-4 justify-center">
              <Sparkles size={16} className="text-blue-600" />
              <h2 className="font-bold text-slate-900 text-base">
                While you wait — you may also qualify for these
              </h2>
            </div>
            <p className="text-sm text-slate-500 text-center mb-5 leading-relaxed">
              Based on your profile, there are other active claims worth checking. It only takes a few minutes per case.
            </p>

            <div className="space-y-3 mb-6">
              {suggestedCases.map(c => (
                <div
                  key={c.id}
                  className="bg-white rounded-2xl border border-slate-200 p-4 hover:border-blue-200 hover:shadow-sm transition-all"
                >
                  <div className="flex items-start justify-between gap-3 mb-2">
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap mb-1">
                        <h3 className="font-bold text-slate-900 text-sm leading-snug">{c.name}</h3>
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium shrink-0 ${c.case_type === 'mass_tort' ? 'bg-blue-100 text-blue-700' : 'bg-teal-100 text-teal-700'}`}>
                          {c.case_type === 'mass_tort' ? 'Mass Tort' : 'Class Action'}
                        </span>
                      </div>
                      {c.short_description && (
                        <p className="text-xs text-slate-500 leading-relaxed line-clamp-2">{c.short_description}</p>
                      )}
                    </div>
                  </div>
                  {c.payout_range && (
                    <div className="flex items-center gap-2 bg-emerald-50 rounded-lg px-3 py-1.5 mb-3 border border-emerald-100">
                      <DollarSign size={12} className="text-emerald-600 shrink-0" />
                      <span className="text-xs font-bold text-emerald-800">{c.payout_range}</span>
                    </div>
                  )}
                  <Link
                    to={`/intake/${c.slug}`}
                    className="flex items-center justify-center gap-2 bg-blue-700 hover:bg-blue-800 text-white text-xs font-semibold px-4 py-2.5 rounded-xl transition-colors w-full min-h-[40px]"
                  >
                    Start Intake <ArrowRight size={13} />
                  </Link>
                </div>
              ))}
            </div>

            <div className="text-center">
              <Link
                to="/results"
                className="text-sm text-blue-600 hover:text-blue-800 font-medium transition-colors"
              >
                See all my matches →
              </Link>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
