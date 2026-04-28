import React, { useState, useEffect, useRef } from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { Scale, X, LogOut, User, Shield, Search, Home, FileText, Menu, Layers } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

const BOTTOM_TABS = [
  { to: '/', label: 'Home', icon: Home },
  { to: '/quiz', label: 'Check Claims', icon: Search },
  { to: '/browse', label: 'Browse', icon: Layers },
  { to: '/dashboard', label: 'My Claims', icon: FileText },
];

export function Layout({ children }: { children: React.ReactNode }) {
  const { user, profile, signOut, isAdmin } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [menuOpen, setMenuOpen] = useState(false);
  const [headerVisible, setHeaderVisible] = useState(true);
  const lastScrollY = useRef(0);
  const ticking = useRef(false);

  useEffect(() => {
    const onScroll = () => {
      if (ticking.current) return;
      ticking.current = true;
      requestAnimationFrame(() => {
        const currentY = window.scrollY;
        const delta = currentY - lastScrollY.current;

        if (currentY < 60) {
          // Always show near the top
          setHeaderVisible(true);
        } else if (delta > 6) {
          // Scrolling down — hide header, close mobile menu
          setHeaderVisible(false);
          setMenuOpen(false);
        } else if (delta < -6) {
          // Scrolling up — reveal header
          setHeaderVisible(true);
        }

        lastScrollY.current = currentY;
        ticking.current = false;
      });
    };

    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const handleSignOut = async () => {
    await signOut();
    navigate('/');
    setMenuOpen(false);
  };

  const isTabActive = (to: string) => {
    if (to === '/') return location.pathname === '/';
    return location.pathname.startsWith(to);
  };

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col">
      {/* Header — slides up on downscroll, back in on upscroll */}
      <header className={`bg-white border-b border-slate-200 sticky top-0 z-40 transition-transform duration-300 ease-in-out ${headerVisible ? 'translate-y-0' : '-translate-y-full'}`}>
        <div className="max-w-6xl mx-auto px-4 sm:px-6 h-14 sm:h-16 flex items-center justify-between">
          <Link to="/" className="flex items-center gap-2 group">
            <div className="w-8 h-8 bg-blue-700 rounded-lg flex items-center justify-center group-hover:bg-blue-800 transition-colors">
              <Scale size={15} className="text-white" />
            </div>
            <span className="font-semibold text-slate-900 text-base sm:text-lg tracking-tight">ClaimFinder</span>
          </Link>

          {/* Desktop nav */}
          <nav className="hidden md:flex items-center gap-1">
            {!user ? (
              <>
                <Link to="/auth" className="text-sm text-slate-600 hover:text-slate-900 px-3 py-2 rounded-lg hover:bg-slate-100 transition-colors">Sign In</Link>
                <Link to="/auth?mode=signup" className="text-sm bg-blue-700 text-white px-4 py-2 rounded-lg hover:bg-blue-800 transition-colors font-medium">Get Started</Link>
              </>
            ) : (
              <div className="flex items-center gap-1">
                {isAdmin && (
                  <Link to="/admin" className="flex items-center gap-1.5 text-sm text-slate-600 hover:text-slate-900 px-3 py-2 rounded-lg hover:bg-slate-100 transition-colors">
                    <Shield size={14} /> Admin
                  </Link>
                )}
                <div className="w-px h-5 bg-slate-200 mx-1" />
                <Link to="/profile" className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center hover:bg-blue-200 transition-colors" title="My Profile">
                  <span className="text-xs font-semibold text-blue-700">
                    {profile?.full_name?.charAt(0)?.toUpperCase() || user.email?.charAt(0)?.toUpperCase() || 'U'}
                  </span>
                </Link>
                <button onClick={handleSignOut} className="text-sm text-slate-500 hover:text-red-600 px-3 py-2 rounded-lg hover:bg-red-50 transition-colors ml-1">
                  Sign Out
                </button>
              </div>
            )}
          </nav>

          {/* Mobile: show sign in/up if not logged in, or menu button */}
          <div className="md:hidden flex items-center gap-2">
            {!user ? (
              <>
                <Link to="/auth" className="text-sm text-slate-600 px-3 py-1.5 rounded-lg hover:bg-slate-100 transition-colors">Sign In</Link>
                <Link to="/auth?mode=signup" className="text-sm bg-blue-700 text-white px-3 py-1.5 rounded-lg font-medium">Start</Link>
              </>
            ) : (
              <button
                onClick={() => setMenuOpen(!menuOpen)}
                className="w-10 h-10 flex items-center justify-center rounded-xl text-slate-600 hover:bg-slate-100 transition-colors"
                aria-label="Menu"
              >
                {menuOpen ? <X size={20} /> : <Menu size={20} />}
              </button>
            )}
          </div>
        </div>

        {/* Mobile slide-down menu (logged in) */}
        {menuOpen && user && (
          <div className="md:hidden bg-white border-t border-slate-100 px-4 py-3 space-y-1 shadow-lg">
            <div className="px-3 py-2 text-xs text-slate-400 font-medium uppercase tracking-wide">
              {profile?.full_name || user.email}
            </div>
            <Link to="/profile" onClick={() => setMenuOpen(false)}
              className="flex items-center gap-3 px-3 py-3 text-sm text-slate-700 hover:bg-slate-50 rounded-xl transition-colors">
              <User size={17} /> My Profile
            </Link>
            {isAdmin && (
              <Link to="/admin" onClick={() => setMenuOpen(false)}
                className="flex items-center gap-3 px-3 py-3 text-sm text-slate-700 hover:bg-slate-50 rounded-xl transition-colors">
                <Shield size={17} /> Admin Dashboard
              </Link>
            )}
            <div className="pt-1 border-t border-slate-100 mt-1">
              <button onClick={handleSignOut}
                className="flex items-center gap-3 w-full px-3 py-3 text-sm text-red-600 hover:bg-red-50 rounded-xl transition-colors">
                <LogOut size={17} /> Sign Out
              </button>
            </div>
          </div>
        )}
      </header>

      {/* Main content — add bottom padding on mobile to clear tab bar */}
      <main className="flex-1 pb-20 md:pb-0" onClick={() => setMenuOpen(false)}>
        {children}
      </main>

      {/* Footer — hidden on mobile (tab bar replaces it contextually) */}
      <footer className="hidden md:block bg-white border-t border-slate-200">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 py-8">
          <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <div className="flex items-center gap-2">
              <div className="w-7 h-7 bg-blue-700 rounded-lg flex items-center justify-center">
                <Scale size={13} className="text-white" />
              </div>
              <span className="font-semibold text-slate-800">ClaimFinder</span>
            </div>
            <div className="text-xs text-slate-500 max-w-xl leading-relaxed">
              <strong className="text-slate-600">Disclaimer:</strong> This is not legal advice. Submitting information does not create an attorney-client relationship. Claim availability and eligibility may change. A legal professional may need to review the information before determining eligibility.
            </div>
          </div>
          <div className="mt-4 pt-4 border-t border-slate-100 text-xs text-slate-400 text-center">
            &copy; {new Date().getFullYear()} ClaimFinder. All rights reserved.
          </div>
        </div>
      </footer>

      {/* Mobile bottom tab bar */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 z-40 bg-white border-t border-slate-200 safe-area-bottom">
        <div className="grid grid-cols-4 h-16">
          {BOTTOM_TABS.map(tab => {
            const active = isTabActive(tab.to);
            const needsAuth = tab.to !== '/';
            if (needsAuth && !user) {
              return (
                <Link
                  key={tab.to}
                  to="/auth"
                  className={`flex flex-col items-center justify-center gap-1 transition-colors ${active ? 'text-blue-700' : 'text-slate-400'}`}
                >
                  <tab.icon size={22} strokeWidth={active ? 2.5 : 1.8} />
                  <span className="text-[10px] font-medium">{tab.label}</span>
                </Link>
              );
            }
            return (
              <Link
                key={tab.to}
                to={tab.to}
                className={`flex flex-col items-center justify-center gap-1 transition-colors active:scale-95 ${active ? 'text-blue-700' : 'text-slate-400 hover:text-slate-600'}`}
              >
                <tab.icon size={22} strokeWidth={active ? 2.5 : 1.8} />
                <span className={`text-[10px] font-medium ${active ? 'text-blue-700' : ''}`}>{tab.label}</span>
              </Link>
            );
          })}
        </div>
      </nav>
    </div>
  );
}
