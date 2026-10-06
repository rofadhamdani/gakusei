# Project Gakusei – Development Checklist

## ✅ Milestone 1: Infrastruktur & Database (Current)
- [ ] **Initialize Supabase project** – `supabase init` (already done).
- [ ] **Add .env variables** – `SUPABASE_URL` & `SUPABASE_ANON_KEY` (already added).
- [ ] **Create initial schema migration** – `supabase/migrations/001_init.sql` (created).
- [ ] **Enable pgvector extension** – either via Supabase UI → Database → Extensions → *pgvector* **or** run `supabase db remote enable-extension pgvector`.
- [ ] **Push schema to remote** – `supabase db push` (apply 001 migration).
- [ ] **Create RLS policies migration** – `supabase/migrations/002_rls_policies.sql` (to be created).
- [ ] **Push RLS policies** – `supabase db push` (apply 002 migration).
- [ ] **Verify tables & policies** in Supabase Dashboard.
- [ ] **Test connection from Flutter** – run `flutter run` and ensure no auth/database errors.
- [ ] **Commit changes** – `git add . && git commit -m "feat(db): add schema & RLS migrations"`.

## 🚧 Milestone 2: Backend Document Worker (Python + FastAPI)
- [ ] Scaffold FastAPI project in `backend/`.
- [ ] Implement endpoints for:
  - Uploading raw material files to Supabase Storage.
  - Triggering AI processing (Gemini) via background tasks.
  - Storing generated explanations, weekly notes, exam guides.
- [ ] Containerise with Docker (optional).

## 🎨 Milestone 3: Flutter Front‑end Features
- [ ] Set up Riverpod providers for Supabase client, auth, and data streams.
- [ ] UI screens:
  - Auth (sign‑in / sign‑up).
  - Course & class selection.
  - Week view with material list & upload.
  - Level‑A explanation view (markdown renderer).
  - Level‑B weekly note view.
  - Level‑C exam guide selector & viewer.
- [ ] Implement download buttons (MD, PDF, TXT) using stored `content_md`.
- [ ] Local notifications for upcoming deadlines.

## 📦 Milestone 4: AI Integration & RAG
- [ ] Configure Gemini API client (free‑tier key stored securely, **not** in Flutter code).
- [ ] Build prompt templates for each level (A, B, C).
- [ ] Store embeddings in `material_explanations.embedding`, `weekly_notes.embedding`, `exam_guides.embedding`.
- [ ] Implement similarity search using `pgvector` for contextual Q&A.

## 🛠️ Milestone 5: Deployment & CI/CD
- [ ] Set up GitHub Actions to run lint, tests, and `supabase db push` on merge to `main`.
- [ ] Deploy FastAPI worker to Google Cloud Run / Fly.io.
- [ ] Publish Flutter web build to GitHub Pages or Firebase Hosting.
- [ ] Configure Firebase Cloud Messaging for push notifications (future).

## 📄 Documentation & Release
- [ ] Keep README up‑to‑date (already done).
- [ ] Write API docs for backend (`backend/README.md`).
- [ ] Tag releases with semantic versioning.

---

**Catatan:** Checklist ini dapat di‑update setiap kali ada perubahan scope atau keputusan desain. Pastikan setiap item selesai sebelum melanjutkan ke milestone berikutnya.

