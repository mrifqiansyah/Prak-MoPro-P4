import 'package:flutter/material.dart';
import 'package:flutter_application_10/pages/notes_app/notes_home.dart';
import 'package:flutter_application_10/pages/contact_app/contact_home.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text(
          "Main App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Notes App",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Storage: shared_preference",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotesHome())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                )
              ),
              child: Text("Buka Aplikasi"),
            ),
            SizedBox(height: 50),
            Text(
              "Contact App",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Storage: hive",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ContactHome())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                )
              ),
              child: Text("Buka Aplikasi"),
            ),
          ],
        )
      ),
    );
  }
}
