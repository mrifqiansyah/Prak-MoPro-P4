import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_application_10/pages/main_app.dart';

void main() async {
  // Memastikan binding widget Flutter terinisialisasi sebelum melakukan operasi asynchronous
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi SQFlite FFI jika dijalankan di sistem operasi desktop (Windows / Linux / macOS)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  // Inisialisasi Hive untuk platform Flutter (menyiapkan direktori penyimpanan lokal)
  await Hive.initFlutter();
  
  // Membuka Hive Box dengan nama 'contacts_box' untuk menyimpan data kontak secara lokal
  await Hive.openBox('contacts_box');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainApp(),
    );
  }
}
