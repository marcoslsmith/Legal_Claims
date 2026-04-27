const statusConfig: Record<string, { label: string; classes: string }> = {
  not_started: { label: 'Not Started', classes: 'bg-slate-100 text-slate-600' },
  in_progress: { label: 'In Progress', classes: 'bg-blue-50 text-blue-700' },
  submitted: { label: 'Submitted', classes: 'bg-teal-50 text-teal-700' },
  under_review: { label: 'Under Review', classes: 'bg-amber-50 text-amber-700' },
  routed: { label: 'Routed', classes: 'bg-cyan-50 text-cyan-700' },
  accepted: { label: 'Accepted', classes: 'bg-emerald-50 text-emerald-700' },
  rejected: { label: 'Rejected', classes: 'bg-red-50 text-red-700' },
  duplicate: { label: 'Duplicate', classes: 'bg-slate-100 text-slate-500' },
  bad_contact: { label: 'Bad Contact', classes: 'bg-orange-50 text-orange-700' },
  closed: { label: 'Closed', classes: 'bg-slate-100 text-slate-500' },
  // Admin lead statuses
  new: { label: 'New', classes: 'bg-blue-50 text-blue-700' },
  needs_review: { label: 'Needs Review', classes: 'bg-amber-50 text-amber-700' },
  qualified: { label: 'Qualified', classes: 'bg-emerald-50 text-emerald-700' },
};

export function StatusBadge({ status }: { status: string }) {
  const c = statusConfig[status] || { label: status, classes: 'bg-slate-100 text-slate-600' };
  return (
    <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium ${c.classes}`}>
      {c.label}
    </span>
  );
}
