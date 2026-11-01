import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_10/data/task_model.dart';

class DatabaseHelper {
  // Singleton pattern agar koneksi database hanya ada satu instance di seluruh lifecycle app
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Getter database: jika sudah diinisialisasi return instance, jika belum maka init database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Fungsi inisialisasi dan pembuatan database SQLite
  Future<Database> _initDatabase() async {
    // Mendapatkan direktori path database bawaan sistem operasi
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'task_database.db');

    // Membuka database sekaligus membuat skema tabel jika database baru dibuat (onCreate)
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Skema tabel menggunakan SQL DDL
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

  // ==================== OPERASI CRUD (SQFlite) ====================

  // 1. CREATE: Menambahkan data task baru ke tabel 'tasks'
  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 2. READ: Mengambil seluruh data task dari tabel 'tasks'
  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    // Mengurutkan dari data terbaru berdasarkan ID descending
    final List<Map<String, dynamic>> results = await db.query(
      'tasks',
      orderBy: 'id DESC',
    );

    return results.map((map) => TaskModel.fromMap(map)).toList();
  }

  // 3. UPDATE: Memperbarui data task berdasarkan ID
  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // 4. DELETE: Menghapus data task berdasarkan ID
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Menutup database saat aplikasi dihentikan (opsional)
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}

