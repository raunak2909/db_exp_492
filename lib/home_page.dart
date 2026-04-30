import 'package:flutter/material.dart';

import 'db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper dbHelper = DBHelper.getInstance();

  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    getAllNotes();
  }

  getAllNotes() async {
    notes = await dbHelper.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: notes.isNotEmpty
          ? ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text("${index+1}"),
                  title: Text(notes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(notes[index][DBHelper.COLUMN_NOTE_DESC]),
                );
              },
            )
          : Center(child: Text('No Notes yet!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ///insertNote
          bool isAdded = await dbHelper.insertNote(
            title: "First Note",
            desc: "Hello World in DB from Flutter",
          );

          if(isAdded){
            getAllNotes();
          }

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
