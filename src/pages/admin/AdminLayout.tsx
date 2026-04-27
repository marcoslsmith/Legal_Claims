import React, { useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { BarChart2, Briefcase, HelpCircle, Link2, SlidersHorizontal, Users, Menu, X, Shield, LogOut, Scale, Home, Sparkles } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';

const NAV = [
  { to: '/admin', label: 'Overview', icon: BarChart2, exact: true },
  { to: '/admin/leads', label: 'Leads', icon: Users },
  { to: '/admin/cases', label: 'Cases', icon: Briefcase },
  { to: '/admin/questions', label: 'Questions', icon: HelpCircle },
  { to: '/admin/case-forms', label: 'Case Forms', icon: Link2 },
  { to: '/admin/rules', label: 'Rules', icon: SlidersHorizontal },
  { to: '/admin/ai-import', label: 'AI Import', icon: Sparkles },
];

export function AdminLayout({ children }: { children: React.ReactNode }) {
  const location = useLocation();
  const { signOut, profile } = useAuth();
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const isActive = (item: typeof NAV[0]) => {
    if (item.exact) return location.pathname === item.to;
    return location.pathname.startsWith(item.to);
  };

  const handleSignOut = async () => { await signOut(); navigate('/'); };

  const currentPage = NAV.find(n => isActive(n));

  return (
    <div className="min-h-screen bg-slate-100 flex">
      {/* Desktop sidebar */}
      <aside className="hidden lg:flex flex-col w-56 bg-slate-900 text-white min-h-screen fixed left-0 top-0 z-30">
        <div className="p-5 border-b border-slate-700/60">
          <Link to="/" className="flex items-center gap-2">
            <div className="w-7 h-7 bg-blue-600 rounded-lg flex items-center justify-center">
              <Scale size={14} className="text-white" />
            </div>
            <span className="font-semibold text-sm">ClaimFinder</span>
          </Link>
          <div className="flex items-center gap-1.5 mt-2.5">
            <Shield size={11} className="text-blue-400" />
            <span className="text-xs text-slate-400 font-medium">Admin Panel</span>
          </div>
        </div>

        <nav className="flex-1 p-3 space-y-0.5 overflow-y-auto">
          {NAV.map(item => (
            <Link
              key={item.to}
              to={item.to}
              className={`flex items-center gap-2.5 px-3 py-2.5 rounded-xl text-sm transition-colors ${isActive(item) ? 'bg-blue-700 text-white' : 'text-slate-300 hover:bg-slate-800 hover:text-white'}`}
            >
              <item.icon size={16} />
              {item.label}
            </Link>
          ))}
        </nav>

        <div className="p-3 border-t border-slate-700/60 space-y-0.5">
          <div className="text-xs text-slate-500 px-3 py-2 truncate">{profile?.full_name || profile?.email}</div>
          <Link to="/" className="flex items-center gap-2.5 px-3 py-2.5 text-sm text-slate-300 hover:bg-slate-800 rounded-xl transition-colors">
            <Home size={15} /> User View
          </Link>
          <button onClick={handleSignOut} className="flex items-center gap-2.5 w-full px-3 py-2.5 text-sm text-slate-300 hover:bg-slate-800 rounded-xl transition-colors">
            <LogOut size={15} /> Sign Out
          </button>
        </div>
      </aside>

      {/* Mobile / tablet top header */}
      <div className="lg:hidden fixed top-0 left-0 right-0 z-40 bg-slate-900 text-white h-14 flex items-center px-4">
        <button
          onClick={() => setSidebarOpen(true)}
          className="w-10 h-10 flex items-center justify-center text-slate-300 hover:text-white hover:bg-slate-800 rounded-xl transition-colors mr-3"
        >
          <Menu size={20} />
        </button>
        <div className="flex items-center gap-2 flex-1 min-w-0">
          <div className="w-6 h-6 bg-blue-600 rounded-md flex items-center justify-center shrink-0">
            <Scale size={12} className="text-white" />
          </div>
          <span className="font-semibold text-sm truncate">
            {currentPage?.label || 'Admin'}
          </span>
        </div>
        <Link to="/" className="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-white rounded-xl transition-colors">
          <Home size={18} />
        </Link>
      </div>

      {/* Mobile sidebar overlay */}
      {sidebarOpen && (
        <div className="lg:hidden fixed inset-0 z-50 flex">
          <div className="absolute inset-0 bg-black/60" onClick={() => setSidebarOpen(false)} />
          <div className="relative w-64 max-w-[80vw] bg-slate-900 h-full flex flex-col shadow-xl">
            <div className="p-5 border-b border-slate-700/60 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="w-7 h-7 bg-blue-600 rounded-lg flex items-center justify-center">
                  <Scale size={14} className="text-white" />
                </div>
                <span className="font-semibold text-sm text-white">Admin Panel</span>
              </div>
              <button
                onClick={() => setSidebarOpen(false)}
                className="w-9 h-9 flex items-center justify-center text-slate-400 hover:text-white hover:bg-slate-800 rounded-xl transition-colors"
              >
                <X size={18} />
              </button>
            </div>

            <nav className="flex-1 p-3 space-y-0.5 overflow-y-auto">
              {NAV.map(item => (
                <Link
                  key={item.to}
                  to={item.to}
                  onClick={() => setSidebarOpen(false)}
                  className={`flex items-center gap-3 px-4 py-3.5 rounded-xl text-sm transition-colors min-h-[52px] ${isActive(item) ? 'bg-blue-700 text-white' : 'text-slate-300 hover:bg-slate-800 hover:text-white active:bg-slate-700'}`}
                >
                  <item.icon size={18} />
                  {item.label}
                </Link>
              ))}
            </nav>

            <div className="p-3 border-t border-slate-700/60 space-y-1">
              <div className="text-xs text-slate-500 px-4 py-2 truncate">{profile?.full_name || profile?.email}</div>
              <Link
                to="/"
                onClick={() => setSidebarOpen(false)}
                className="flex items-center gap-3 px-4 py-3.5 text-sm text-slate-300 hover:bg-slate-800 rounded-xl transition-colors min-h-[52px]"
              >
                <Home size={18} /> Back to User View
              </Link>
              <button
                onClick={handleSignOut}
                className="flex items-center gap-3 w-full px-4 py-3.5 text-sm text-red-400 hover:bg-slate-800 rounded-xl transition-colors min-h-[52px]"
              >
                <LogOut size={18} /> Sign Out
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Main content */}
      <main className="flex-1 lg:ml-56 mt-14 lg:mt-0 min-h-screen">
        {children}
      </main>
    </div>
  );
}
