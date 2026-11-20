begin;

create table if not exists public.casehelpers_arrivals (
  arrival_id uuid primary key default gen_random_uuid(),
  arrived_at timestamptz not null default now(),
  attribution jsonb not null default '{}'::jsonb,
  has_click_id boolean not null default false
);

alter table public.casehelpers_arrivals enable row level security;
revoke all on public.casehelpers_arrivals from public, anon, authenticated, service_role;
grant insert on public.casehelpers_arrivals to service_role;
grant select on public.casehelpers_arrivals to service_role;

comment on table public.casehelpers_arrivals is 'First-party landing-page arrival counts: timestamp, UTM tags and click-ID presence only. No IP, user agent, quiz answers or contact data.';

commit;
