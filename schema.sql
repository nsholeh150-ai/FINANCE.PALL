create extension if not exists pgcrypto;

create or replace function public.budget_request_header(header_name text)
returns text
language plpgsql
stable
set search_path = ''
as $$
declare
  headers json;
begin
  begin
    headers := current_setting('request.headers', true)::json;
  exception
    when others then
      return null;
  end;

  return headers ->> lower(header_name);
end;
$$;

create table if not exists public.finance_budget_plans (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  plan_name text not null check (char_length(plan_name) between 1 and 120),
  save_code text not null check (char_length(save_code) between 6 and 80),
  app_version text not null default 'student-finance-dashboard',
  data jsonb not null,
  computed jsonb not null default '{}'::jsonb
);

create index if not exists finance_budget_plans_save_code_updated_idx
  on public.finance_budget_plans (save_code, updated_at desc);

create or replace function public.set_finance_budget_plans_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_finance_budget_plans_updated_at on public.finance_budget_plans;
create trigger set_finance_budget_plans_updated_at
before update on public.finance_budget_plans
for each row
execute function public.set_finance_budget_plans_updated_at();

alter table public.finance_budget_plans enable row level security;

drop policy if exists "budget plans can be inserted with matching save code"
  on public.finance_budget_plans;
create policy "budget plans can be inserted with matching save code"
on public.finance_budget_plans
for insert
to anon
with check (
  save_code = public.budget_request_header('x-budget-save-code')
  and char_length(save_code) between 6 and 80
);

drop policy if exists "budget plans can be read with matching save code"
  on public.finance_budget_plans;
create policy "budget plans can be read with matching save code"
on public.finance_budget_plans
for select
to anon
using (
  save_code = public.budget_request_header('x-budget-save-code')
);

drop policy if exists "budget plans can be updated with matching save code"
  on public.finance_budget_plans;
create policy "budget plans can be updated with matching save code"
on public.finance_budget_plans
for update
to anon
using (
  save_code = public.budget_request_header('x-budget-save-code')
)
with check (
  save_code = public.budget_request_header('x-budget-save-code')
);

grant usage on schema public to anon;
grant select, insert, update on public.finance_budget_plans to anon;
grant execute on function public.budget_request_header(text) to anon;
