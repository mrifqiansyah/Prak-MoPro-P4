# Praktikum Mobile Programming - Pertemuan 4 (Local Storage)
**Universitas Pakuan - Laboratorium Ilmu Komputer**

Repository tugas praktikum mobile programming pertemuan ke-4 mengenai eksplorasi dan perbandingan teknologi **Local Storage** pada Flutter:
1. **SQFlite (SQLite Relational Database)** — Modul *Task App* (CRUD lengkap dengan Primary Key, Skema DDL, dan Async Database Helper).
2. **Hive (NoSQL Box Storage)** — Modul *Contact App* (Penyimpanan box objek/map reaktif super cepat).
3. **SharedPreferences (Key-Value Storage)** — Modul *Notes App* (Penyimpanan list catatan teks persisten).

---

## 📖 Dokumentasi Lengkap
Seluruh dokumentasi, analisis komparatif, arsitektur skema tabel, dan hasil uji coba dapat dilihat pada file:
👉 [**DOKUMENTASI_LOCAL_STORAGE.md**](DOKUMENTASI_LOCAL_STORAGE.md)

---

## 🚀 Cara Menjalankan Proyek
1. Clone repositori:
   ```bash
   git clone <repo-url>
   cd p4.mobpro
   ```
2. Pasang dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi:
   - **Di Desktop Windows:**
     ```powershell
     flutter run -d windows
     ```
   - **Di Emulator / Perangkat Android:**
     ```bash
     flutter run
     ```
   - **Di Browser Brave / Web:**
     ```powershell
     $env:CHROME_EXECUTABLE = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
     flutter run -d chrome
     ```
