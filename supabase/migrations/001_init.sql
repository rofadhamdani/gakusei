-- ============================================================
-- Gakusei – Initial Database Schema
-- ============================================================

-- 1. Enable pgvector extension
create extension if not exists "vector";

-- 2. Custom enums
create type material_type as enum ('pdf', 'image', 'markdown', 'link');
create type week_status   as enum ('draft', 'published');

-- 3. Profiles (linked to Supabase Auth users)
--    id must match auth.users.id — inserted via trigger on sign-up
create table if not exists profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  full_name  text,
  avatar_url text,
  created_at timestamptz default now()
);

-- 4. Courses (mata kuliah)
create table if not exists courses (
  id          uuid primary key default gen_random_uuid(),
  owner_id    uuid not null references profiles(id) on delete cascade,
  name        text not null,
  description text,
  created_at  timestamptz default now()
);

-- 5. Classes (kelas per semester)
create table if not exists classes (
  id         uuid primary key default gen_random_uuid(),
  course_id  uuid not null references courses(id) on delete cascade,
  semester   text not null,
  year       int  not null,
  created_at timestamptz default now()
);

-- 6. Weeks
create table if not exists weeks (
  id          uuid primary key default gen_random_uuid(),
  class_id    uuid not null references classes(id) on delete cascade,
  week_number int  not null,
  title       text,
  status      week_status default 'draft',
  created_at  timestamptz default now()
);

-- 7. Materials (file materi yang diupload)
create table if not exists materials (
  id           uuid primary key default gen_random_uuid(),
  week_id      uuid not null references weeks(id) on delete cascade,
  type         material_type not null,
  title        text not null,
  storage_path text not null,
  metadata     jsonb,
  created_at   timestamptz default now()
);

-- 8. Material Explanations — Level A (penjelasan per materi)
create table if not exists material_explanations (
  id           uuid primary key default gen_random_uuid(),
  material_id  uuid not null references materials(id) on delete cascade,
  content_md   text not null,
  content_html text,
  embedding    vector(768),
  created_at   timestamptz default now()
);

-- 9. Weekly Notes — Level B (catatan mingguan gabungan)
create table if not exists weekly_notes (
  id          uuid primary key default gen_random_uuid(),
  week_id     uuid not null references weeks(id) on delete cascade,
  overview_md text,
  detailed_md text,
  embedding   vector(768),
  created_at  timestamptz default now()
);

-- 10. Exam Guides — Level C (panduan UTS/UAS)
create table if not exists exam_guides (
  id             uuid primary key default gen_random_uuid(),
  class_id       uuid not null references classes(id) on delete cascade,
  title          text not null,
  weeks_selected int[],
  content_md     text not null,
  embedding      vector(768),
  created_at     timestamptz default now()
);

-- 11. Generated Files (hasil export PDF/TXT/MD)
create table if not exists generated_files (
  id         uuid primary key default gen_random_uuid(),
  owner_id   uuid not null references profiles(id) on delete cascade,
  file_path  text not null,
  mime_type  text not null,
  created_at timestamptz default now()
);

-- 12. Auto-create profile on user sign-up
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    coalesce(new.raw_user_meta_data ->> 'avatar_url', '')
  );
  return new;
end;
$$;

-- Drop existing trigger if any, then create
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
