create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;

create or replace function public.is_portfolio_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.admin_users
    where user_id = (select auth.uid())
  );
$$;

revoke all on function public.is_portfolio_admin() from public;
grant execute on function public.is_portfolio_admin() to anon, authenticated;

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  title_ar text not null default '',
  title_en text not null,
  summary_ar text not null default '',
  summary_en text not null,
  description_ar text not null default '',
  description_en text not null,
  category text not null default 'Other',
  technologies text[] not null default '{}',
  client text not null default '',
  year text not null default '',
  featured boolean not null default false,
  published boolean not null default false,
  display_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.project_media (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  media_type text not null
    check (media_type in ('image', 'video', 'external_video')),
  url text not null,
  thumbnail_url text,
  storage_path text,
  caption_ar text not null default '',
  caption_en text not null default '',
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.project_links (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  label text not null,
  url text not null,
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists projects_public_order_idx
  on public.projects (published, featured desc, display_order);
create index if not exists project_media_project_order_idx
  on public.project_media (project_id, display_order);
create index if not exists project_links_project_order_idx
  on public.project_links (project_id, display_order);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists projects_set_updated_at on public.projects;
create trigger projects_set_updated_at
before update on public.projects
for each row execute function public.set_updated_at();

alter table public.projects enable row level security;
alter table public.project_media enable row level security;
alter table public.project_links enable row level security;

drop policy if exists "Published projects are public" on public.projects;
create policy "Published projects are public"
on public.projects for select
to anon, authenticated
using (published or public.is_portfolio_admin());

drop policy if exists "Admins manage projects" on public.projects;
create policy "Admins manage projects"
on public.projects for all
to authenticated
using (public.is_portfolio_admin())
with check (public.is_portfolio_admin());

drop policy if exists "Published project media is public" on public.project_media;
create policy "Published project media is public"
on public.project_media for select
to anon, authenticated
using (
  public.is_portfolio_admin()
  or exists (
    select 1 from public.projects
    where projects.id = project_media.project_id
      and projects.published
  )
);

drop policy if exists "Admins manage project media" on public.project_media;
create policy "Admins manage project media"
on public.project_media for all
to authenticated
using (public.is_portfolio_admin())
with check (public.is_portfolio_admin());

drop policy if exists "Published project links are public" on public.project_links;
create policy "Published project links are public"
on public.project_links for select
to anon, authenticated
using (
  public.is_portfolio_admin()
  or exists (
    select 1 from public.projects
    where projects.id = project_links.project_id
      and projects.published
  )
);

drop policy if exists "Admins manage project links" on public.project_links;
create policy "Admins manage project links"
on public.project_links for all
to authenticated
using (public.is_portfolio_admin())
with check (public.is_portfolio_admin());

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'portfolio-media',
  'portfolio-media',
  true,
  524288000,
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
    'image/avif',
    'video/mp4',
    'video/webm',
    'video/quicktime',
    'video/x-m4v'
  ]
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Admins upload portfolio media" on storage.objects;
create policy "Admins upload portfolio media"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'portfolio-media'
  and public.is_portfolio_admin()
);

drop policy if exists "Admins update portfolio media" on storage.objects;
create policy "Admins update portfolio media"
on storage.objects for update
to authenticated
using (
  bucket_id = 'portfolio-media'
  and public.is_portfolio_admin()
)
with check (
  bucket_id = 'portfolio-media'
  and public.is_portfolio_admin()
);

drop policy if exists "Admins delete portfolio media" on storage.objects;
create policy "Admins delete portfolio media"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'portfolio-media'
  and public.is_portfolio_admin()
);

grant usage on schema public to anon, authenticated;
grant select on public.projects, public.project_media, public.project_links
  to anon, authenticated;
grant insert, update, delete on
  public.projects, public.project_media, public.project_links
  to authenticated;

-- After creating your account in Authentication > Users, run this once:
-- insert into public.admin_users (user_id)
-- select id from auth.users where email = 'YOUR_EMAIL';
