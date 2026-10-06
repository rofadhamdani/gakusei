# Gakusei – Academic Companion App

## Deskripsi Singkat

Gakusei adalah aplikasi **mobile & web** berbasis **Flutter** yang membantu mahasiswa mengelola materi kuliah, mengunggah file (PPT, PDF, foto, tautan), dan memanfaatkan **Google Gemini** untuk menghasilkan catatan belajar otomatis.

- **Alur materi:** materi asli → penjelasan AI per materi → rangkuman per minggu → rangkuman UTS/UAS.
- Semua output dapat di‑download dalam format **Markdown**, **PDF**, atau **TXT** sehingga dapat langsung dipakai di ChatGPT, Gemini, Claude, NotebookLM, atau AI lainnya.
- Menggunakan **stack gratis**: Flutter, Supabase Free, Gemini API Free Tier (model `gemini-3.8-flash`).

## Struktur Direktori Utama

```
Gakusei/
│   README.md
│   .env.example          # template env file (tidak di‑commit)
│
├─ lib/                     # kode Flutter
│   ├─ core/               # konfigurasi, router, tema, utilitas
│   ├─ features/           # feature‑first layout
│   │   ├─ auth/           # login, signup, splash, onboarding
│   │   ├─ home/           # dashboard utama
│   │   ├─ semesters/      # semester → courses
│   │   ├─ courses/        # mata kuliah
│   │   ├─ classes/        # kelas (kode undangan)
│   │   ├─ weeks/          # minggu → materi
│   │   ├─ materials/      # upload file / foto / tautan
│   │   ├─ study/          # AI Study Note (per materi & per minggu)
│   │   ├─ exam/           # UTS/UAS study guide generator
│   │   ├─ assignments/    # tugas & reminder
│   │   ├─ ai_chat/        # chat AI per materi
│   │   └─ notifications/  # local & push notifications
│   └─ shared/             # model, service, widget umum
│
├─ supabase/               # skrip migration & edge functions
│   ├─ migrations/         # SQL schema
│   └─ functions/          # ai_gateway (Gemini proxy)
│
└─ docs/                   # dokumentasi tambahan
```

## Persiapan Lingkungan

1. **Instalasi dasar** (satu kali)
   - Git, VS Code, Flutter SDK, Android Studio/SDK, Node .js, Python 3.12+, LibreOffice.
2. **Supabase**
   - Buat project di **Supabase Free** dan catat `SUPABASE_URL` serta `SUPABASE_ANON_KEY`.
   - Jalankan migrasi SQL yang terdapat di `supabase/migrations/001_init.sql`.
3. **Google Gemini API**
   - Buat project di **Google AI Studio**, dapatkan `GEMINI_API_KEY`.
   - Kunci ini harus disimpan pada environment backend (bukan di Flutter) karena akan dipanggil melalui Supabase Edge Function.
4. **File environment**
   - Salin `.env.example` menjadi `.env` di akar repository dan isi nilai Supabase.
5. **Instal dependensi Flutter**
   ```bash
   cd d:/Project\ Flutter/Gakusei/gakusei
   flutter pub get
   ```

## Menjalankan Aplikasi

```bash
# Jalankan di Chrome (web) atau emulator/device Android/iOS
flutter run -d chrome   # atau -d <device-id>
```

Jika ingin menjalankan dalam mode **debug** dengan hot‑reload, gunakan `flutter run` biasa.

## Fitur Utama (Roadmap)

| Tahap                                       | Fitur                                                                                                                             | Keterangan                                                             |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **1. Otentikasi & Navigasi Dasar**          | Splash, Onboarding, Login/Signup, Bottom Navigation, Dashboard placeholder                                                        | Memastikan pengguna dapat masuk, membuat kelas, melihat daftar minggu. |
| **2. Supabase Backend**                     | Skema tabel, Row‑Level Security, Storage untuk file, Realtime, Edge Function stub                                                 | Semua data tersimpan di Supabase, keamanan RLS.                        |
| **3. Upload & Manajemen Materi**            | Upload PPT/PDF, foto papan, tautan, catatan; preview di UI                                                                        | Materi dapat dilihat semua anggota kelas.                              |
| **4. AI Processing – Material Explanation** | Edge Function memanggil `gemini-3.8-flash` untuk menghasilkan Ringkasan, Penjelasan Detail, Konsep Penting, contoh, istilah, dll. | Hasil disimpan sebagai `study_notes` (JSON + Markdown).                |
| **5. AI Weekly Study Note**                 | Menggabungkan semua materi minggu, menghasilkan Quick Summary & Detailed Study Note.                                              |
| **6. Exam Guide Generator**                 | Pilih minggu yang ingin digabung → AI menghasilkan Study Guide UTS/UAS lengkap dengan pertanyaan latihan.                         |
| **7. Export & Download**                    | Tombol **Download** pada tiap catatan AI → generate Markdown → konversi ke PDF atau TXT (paket `pdf` + `printing`).               |
| **8. RAG & Q&A**                            | Embedding materi (`gemini‑embedding‑2`) → simpan di `pgvector` Supabase → pencarian vektor untuk pertanyaan kontekstual.          |
| **9. Notifikasi**                           | Local notification untuk deadline tugas, reminder AI selesai, push notification via FCM (opsional).                               |
| **10. UI/UX Polishing**                     | Figma prototyping, dark mode, aksesibilitas, error handling.                                                                      |
| **11. Testing & CI**                        | Unit & widget test, GitHub Actions untuk lint & test.                                                                             |
| **12. Deployment**                          | Build APK/IPA, web deploy ke Firebase Hosting (atau Supabase static).                                                             |

## Checklist Milestone (dapat disalin ke tools manajemen proyek)

**File:** `docs/feature_checklist.md`

### Milestone 1 – Auth & Core Navigation

- [ ] Buat `supabase_config.dart` & inisialisasi Supabase.
- [ ] Implementasi `SplashScreen` dengan cek sesi.
- [ ] Desain & implementasi `OnboardingScreen` (3 halaman).
- [ ] Buat `MainShell` dengan `BottomNavigationBar` (Home, Classes, +, Tasks, Learn).
- [ ] Implementasi `HomeScreen` placeholder (deadline, kursus, continue learning).
- [ ] Tambahkan halaman **Sign‑Up**, **Reset Password**.
- [ ] Hubungkan form login/signup ke Supabase Auth (error handling).
- [ ] Perbarui `AppRouter` dengan rute baru.
- [ ] Tambahkan unit/widget test untuk alur login.

### Milestone 2 – Supabase Schema & Edge Function

- [ ] Tulis migrasi SQL (`supabase/migrations/001_init.sql`) dengan tabel: `profiles`, `semesters`, `courses`, `classes`, `class_members`, `weeks`, `materials`, `material_chunks`, `study_notes`, `exam_scopes`, `assignments`, `assignment_user_status`, `ai_jobs`.
- [ ] Terapkan **Row‑Level Security** untuk tiap tabel.
- [ ] Deploy migrasi via Supabase CLI (`supabase db push`).
- [ ] Buat folder `supabase/functions/ai_gateway` dan stub function yang mengembalikan JSON contoh.
- [ ] Deploy Edge Function ke Supabase.

### Milestone 3 – Material Upload & Management

- [ ] UI list minggu (`WeekListScreen`).
- [ ] UI material upload (`MaterialUploadScreen`) dengan `file_picker` & `image_picker`.
- [ ] Simpan file ke **Supabase Storage**, buat record di tabel `materials`.
- [ ] Tambahkan preview (PDF viewer, image viewer) di detail material.

### Milestone 4 – AI Material Explanation

- [ ] Provider `AiMaterialProvider` yang memanggil Edge Function.
- [ ] Struktur output Gemini menggunakan **Structured JSON** (title, overview, concepts, contoh, dll.).
- [ ] Simpan hasil ke tabel `study_notes` (JSON + `content_markdown`).
- [ ] UI kartu “Ringkasan Cepat” & “Penjelasan Detil” pada halaman material.

### Milestone 5 – Weekly Study Note

- [ ] Service yang meng‑aggregate semua `study_notes` minggu.
- [ ] Prompt Gemini untuk **Quick Summary** + **Detailed Study Note**.
- [ ] Simpan ke tabel `study_notes` dengan `scope_type = 'week'`.
- [ ] UI tampilan weekly note dengan tombol download.

### Milestone 6 – Exam Guide Generator

- [ ] UI pilih minggu (checkbox list) → tombol “Buat Study Guide”.
- [ ] Prompt Gemini untuk meng‑gabungkan materi terpilih menjadi guide UTS/UAS.
- [ ] Simpan hasil (`scope_type = 'exam'`).
- [ ] UI tampilan guide + export options.

### Milestone 7 – Export / Download Engine

- [ ] Library markdown → PDF (paket `pdf` + `printing`).
- [ ] Konversi Markdown → TXT (plain text).
- [ ] Service `ExportService` dengan metode `exportAsMd`, `exportAsPdf`, `exportAsTxt`.
- [ ] Tambahkan tombol download pada semua catatan AI.

### Milestone 8 – RAG & Q&A

- [ ] Implementasi embedding melalui **Gemini Embedding 2** (dimensi 768).
- [ ] Simpan vektor di kolom `vector` tabel `material_chunks` (pgvector).
- [ ] Service `RagService` yang mencari chunk terdekat & meng‑generate jawaban via `gemini-3.8-flash`.
- [ ] UI chat AI per materi & per minggu.

### Milestone 9 – Notifikasi

- [ ] Setup `flutter_local_notifications` untuk reminder deadline & AI selesai.
- [ ] (Opsional) Integrasi **Firebase Cloud Messaging** untuk push notification.

### Milestone 10 – Testing, CI & Release

- [ ] Tambahkan unit test untuk semua provider & service.
- [ ] GitHub Actions: lint (`flutter analyze`), test (`flutter test`).
- [ ] Build release APK/IPA & Web deploy.
- [ ] Dokumentasi akhir (README, API docs).

## Commit & Branch Guidelines

Setiap perubahan sebaiknya dibuat dalam **satu commit terfokus** dengan format conventional commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Contoh tipe commit:

- `feat(auth): implement Supabase initialization`
- `feat(ui): add onboarding three‑page flow`
- `fix(router): correct initialLocation to /splash`
- `chore(deps): upgrade riverpod to ^2.4.0`
- `test(auth): add widget test for login flow`

### Alur kerja standar

```bash
# buat branch fitur baru
git checkout -b feat/<feature-name>

# stage perubahan (gunakan git add -p bila perlu)
git add .

# commit dengan pesan jelas
git commit -m "feat(<scope>): <description>"

# push ke remote (opsional) dan buat Pull Request
git push origin feat/<feature-name>
```

Gunakan **`git add -p`** untuk men‑stage perubahan secara selektif.

## Contributing

1. Fork repository.
2. Buat branch dengan pola `feat/<nama-fitur>` atau `fix/<nama-bug>`.
3. Ikuti guideline commit di atas.
4. Ajukan Pull Request ke `main` dengan deskripsi perubahan.
5. Pastikan semua test lulus (`flutter test`).

## Lisensi

Proyek ini dilisensikan di bawah **MIT License** – lihat file `LICENSE` untuk detail.

---

_Dokumentasi ini memberikan panduan umum untuk mengembangkan, menguji, dan merilis aplikasi Gakusei._
