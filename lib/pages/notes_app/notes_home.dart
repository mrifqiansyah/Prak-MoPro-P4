import 'package:flutter/material.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final _inputNoteKey = GlobalKey<FormFieldState>();
  final _updateNoteKey = GlobalKey<FormFieldState>();

  final List<String> _notes = [];

  // Isi Logic 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        title: Text(
          "Notes App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          icon: Icon(
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
                  Text(
                    "Buat Catatan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    key: _inputNoteKey,
                    decoration: InputDecoration(
                      labelText: "Catatan",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Input tidak boleh kosong";
                      }
        
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    label: Text("Tambah"),
                    icon: Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Isi Logic 2
                    },
                  ),
                  Divider(
                  height: 25,
                  thickness: 3,
                  radius: BorderRadius.all(Radius.circular(10)),
                ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _notes.length,
                (context, index) {
                  return Card(
                    color: Colors.blueGrey[100],
                    child: ListTile(
                      leading: Icon(Icons.notes),
                      title: Text(_notes[index]),
                      trailing: PopupMenuButton(
                        initialValue: null,
                        onSelected: (menu) async {
                          if (menu == "Update") {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Update Catatan"),
                                  content: TextFormField(
                                    key: _updateNoteKey,
                                    initialValue: _notes[index],
                                    decoration: InputDecoration(
                                      labelText: "Catatan",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Input tidak boleh kosong";
                                      }
                        
                                      return null;
                                    },
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
                                    TextButton(
                                      onPressed: () {
                                        // Isi Logic 3
                                      },
                                      child: Text(
                                        "Simpan",
                                        style: TextStyle(color: Colors.blue)
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Ingin Menghapus"),
                                  content: Text("Apakah kamu yakin ingin menghapus?"),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
                                    TextButton(
                                      onPressed: () {
                                        // Isi Logic 4
                                      },
                                      child: Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.red)
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: "Update",
                              child: Text("Update"),
                            ),
                            PopupMenuItem(
                              value: "Hapus",
                              child: Text(
                                "Hapus",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
