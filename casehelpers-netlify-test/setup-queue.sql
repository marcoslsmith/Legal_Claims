begin;

create table public.casehelpers_callback_queue (
  request_id uuid primary key,
  received_at timestamptz not null default now(),
  callback_status text not null default 'pending_callback'
    check (callback_status in ('pending_callback', 'attempted', 'completed')),
  name text not null,
  phone text not null,
  screening_status text not null,
  intake jsonb not null
);

alter table public.casehelpers_callback_queue enable row level security;
revoke all on public.casehelpers_callback_queue from public, anon, authenticated, service_role;
grant insert on public.casehelpers_callback_queue to service_role;
grant select (request_id) on public.casehelpers_callback_queue to service_role;

commit;
