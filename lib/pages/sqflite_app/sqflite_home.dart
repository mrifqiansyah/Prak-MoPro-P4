import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/data/task_model.dart';
import 'package:flutter_application_10/services/database_helper.dart';

class SqfliteHome extends StatefulWidget {
  const SqfliteHome({super.key});

  @override
  State<SqfliteHome> createState() => _SqfliteHomeState();
}

class _SqfliteHomeState extends State<SqfliteHome> {
  final _inputTitleKey = GlobalKey<FormFieldState>();
  final _inputDescKey = GlobalKey<FormFieldState>();

  final _updateTitleKey = GlobalKey<FormFieldState>();
  final _updateDescKey = GlobalKey<FormFieldState>();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadTasks();
    } else {
      _isLoading = false;
    }
  }

  // Fungsi READ: Memuat seluruh data tugas dari database SQLite
  Future<void> _loadTasks() async {
    if (kIsWeb) return;
    try {
      final tasks = await _dbHelper.getTasks();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Format tanggal sederhana untuk penanda waktu pembuatan tugas
  String _getCurrentFormattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        title: const Text(
          "Task App (SQFlite)",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (kIsWeb)
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        border: Border.all(color: Colors.amber[700]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber[900]),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Perhatian: SQFlite adalah database native file-system yang dirancang untuk platform Mobile (Android/iOS) dan Desktop (Windows).\n"
                              "Untuk menguji SQLite sepenuhnya, jalankan pada Android Device/Emulator atau Windows Desktop (flutter run -d windows).\n"
                              "Sedangkan modul Notes App (SharedPreferences) dan Contact App (Hive) berjalan lancar di browser ini.",
                              style: TextStyle(color: Colors.amber[900], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Text(
                    "Tambah Tugas (SQLite)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    key: _inputTitleKey,
                    decoration: const InputDecoration(
                      labelText: "Judul Tugas",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.assignment),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Judul tugas tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    key: _inputDescKey,
                    decoration: const InputDecoration(
                      labelText: "Deskripsi Tugas",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Deskripsi tugas tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    label: const Text("Tambah ke SQLite"),
                    icon: const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      if (kIsWeb) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("SQFlite native SQLite hanya didukung di Android/Desktop. Silakan uji coba di Android/Windows."),
                            backgroundColor: Colors.deepOrange,
                          ),
                        );
                        return;
                      }

                      if (_inputTitleKey.currentState!.validate() &&
                          _inputDescKey.currentState!.validate()) {
                        final newTask = TaskModel(
                          title: _inputTitleKey.currentState!.value.toString().trim(),
                          description: _inputDescKey.currentState!.value.toString().trim(),
                          createdAt: _getCurrentFormattedDate(),
                        );

                        // Operasi CREATE
                        await _dbHelper.insertTask(newTask);
                        await _loadTasks();

                        _inputTitleKey.currentState!.reset();
                        _inputDescKey.currentState!.reset();

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Tugas berhasil ditambahkan ke database SQFlite!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(
                    height: 30,
                    thickness: 3,
                    radius: BorderRadius.all(Radius.circular(10)),
                  ),
                  if (!_isLoading && _tasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: Text(
                          kIsWeb
                              ? "SQFlite tidak dapat diakses langsung pada Web Browser.\nSilakan jalankan di Android Emulator atau Windows Desktop."
                              : "Belum ada data tugas di SQFlite.\nSilakan buat tugas baru di atas.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _tasks.length,
                (context, index) {
                  final task = _tasks[index];
                  return Card(
                    color: Colors.teal[50],
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal[700],
                        child: Text(
                          "${task.id ?? index + 1}",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(task.description),
                          const SizedBox(height: 4),
                          Text(
                            "Dibuat: ${task.createdAt}",
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        initialValue: null,
                        onSelected: (menu) async {
                          if (menu == "Update") {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text("Update Tugas (SQLite)"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        key: _updateTitleKey,
                                        initialValue: task.title,
                                        decoration: const InputDecoration(
                                          labelText: "Judul",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return "Input tidak boleh kosong";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        key: _updateDescKey,
                                        initialValue: task.description,
                                        decoration: const InputDecoration(
                                          labelText: "Deskripsi",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return "Input tidak boleh kosong";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (_updateTitleKey.currentState!.validate() &&
                                            _updateDescKey.currentState!.validate()) {
                                          final updatedTask = TaskModel(
                                            id: task.id,
                                            title: _updateTitleKey.currentState!.value.toString().trim(),
                                            description: _updateDescKey.currentState!.value.toString().trim(),
                                            createdAt: task.createdAt,
                                          );

                                          // Operasi UPDATE
                                          await _dbHelper.updateTask(updatedTask);
                                          await _loadTasks();

                                          if (dialogContext.mounted) {
                                            Navigator.pop(dialogContext);
                                          }

                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("Data tugas berhasil diperbarui di SQLite!"),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                        "Simpan",
                                        style: TextStyle(color: Colors.teal),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (menu == "Hapus") {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text("Hapus Tugas"),
                                  content: Text(
                                    "Apakah Anda yakin ingin menghapus '${task.title}' dari database SQLite?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (task.id != null) {
                                          // Operasi DELETE
                                          await _dbHelper.deleteTask(task.id!);
                                          await _loadTasks();
                                        }

                                        if (dialogContext.mounted) {
                                          Navigator.pop(dialogContext);
                                        }

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Tugas berhasil dihapus dari SQLite!"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "Update",
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20, color: Colors.blue),
                                SizedBox(width: 8),
                                Text("Update"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: "Hapus",
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text("Hapus", style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
