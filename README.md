# Gakusei - AI‑Powered Study Companion

## 📚 Deskripsi Aplikasi
Gakusei adalah aplikasi **Flutter** multi‑platform (Android, iOS, Web) yang membantu mahasiswa belajar secara terstruktur dengan bantuan **Gemini** (model AI).  Konten belajar diproses dalam tiga level:

1. **Level A – Per Materi**  
   Setiap file materi (PDF, foto, catatan) menghasilkan:
   - Ringkasan
   - Penjelasan detail
   - Konsep penting, contoh, istilah, rumus, dll.
2. **Level B – Per Minggu**  
   Semua materi minggu digabung menjadi *Weekly Study Note* yang berisi overview, tujuan, pembahasan mendetail, contoh, dan pertanyaan latihan.
3. **Level C – UTS/UAS**  
   Pengguna dapat memilih minggu‑minggu tertentu lalu AI menyusun *Study Guide* untuk ujian tengah/akhir semester.

Semua output tersedia untuk **download** dalam format **Markdown**, **PDF**, dan **Plain Text** sehingga dapat dipakai di ChatGPT, Gemini, Claude, NotebookLM, atau AI lainnya.

---

## 🏗️ Teknologi Stack
| Komponen | Teknologi |
|---|---|
| Mobile/Web | **Flutter + Dart** |
| State Management | **Riverpod** |
| Navigation | **GoRouter** |
| Backend | **Supabase (Free tier)** |
| Database | **PostgreSQL** |
| Auth | **Supabase Auth** |
| Storage | **Supabase Storage** |
| Realtime | **Supabase Realtime** |
| Security | **Row‑Level Security (RLS)** |
| AI utama | **Gemini 3.8 Flash** |
| AI ringan | **Gemini 3.5 Flash‑Lite** |
| Embedding / RAG | **Gemini Embedding 2** |
| Vector DB | **pgvector (Supabase)** |
| Document worker | **Python + FastAPI** |
| PDF conversion | **LibreOffice Headless** |
| Notifikasi lokal | **Flutter Local Notifications** |
| Push notif (future) | **Firebase Cloud Messaging** |
| IDE | **VS Code** |
| Version control | **Git + GitHub** |

---

## 📂 Struktur Repository
```
├─ lib/                     # kode Flutter
│   ├─ src/                # fitur utama (ui, models, services)
│   └─ main.dart           # entry point
├─ supabase/                # folder Supabase CLI
│   ├─ migrations/         # file .sql migrasi
│   └─ supabase/config.toml
├─ backend/                 # FastAPI worker (Python)
│   └─ ...
├─ .env                     # SUPABASE_URL & SUPABASE_ANON_KEY (git‑ignored)
├─ pubspec.yaml
└─ README.md                # (ini!)
```

---

## ⚙️ Persiapan Lingkungan
1. **Installasi tools** (Windows PowerShell)
   ```powershell
   # Flutter SDK
   winget install -e --id Google.Flutter

   # Supabase CLI (global npm)
   npm install -g supabase

   # Python + FastAPI (optional worker)
   python -m venv venv
   .\venv\Scripts\activate
   pip install fastapi uvicorn python‑dotenv
   ```
2. **Clone repository**
   ```bash
   git clone https://github.com/your‑org/gakusei.git
   cd gakusei
   ```
3. **Pasang dependensi Flutter**
   ```bash
   flutter pub get
   ```
4. **Buat file `.env`** dari `.env.example` dan gunakan nilai dari Supabase project Anda
   ```text
   SUPABASE_URL=YOUR_SUPABASE_URL
   SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
   ```
   > `.env` dimasukkan ke asset aplikasi Flutter dan dapat dibaca pengguna aplikasi, terutama di Web. Isinya hanya boleh berupa URL dan publishable key Supabase; jangan masukkan `service_role` key atau rahasia lain.
5. **Inisialisasi Supabase (hanya sekali)**
   ```powershell
   supabase init   # membuat folder supabase/ dan config.toml
   ```

---

## ▶️ Menjalankan Aplikasi
```bash
flutter run   # pilih target Android, iOS, atau web
```
Jika Anda ingin menjalankan worker Python untuk pemrosesan dokumen:
```bash
cd backend
uvicorn main:app --reload
```

---

## ✨ Fitur Utama
- **Upload materi** (PDF, gambar, markdown) → otomatis diproses AI.
- **Level‑A output** – detail per materi.
- **Level‑B output** – catatan mingguan terintegrasi.
- **Level‑C output** – panduan ujian yang dapat dipilih minggu‑nya.
- **Download** dalam Markdown / PDF / TXT (tanpa biaya AI tambahan).
- **Realtime** sync antar siswa & guru via Supabase Realtime.
- **Auth** berbasis Supabase – tiap pengguna hanya melihat data miliknya (RLS).
- **Embedding & RAG** menggunakan `pgvector` untuk pencarian konteks.

---

## 📋 Checklist Milestone (dengan penjelasan)
> Lihat file `CHECKLIST.md` untuk detail lengkap.

---

## 📥 Panduan Commit & Branching
| Tipe | Prefix | Contoh pesan |
|------|--------|--------------|
| Fitur baru | `feat:` | `feat(db): add initial schema and RLS policies` |
| Perbaikan bug | `fix:` | `fix(auth): correct auth UID handling` |
| Dokumentasi | `docs:` | `docs(readme): update deployment guide` |
| Refactor | `refactor:` | `refactor(state): migrate to Riverpod 2.0` |

**Strategi branch**
1. `main` – kode produksi yang selalu dapat dideploy.
2. `dev` – integrasi semua fitur sebelum rilis.
3. Feature branch `feat/<nama-fitur>` → PR ke `dev`.
4. Setelah `dev` stabil, merge ke `main` dengan release tag.

---

## 🚀 Langkah Selanjutnya (Ringkas)
1. Buat file migrasi **001_init.sql** (struktur tabel, enum, pgvector).
2. Buat file migrasi **002_rls_policies.sql** (RLS untuk semua tabel).
3. Aktifkan ekstensi `pgvector` di Supabase (UI → Database → Extensions **pgvector**).
4. Jalankan `supabase db push` dua kali untuk menerapkan schema dan kebijakan.
5. Verifikasi tabel & RLS di Supabase Dashboard.
6. Jalankan aplikasi Flutter untuk memastikan koneksi berhasil.
7. Commit perubahan dengan pesan **`feat(db): add schema & RLS migrations`**.

---

## 📜 Lisensi
MIT License – bebas digunakan, dimodifikasi, dan didistribusikan.
