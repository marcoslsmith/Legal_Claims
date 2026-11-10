begin;

create table if not exists public.casehelpers_staff (
  user_id uuid primary key references auth.users(id) on delete cascade
);

alter table public.casehelpers_staff enable row level security;
revoke all on public.casehelpers_staff from public, anon, authenticated;

create or replace function public.casehelpers_is_staff()
returns boolean
language sql stable security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.casehelpers_staff
    where user_id = (select auth.uid())
  )
$$;

revoke all on function public.casehelpers_is_staff() from public, anon;
grant execute on function public.casehelpers_is_staff() to authenticated;

alter table public.casehelpers_callback_queue enable row level security;
revoke all on public.casehelpers_callback_queue
  from public, anon, authenticated;

-- Replace legacy policies so they cannot grant additional access.
do $$
declare p record;
begin
  for p in
    select policyname from pg_policies
    where schemaname = 'public'
      and tablename = 'casehelpers_callback_queue'
  loop
    execute format(
      'drop policy %I on public.casehelpers_callback_queue',
      p.policyname
    );
  end loop;
end $$;

grant select, update(callback_status)
  on public.casehelpers_callback_queue to authenticated;

create policy casehelpers_staff_read
  on public.casehelpers_callback_queue
  for select to authenticated
  using ((select public.casehelpers_is_staff()));

create policy casehelpers_staff_update
  on public.casehelpers_callback_queue
  for update to authenticated
  using ((select public.casehelpers_is_staff()))
  with check ((select public.casehelpers_is_staff()));

create index if not exists casehelpers_queue_received
  on public.casehelpers_callback_queue(received_at desc, request_id desc);

create table if not exists public.casehelpers_callback_notes (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null
    references public.casehelpers_callback_queue(request_id)
    on delete cascade,
  author_id uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  body text not null
    check (length(btrim(body)) between 1 and 2000)
);

alter table public.casehelpers_callback_notes enable row level security;
revoke all on public.casehelpers_callback_notes
  from public, anon, authenticated;

do $$
declare p record;
begin
  for p in
    select policyname from pg_policies
    where schemaname = 'public'
      and tablename = 'casehelpers_callback_notes'
  loop
    execute format(
      'drop policy %I on public.casehelpers_callback_notes',
      p.policyname
    );
  end loop;
end $$;

grant select, insert(request_id, body)
  on public.casehelpers_callback_notes to authenticated;

create policy casehelpers_notes_read
  on public.casehelpers_callback_notes
  for select to authenticated
  using ((select public.casehelpers_is_staff()));

create policy casehelpers_notes_add
  on public.casehelpers_callback_notes
  for insert to authenticated
  with check (
    (select public.casehelpers_is_staff())
    and author_id = (select auth.uid())
  );

create index if not exists casehelpers_notes_lead
  on public.casehelpers_callback_notes(request_id, created_at desc);

commit;
