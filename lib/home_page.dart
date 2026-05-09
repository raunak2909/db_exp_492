import 'package:db_exp_492/note_model.dart';
import 'package:flutter/material.dart';

import 'db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DBHelper dbHelper = DBHelper.getInstance();

  List<NoteModel> notes = [];

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
                  leading: Text("${index + 1}"),
                  title: Text(notes[index].title),
                  subtitle: Text(notes[index].desc),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {

                          titleController.text = notes[index].title;
                          descController.text = notes[index].desc;

                          showModalBottomSheet(
                            //isDismissible: false,
                            //enableDrag: false,
                            context: context,
                            builder: (_) {
                              return getBottomSheetUI(isUpdate: true, index: index);
                            },
                          );

                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          showModalBottomSheet(
                            //isDismissible: false,
                            //enableDrag: false,
                            context: context,
                            builder: (_) {
                              return Container(
                                padding: EdgeInsets.all(21),
                                height: 180,
                                child: Column(
                                  children: [
                                    Text(
                                      'Are you sure want to delete this note?',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 11),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        SizedBox(width: 11),
                                        OutlinedButton(
                                          onPressed: () async {
                                            bool isDeleted = await dbHelper
                                                .deleteNote(
                                                  id: notes[index].id!,
                                                );
                                            if (isDeleted) {
                                              getAllNotes();
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: Text('No Notes yet!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.text = "";
          descController.clear();


          showModalBottomSheet(
            //isDismissible: false,
            //enableDrag: false,
            context: context,
            builder: (_) {
              return getBottomSheetUI();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetUI({bool isUpdate = false, int index = -1}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 21, horizontal: 11),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            '${isUpdate ? 'Update' : 'Add'} Note',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 11),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Enter your title here..",
              labelText: "Title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
            ),
          ),
          SizedBox(height: 11),
          TextField(
            controller: descController,
            maxLines: 7,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              hintText: "Enter your desc here..",
              labelText: "Desc",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
            ),
          ),
          SizedBox(height: 11),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  ///insertNote

                  bool taskDone = false;

                  if(isUpdate){
                    taskDone = await dbHelper.updateNote(
                      updatedTitle: titleController.text,
                      updatedDesc: descController.text,
                      id: notes[index].id!,
                    );
                  } else {
                    taskDone = await dbHelper.insertNote(
                      newNote: NoteModel(
                        title: titleController.text,
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                        desc: descController.text,
                      ),
                    );
                  }

                  if (taskDone) {
                    getAllNotes();
                    Navigator.pop(context);
                  }
                },
                child: Text("Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 11),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }

}



/* */
