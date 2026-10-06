-- ============================================================
-- Gakusei – Row Level Security Policies
-- ============================================================
-- Setiap user hanya bisa mengakses data miliknya sendiri.
-- Ownership chain: profiles → courses → classes → weeks → materials → explanations/notes

-- ---- profiles ----
alter table profiles enable row level security;

create policy "Users can view own profile"
  on profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on profiles for update
  using (auth.uid() = id);

-- Insert handled by trigger; no direct insert policy needed.

-- ---- courses ----
alter table courses enable row level security;

create policy "Owner can do everything on courses"
  on courses for all
  using (owner_id = auth.uid());

-- ---- classes ----
alter table classes enable row level security;

create policy "Course owner can manage classes"
  on classes for all
  using (
    exists (
      select 1 from courses
      where courses.id = classes.course_id
        and courses.owner_id = auth.uid()
    )
  );

-- ---- weeks ----
alter table weeks enable row level security;

create policy "Course owner can manage weeks"
  on weeks for all
  using (
    exists (
      select 1 from classes
      join courses on courses.id = classes.course_id
      where classes.id = weeks.class_id
        and courses.owner_id = auth.uid()
    )
  );

-- ---- materials ----
alter table materials enable row level security;

create policy "Course owner can manage materials"
  on materials for all
  using (
    exists (
      select 1 from weeks
      join classes on classes.id = weeks.class_id
      join courses on courses.id = classes.course_id
      where weeks.id = materials.week_id
        and courses.owner_id = auth.uid()
    )
  );

-- ---- material_explanations ----
alter table material_explanations enable row level security;

create policy "Course owner can manage explanations"
  on material_explanations for all
  using (
    exists (
      select 1 from materials
      join weeks   on weeks.id   = materials.week_id
      join classes on classes.id = weeks.class_id
      join courses on courses.id = classes.course_id
      where materials.id = material_explanations.material_id
        and courses.owner_id = auth.uid()
    )
  );

-- ---- weekly_notes ----
alter table weekly_notes enable row level security;

create policy "Course owner can manage weekly notes"
  on weekly_notes for all
  using (
    exists (
      select 1 from weeks
      join classes on classes.id = weeks.class_id
      join courses on courses.id = classes.course_id
      where weeks.id = weekly_notes.week_id
        and courses.owner_id = auth.uid()
    )
  );

-- ---- exam_guides ----
alter table exam_guides enable row level security;

create policy "Course owner can manage exam guides"
  on exam_guides for all
  using (
    exists (
      select 1 from classes
      join courses on courses.id = classes.course_id
      where classes.id = exam_guides.class_id
        and courses.owner_id = auth.uid()
    )
  );

-- ---- generated_files ----
alter table generated_files enable row level security;

create policy "Owner can manage own generated files"
  on generated_files for all
  using (owner_id = auth.uid());
