import React from 'react';
import { BrowserRouter, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { MetaPixel } from './components/MetaPixel';
import { Layout } from './components/Layout';
import { AdminLayout } from './pages/admin/AdminLayout';

import Landing from './pages/Landing';
import Auth from './pages/Auth';
import Profile from './pages/Profile';
import Browse from './pages/Browse';
import Quiz from './pages/Quiz';
import Contact from './pages/Contact';
import Results from './pages/Results';
import Intake from './pages/Intake';
import Documents from './pages/Documents';
import Consent from './pages/Consent';
import Confirmation from './pages/Confirmation';
import Dashboard from './pages/Dashboard';
import CaseDetail from './pages/CaseDetail';

import AdminOverview from './pages/admin/Overview';
import AdminLeads from './pages/admin/Leads';
import AdminCases from './pages/admin/Cases';
import AdminQuestions from './pages/admin/Questions';
import AdminCaseForms from './pages/admin/CaseForms';
import AdminRules from './pages/admin/Rules';
import AdminAiImport from './pages/admin/AiImport';
import AdminCaseDetail from './pages/admin/CaseDetail';

function RequireAuth({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();
  const location = useLocation();
  if (loading) return <div className="min-h-screen flex items-center justify-center"><div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" /></div>;
  if (!user) return <Navigate to={`/auth?next=${encodeURIComponent(location.pathname.slice(1))}`} replace />;
  return <>{children}</>;
}

function RequireAdmin({ children }: { children: React.ReactNode }) {
  const { user, loading, isAdmin } = useAuth();
  if (loading) return <div className="min-h-screen flex items-center justify-center"><div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" /></div>;
  if (!user) return <Navigate to="/auth?next=admin" replace />;
  if (!isAdmin) return <Navigate to="/dashboard" replace />;
  return <>{children}</>;
}

function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<Layout><Landing /></Layout>} />
      <Route path="/auth" element={<Auth />} />

      <Route path="/browse" element={<Layout><Browse /></Layout>} />
      <Route path="/profile" element={<RequireAuth><Layout><Profile /></Layout></RequireAuth>} />
      <Route path="/quiz" element={<RequireAuth><Layout><Quiz /></Layout></RequireAuth>} />
      <Route path="/contact" element={<RequireAuth><Layout><Contact /></Layout></RequireAuth>} />
      <Route path="/results" element={<RequireAuth><Layout><Results /></Layout></RequireAuth>} />
      <Route path="/intake/:slug" element={<RequireAuth><Layout><Intake /></Layout></RequireAuth>} />
      <Route path="/documents/:slug" element={<RequireAuth><Layout><Documents /></Layout></RequireAuth>} />
      <Route path="/consent/:slug" element={<RequireAuth><Layout><Consent /></Layout></RequireAuth>} />
      <Route path="/confirmation/:slug" element={<RequireAuth><Layout><Confirmation /></Layout></RequireAuth>} />
      <Route path="/dashboard" element={<RequireAuth><Layout><Dashboard /></Layout></RequireAuth>} />
      <Route path="/cases/:slug" element={<RequireAuth><Layout><CaseDetail /></Layout></RequireAuth>} />

      <Route path="/admin" element={<RequireAdmin><AdminLayout><AdminOverview /></AdminLayout></RequireAdmin>} />
      <Route path="/admin/leads" element={<RequireAdmin><AdminLayout><AdminLeads /></AdminLayout></RequireAdmin>} />
      <Route path="/admin/cases" element={<RequireAdmin><AdminLayout><AdminCases /></AdminLayout></RequireAdmin>} />
      <Route path="/admin/questions" element={<RequireAdmin><AdminLayout><AdminQuestions /></AdminLayout></RequireAdmin>} />
      <Route path="/admin/case-forms" element={<RequireAdmin><AdminLayout><AdminCaseForms /></AdminLayout></RequireAdmin>} />
      <Route path="/admin/rules" element={<RequireAdmin><AdminLayout><AdminRules /></AdminLayout></RequireAdmin>} />
      <Route path="/admin/ai-import" element={<RequireAdmin><AdminLayout><AdminAiImport /></AdminLayout></RequireAdmin>} />
      <Route path="/admin/cases/:id" element={<RequireAdmin><AdminLayout><AdminCaseDetail /></AdminLayout></RequireAdmin>} />

      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <MetaPixel />
        <AppRoutes />
      </AuthProvider>
    </BrowserRouter>
  );
}
