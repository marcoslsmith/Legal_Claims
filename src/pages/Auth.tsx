import React, { useState, useEffect } from 'react';
import { useNavigate, useSearchParams, Link } from 'react-router-dom';
import { Scale, Eye, EyeOff, AlertCircle } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { trackRegistrationComplete, updateMetaAdvancedMatching } from '../lib/metaPixel';

export default function Auth() {
  const [params] = useSearchParams();
  const mode = params.get('mode') || 'signin';
  const nextPath = params.get('next') || 'dashboard';

  const [isSignUp, setIsSignUp] = useState(mode === 'signup');
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPw, setShowPw] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const { signIn, signUp, user, isAdmin, loading: authLoading } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (user && !authLoading) {
      navigate(isAdmin ? '/admin' : `/${nextPath}`);
    }
  }, [user, isAdmin, authLoading]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    if (isSignUp && !fullName.trim()) {
      setError('Please enter your full name.');
      setLoading(false);
      return;
    }

    const { error: err } = isSignUp
      ? await signUp(email, password, fullName)
      : await signIn(email, password);

    setLoading(false);
    if (err) {
      setError(err.message || 'An error occurred. Please try again.');
      return;
    }
    if (isSignUp) {
      const firstName = fullName.trim().split(/\s+/)[0];
      const lastName = fullName.trim().split(/\s+/).slice(1).join(' ');
      trackRegistrationComplete('email', { email, firstName, lastName });
      updateMetaAdvancedMatching({ email, firstName, lastName });
    }
    // navigation is handled by the useEffect once profile loads
  };

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col items-center justify-center px-4 py-12">
      <Link to="/" className="flex items-center gap-2 mb-8 group">
        <div className="w-9 h-9 bg-blue-700 rounded-xl flex items-center justify-center group-hover:bg-blue-800 transition-colors">
          <Scale size={18} className="text-white" />
        </div>
        <span className="font-semibold text-slate-900 text-xl">ClaimFinder</span>
      </Link>

      <div className="w-full max-w-md bg-white rounded-2xl border border-slate-200 shadow-sm p-8">
        <h1 className="text-xl font-bold text-slate-900 mb-1">
          {isSignUp ? 'Create your account' : 'Welcome back'}
        </h1>
        <p className="text-slate-500 text-sm mb-6">
          {isSignUp ? 'Start checking your eligibility for active legal claims.' : 'Sign in to view your claim matches.'}
        </p>

        {error && (
          <div className="flex items-start gap-2 bg-red-50 border border-red-200 text-red-700 rounded-xl p-3 mb-5 text-sm">
            <AlertCircle size={16} className="mt-0.5 shrink-0" />
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          {isSignUp && (
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1.5">Full Name</label>
              <input
                type="text"
                value={fullName}
                onChange={e => setFullName(e.target.value)}
                placeholder="Jane Smith"
                className="w-full px-3.5 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                required
              />
            </div>
          )}

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1.5">Email Address</label>
            <input
              type="email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              placeholder="you@example.com"
              className="w-full px-3.5 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1.5">Password</label>
            <div className="relative">
              <input
                type={showPw ? 'text' : 'password'}
                value={password}
                onChange={e => setPassword(e.target.value)}
                placeholder="••••••••"
                minLength={6}
                className="w-full px-3.5 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all pr-10"
                required
              />
              <button
                type="button"
                onClick={() => setShowPw(!showPw)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors"
              >
                {showPw ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-blue-700 hover:bg-blue-800 disabled:bg-blue-400 text-white font-semibold py-3 rounded-xl transition-colors text-sm"
          >
            {loading ? 'Please wait...' : isSignUp ? 'Create Account' : 'Sign In'}
          </button>
        </form>

        <div className="mt-5 text-center">
          <button
            onClick={() => { setIsSignUp(!isSignUp); setError(''); }}
            className="text-sm text-blue-600 hover:text-blue-800 transition-colors"
          >
            {isSignUp ? 'Already have an account? Sign in' : "Don't have an account? Sign up free"}
          </button>
        </div>

        {isSignUp && (
          <p className="mt-5 text-xs text-slate-400 text-center leading-relaxed">
            By creating an account, you agree that this is not legal advice and submitting information does not create an attorney-client relationship.
          </p>
        )}
      </div>
    </div>
  );
}
