import 'package:flutter/material.dart';

class ContactHome extends StatefulWidget {
  const ContactHome({super.key});

  @override
  State<ContactHome> createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHome> {
  final _inputNameKey = GlobalKey<FormFieldState>();
  final _inputTelKey = GlobalKey<FormFieldState>();

  final _updateNameKey = GlobalKey<FormFieldState>();
  final _updateTelKey = GlobalKey<FormFieldState>();

  final List<String> _contacts = [];

  // Isi Logic 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          "Contact App",
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
                    "Tambah Kontak",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    key: _inputNameKey,
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Input tidak boleh kosong";
                      }
        
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    key: _inputTelKey,
                    decoration: InputDecoration(
                      labelText: "Nomor Telepon",
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
                childCount: _contacts.length,
                (context, index) {
                  return Card(
                    color: Colors.blueGrey[100],
                    child: ListTile(
                      leading: Icon(Icons.notes),
                      title: Text(_contacts[index]),
                      trailing: PopupMenuButton(
                        initialValue: null,
                        onSelected: (menu) async {
                          if (menu == "Update") {
                            await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Update Catatan"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        key: _updateNameKey,
                                        initialValue: _contacts[index],
                                        decoration: InputDecoration(
                                          labelText: "Nama",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Input tidak boleh kosong";
                                          }
                                                              
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        key: _updateTelKey,
                                        initialValue: _contacts[index],
                                        decoration: InputDecoration(
                                          labelText: "Nomor Telepon",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Input tidak boleh kosong";
                                          }
                                                              
                                          return null;
                                        },
                                      ),
                                    ],
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
