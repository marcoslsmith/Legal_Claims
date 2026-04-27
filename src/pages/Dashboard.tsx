import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { FileText, ArrowRight, Upload, RefreshCw, AlertCircle, CheckCircle2, Clock, ChevronRight } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { MatchBadge } from '../components/MatchBadge';
import { StatusBadge } from '../components/StatusBadge';
import type { Submission, Case, UploadedDocument, MatchTier } from '../types/database';

interface DashboardSub extends Submission {
  case: Case;
  documents: UploadedDocument[];
}

export default function Dashboard() {
  const { user, profile } = useAuth();
  const navigate = useNavigate();
  const [submissions, setSubmissions] = useState<DashboardSub[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) { navigate('/auth'); return; }
    loadData();
  }, [user]);

  const loadData = async () => {
    const { data: subs } = await supabase
      .from('submissions')
      .select('*, cases(*), uploaded_documents(*)')
      .eq('user_id', user!.id)
      .order('created_at', { ascending: false });

    setSubmissions((subs as any[] || []).map(s => ({
      ...s,
      case: s.cases,
      documents: s.uploaded_documents || [],
    })));
    setLoading(false);
  };

  const profileComplete = profile?.full_name && profile?.phone && profile?.state;

  if (loading) return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  const submitted = submissions.filter(s => ['submitted', 'under_review', 'routed', 'accepted'].includes(s.status));
  const inProgress = submissions.filter(s => s.status === 'in_progress');

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-slate-900">
          {profile?.full_name ? `Hi, ${profile.full_name.split(' ')[0]}` : 'My Dashboard'}
        </h1>
        <p className="text-slate-500 text-sm mt-1">Track your claim submissions and eligibility checks</p>
      </div>

      {/* Profile completion banner */}
      {!profileComplete && (
        <Link to="/profile" className="flex items-start gap-3 bg-blue-50 border border-blue-200 rounded-2xl p-4 mb-5 group hover:border-blue-300 transition-colors">
          <AlertCircle size={18} className="text-blue-600 mt-0.5 shrink-0" />
          <div className="flex-1 min-w-0">
            <p className="text-sm font-semibold text-blue-900">Complete your profile</p>
            <p className="text-xs text-blue-700 mt-0.5 leading-relaxed">Add your contact info to speed up the review process.</p>
          </div>
          <ChevronRight size={18} className="text-blue-400 mt-0.5 shrink-0 group-hover:translate-x-0.5 transition-transform" />
        </Link>
      )}

      {/* Stats — 2 per row on mobile */}
      <div className="grid grid-cols-2 gap-3 mb-6">
        {[
          { label: 'Active Claims', value: submissions.length, icon: FileText, color: 'blue' },
          { label: 'Submitted', value: submitted.length, icon: CheckCircle2, color: 'emerald' },
          { label: 'In Progress', value: inProgress.length, icon: Clock, color: 'amber' },
          { label: 'Documents', value: submissions.reduce((acc, s) => acc + s.documents.length, 0), icon: Upload, color: 'slate' },
        ].map(stat => {
          const colors: Record<string, string> = {
            blue: 'bg-blue-50 text-blue-600',
            emerald: 'bg-emerald-50 text-emerald-600',
            amber: 'bg-amber-50 text-amber-600',
            slate: 'bg-slate-100 text-slate-600',
          };
          return (
            <div key={stat.label} className="bg-white rounded-2xl border border-slate-200 p-4">
              <div className={`w-9 h-9 rounded-xl flex items-center justify-center mb-3 ${colors[stat.color]}`}>
                <stat.icon size={18} />
              </div>
              <div className="text-2xl font-bold text-slate-900">{stat.value}</div>
              <div className="text-xs text-slate-500 mt-0.5 font-medium">{stat.label}</div>
            </div>
          );
        })}
      </div>

      {/* CTA if no submissions */}
      {submissions.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-200 p-8 text-center">
          <div className="w-14 h-14 bg-blue-50 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <FileText size={24} className="text-blue-600" />
          </div>
          <h3 className="font-bold text-slate-800 mb-2">No claims started yet</h3>
          <p className="text-slate-500 text-sm mb-6 leading-relaxed">
            Answer a few quick questions to find out which legal claims you may qualify for.
          </p>
          <Link
            to="/quiz"
            className="inline-flex items-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-semibold px-6 py-3.5 rounded-xl transition-colors text-sm"
          >
            Check My Eligibility <ArrowRight size={16} />
          </Link>
        </div>
      ) : (
        <>
          <div className="flex items-center justify-between mb-3">
            <h2 className="font-bold text-slate-900">My Claims</h2>
            <Link to="/quiz" className="text-sm text-blue-600 font-medium flex items-center gap-1">
              Add more <ChevronRight size={14} />
            </Link>
          </div>

          <div className="space-y-3">
            {submissions.map(sub => (
              <div key={sub.id} className="bg-white rounded-2xl border border-slate-200 p-4">
                <button
                  onClick={() => navigate(`/cases/${sub.case?.slug}`)}
                  className="w-full flex items-start justify-between gap-2 mb-3 text-left group"
                >
                  <div className="flex-1 min-w-0">
                    <p className="font-semibold text-slate-900 text-sm leading-snug group-hover:text-blue-700 transition-colors">{sub.case?.name}</p>
                    <p className="text-xs text-slate-400 mt-0.5">
                      {sub.case?.case_type === 'mass_tort' ? 'Mass Tort' : 'Class Action'}
                    </p>
                  </div>
                  <div className="flex items-center gap-2 shrink-0">
                    <StatusBadge status={sub.status} />
                    <ChevronRight size={14} className="text-slate-300 group-hover:text-slate-500 transition-colors" />
                  </div>
                </button>

                {sub.match_tier && (
                  <div className="mb-3">
                    <MatchBadge tier={sub.match_tier as MatchTier} />
                  </div>
                )}

                <div className="flex items-center gap-2 text-xs text-slate-400 mb-3">
                  <span>Started {new Date(sub.created_at!).toLocaleDateString()}</span>
                  {sub.submitted_at && (
                    <>
                      <span>&bull;</span>
                      <span>Submitted {new Date(sub.submitted_at).toLocaleDateString()}</span>
                    </>
                  )}
                  {sub.documents.length > 0 && (
                    <>
                      <span>&bull;</span>
                      <span>{sub.documents.length} doc{sub.documents.length !== 1 ? 's' : ''}</span>
                    </>
                  )}
                </div>

                <div className="flex items-center gap-2">
                  {sub.status === 'in_progress' && (
                    <Link
                      to={`/intake/${sub.case?.slug}`}
                      className="flex-1 flex items-center justify-center gap-1.5 bg-blue-700 hover:bg-blue-800 text-white text-sm font-semibold px-4 py-2.5 rounded-xl transition-colors min-h-[44px]"
                    >
                      Continue Intake <ArrowRight size={14} />
                    </Link>
                  )}
                  <Link
                    to={`/documents/${sub.case?.slug}`}
                    className={`flex items-center justify-center gap-1.5 border border-slate-200 text-slate-600 text-sm font-medium px-4 py-2.5 rounded-xl hover:bg-slate-50 transition-colors min-h-[44px] ${sub.status === 'in_progress' ? '' : 'flex-1'}`}
                  >
                    <Upload size={14} /> Docs
                  </Link>
                </div>
              </div>
            ))}
          </div>

          <button
            onClick={() => loadData()}
            className="flex items-center gap-2 text-sm text-slate-500 hover:text-slate-700 mt-4 transition-colors min-h-[44px] px-2"
          >
            <RefreshCw size={14} /> Refresh
          </button>
        </>
      )}

      <div className="mt-6 bg-slate-100 rounded-xl p-4">
        <p className="text-xs text-slate-500 leading-relaxed">
          <strong>Disclaimer:</strong> This is not legal advice. Submitting information does not create an attorney-client relationship. Claim availability and eligibility may change. A legal professional must review your information before any eligibility determination.
        </p>
      </div>
    </div>
  );
}
