# LAPORAN & DOKUMENTASI LOCAL STORAGE DI FLUTTER
**Mata Kuliah:** Mobile Programming — Pertemuan 4  
**Topik:** Implementasi SQFlite (SQLite Relasional) & Eksplorasi Alternatif Local Storage (Hive & SharedPreferences)

---

## DAFTAR ISI
1. [Dasar Penggunaan Package `sqflite`](#1-dasar-penggunaan-package-sqflite)
2. [Pembuatan Database & Skema Tabel SQFlite](#2-pembuatan-database--skema-tabel-sqflite)
3. [Penerapan Operasi CRUD pada SQFlite](#3-penerapan-operasi-crud-pada-sqflite)
4. [Eksplorasi Teknologi Local Storage Alternatif](#4-eksplorasi-teknologi-local-storage-alternatif)
5. [Tabel Perbandingan Komparatif (SQFlite vs Hive vs SharedPreferences)](#5-tabel-perbandingan-komparatif)
6. [Panduan Bagian yang Perlu Dimasukkan ke Dokumentasi / Laporan Akhir](#6-panduan-bagian-yang-perlu-dimasukkan-ke-dokumentasi--laporan-akhir)

---

## 1. DASAR PENGGUNAAN PACKAGE `sqflite`

### 1.1 Apa Itu SQFlite?
`sqflite` adalah plugin resmi untuk Flutter yang menyediakan akses ke basis data relasional **SQLite**. SQLite bekerja secara *serverless* dan *embedded* langsung di dalam memori/penyimpanan perangkat lokal.

### 1.2 Dependensi yang Dibutuhkan
Tambahkan pustaka berikut di file `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.3+1        # Mesin SQLite untuk mobile (Android & iOS)
  path: ^1.9.0             # Helper untuk manipulasi path direktori database
  sqflite_common_ffi: ^2.3.3 # Driver FFI untuk support desktop (Windows/Linux/macOS)
```

### 1.3 Alur Inisialisasi Database
1. Mengambil lokasi direktori penyimpanan basis data pada sistem menggunakan `getDatabasesPath()`.
2. Menggabungkan path dengan nama database (misal `task_database.db`) menggunakan `join()`.
3. Membuka koneksi database dengan `openDatabase()`.
4. Memicu callback `onCreate` untuk mengeksekusi perintah SQL DDL pertama kali saat file database belum dibuat.

---

## 2. PEMBUATAN DATABASE & SKEMA TABEL SQFLITE

### 2.1 Model Data (`lib/data/task_model.dart`)
Setiap data yang masuk ke database SQLite direpresentasikan ke dalam bentuk objek Dart:
```dart
class TaskModel {
  final int? id;
  final String title;
  final String description;
  final String createdAt;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  // Konversi Map (dari SQLite) ke Object Dart
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  // Konversi Object Dart ke Map untuk disimpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
    };
  }
}
```

### 2.2 Singleton Database Helper (`lib/services/database_helper.dart`)
Pola *Singleton* memastikan koneksi SQLite hanya diinisialisasi satu kali (*single instance*) di seluruh siklus hidup aplikasi.

```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'task_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Skema Tabel DDL SQLite
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }
}
```

---

## 3. PENERAPAN OPERASI CRUD PADA SQFLITE

Berikut adalah implementasi 4 operasi dasar CRUD pada `DatabaseHelper`:

### 3.1 Create (Insert Data)
Menambahkan baris record baru ke dalam tabel `tasks`.
```dart
Future<int> insertTask(TaskModel task) async {
  final db = await database;
  return await db.insert(
    'tasks',
    task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
```

### 3.2 Read (Query Data)
Mengambil seluruh record dari tabel `tasks`, diurutkan dari ID terbesar (data terbaru).
```dart
Future<List<TaskModel>> getTasks() async {
  final db = await database;
  final List<Map<String, dynamic>> results = await db.query(
    'tasks',
    orderBy: 'id DESC',
  );
  return results.map((map) => TaskModel.fromMap(map)).toList();
}
```

### 3.3 Update (Perbarui Data)
Memperbarui data berdasarkan parameter `id` menggunakan klausa `where` dan `whereArgs` (mencegah *SQL Injection*).
```dart
Future<int> updateTask(TaskModel task) async {
  final db = await database;
  return await db.update(
    'tasks',
    task.toMap(),
    where: 'id = ?',
    whereArgs: [task.id],
  );
}
```

### 3.4 Delete (Hapus Data)
Menghapus record spesifik berdasarkan `id`.
```dart
Future<int> deleteTask(int id) async {
  final db = await database;
  return await db.delete(
    'tasks',
    where: 'id = ?',
    whereArgs: [id],
  );
}
```

---

## 4. EKSPLORASI TEKNOLOGI LOCAL STORAGE ALTERNATIF

Pada proyek ini telah diimplementasikan **2 teknologi alternatif** selain SQFlite:

### 4.1 Alternatif 1: Hive (`hive_flutter`) — Diimplementasikan pada Contact App
- **Arsitektur:** NoSQL berbasis *Box* (dokumen/objek/key-value terstruktur).
- **Karakteristik:**
  - Ditulis murni dalam bahasa Dart (*pure Dart*).
  - Tidak memiliki dependensi native C/C++, sehingga performanya sangat cepat (*near-instant* in-memory access yang di-flush ke disk secara binary).
  - Mendukung tipe data kompleks, Map, List, hingga custom TypeAdapter.
- **Implementasi di Proyek:** Menyimpan objek kontak yang terdiri atas nama dan nomor telepon menggunakan `Box.add()`, `Box.values`, `Box.putAt()`, dan `Box.deleteAt()`.

### 4.2 Alternatif 2: SharedPreferences (`shared_preferences`) — Diimplementasikan pada Notes App
- **Arsitektur:** Penyimpanan pasangan Kunci-Nilai (*Key-Value Store*).
- **Karakteristik:**
  - Memanfaatkan API bawaan platform (`NSUserDefaults` di iOS, `SharedPreferences` di Android, XML/Registry di desktop).
  - Hanya mendukung tipe data primitif: `int`, `double`, `bool`, `String`, dan `List<String>`.
  - Sangat cocok untuk *user preferences*, token autentikasi, status tema (*dark/light mode*), atau data sederhana.
- **Implementasi di Proyek:** Menyimpan catatan teks ke dalam format `List<String>` melalui method `getStringList()` dan `setStringList()`.

---

## 5. TABEL PERBANDINGAN KOMPARATIF

Berikut adalah matriks komparasi hasil eksplorasi ketiga teknologi local storage yang ada di proyek:

| Parameter | SQFlite (`sqflite`) | Hive (`hive_flutter`) | SharedPreferences (`shared_preferences`) |
|---|---|---|---|
| **Model Data** | **Relasional (RDBMS)** | **NoSQL (Key-Value / Box Object)** | **Key-Value Store Sederhana** |
| **Bahasa / Format** | SQL (Structured Query Language) | Binary File (*Pure Dart*) | XML (Android) / Plist (iOS) |
| **Kebutuhan Skema** | **Ketat (Strict Schema)** dengan tipe kolom DDL | **Fleksibel (Schemaless / TypeAdapter)** | **Bebas Kunci-Nilai Primitif** |
| **Relasi & Query Kompleks** | **Sangat Baik** (Mendukung `JOIN`, `GROUP BY`, `FOREIGN KEY`, `INDEX`) | **Terbatas** (Filter dilakukan secara manual via fungsi Iterable di Dart) | **Tidak Mendukung** |
| **Kecepatan Baca / Tulis** | Sangat Baik (tergantung query & disk I/O) | **Paling Cepat** (Operasi baca langsung dari memori RAM) | Cepat (hanya untuk data kecil) |
| **Kelebihan Utama** | Mampu mengelola data terstruktur dengan integritas tinggi & relasi banyak tabel | Sangat cepat, mudah digunakan, tidak memerlukan sintaks SQL | Sangat ringan, tidak butuh konfigurasi skema, bawaan standar platform |
| **Kelemahan** | Memerlukan *boilerplate* kode SQL, migrasi skema tabel harus manual | Kurang efisien jika membutuhkan relasi banyak tabel yang kompleks | Tidak cocok untuk data berukuran besar atau data objek bersarang |
| **Kasus Penggunaan Ideal** | Aplikasi inventaris, absensi mahasiswa, e-commerce offline, sistem pencatatan dengan banyak entitas berelasi | Data caching aplikasi, kontak, chat offline, riwayat transaksi | Pengaturan aplikasi (tema, bahasa), status login (*session/token*), *onboarding flag* |

---

## 6. PANDUAN BAGIAN YANG PERLU DIMASUKKAN KE DOKUMENTASI / LAPORAN AKHIR

Untuk pelaporan praktikum atau laporan tugas kuliah, bagian-bagian berikut **wajib didokumentasikan**:

### 6.1 Tangkapan Layar (Screenshot) yang Harus Diambil
1. **Screenshot 1 — Halaman Menu Utama (`MainApp`):**
   - Menunjukkan 3 menu yang telah dibuat: **Notes App** (SharedPreferences), **Contact App** (Hive), dan **Task App** (SQFlite).
2. **Screenshot 2 — Halaman SQFlite (Form Tambah Data):**
   - Menampilkan input judul tugas dan deskripsi tugas beserta tombol "Tambah ke SQLite".
3. **Screenshot 3 — Halaman SQFlite (Daftar Tugas / Read):**
   - Menampilkan daftar data yang berhasil dibaca dari database SQLite lokal (terlihat ID, Judul, Deskripsi, dan Timestamp).
4. **Screenshot 4 — Dialog Update Data:**
   - Menampilkan popup dialog form edit data yang memicu operasi `UPDATE` pada SQLite.
5. **Screenshot 5 — Dialog Konfirmasi Hapus Data:**
   - Menampilkan dialog konfirmasi hapus data yang memicu operasi `DELETE` pada SQLite.
6. **Screenshot 6 — Halaman Alternatif (Contact App Hive & Notes App SharedPreferences):**
   - Memperlihatkan hasil perbandingan antarmuka antara NoSQL Box Hive dan SharedPreferences.

### 6.2 Potongan Kode Kunci (*Code Snippets*) yang Wajib Dikutip di Laporan
1. **Konfigurasi `pubspec.yaml`**: Bukti instalasi ketiga package.
2. **Method `_onCreate` di `DatabaseHelper`**: Bukti pembuatan skema tabel SQLite DDL.
3. **Method CRUD SQFlite**: Fungsi `insertTask()`, `getTasks()`, `updateTask()`, dan `deleteTask()`.
4. **Perbandingan Kode Create:**
   - *SQFlite:* `await db.insert('tasks', task.toMap());`
   - *Hive:* `await box.add({'name': ..., 'telephone': ...});`
   - *SharedPreferences:* `await prefs.setStringList('notes_key', notesList);`

### 6.3 Kesimpulan Tugas
- Proyek telah berhasil mengimplementasikan ketiga varian *local storage* di Flutter.
- Pemilihan teknologi *local storage* harus disesuaikan dengan kebutuhan arsitektur:
  - Gunakan **SharedPreferences** untuk data preferensi & sesi pengguna.
  - Gunakan **Hive** untuk performa tinggi, caching, dan penyimpanan NoSQL yang ringkas.
  - Gunakan **SQFlite** jika aplikasi membutuhkan konsistensi data relasional, query kompleks, atau migrasi data tingkat lanjut.
