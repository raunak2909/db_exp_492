import 'dart:io';

import 'package:db_exp_492/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  ///private constructor
  DBHelper._();

  static DBHelper getInstance() => DBHelper._();

  Database? mDB;

  static const String DB_NAME = "notesDB.db";
  static const String TABLE_NOTE = "note";

  static const String COLUMN_NOTE_ID = "note_id";
  static const String COLUMN_NOTE_TITLE = "note_title";
  static const String COLUMN_NOTE_DESC = "note_desc";
  static const String COLUMN_NOTE_CREATED_AT = "note_created_at";

  Future<Database> initDB() async {
    mDB ??= await openDB();
    return mDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, DB_NAME);

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        ///tables

        db.execute(
          "create table $TABLE_NOTE ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_NOTE_CREATED_AT text )",
        );
      },
    );
  }

  ///queries
  Future<bool> insertNote({required NoteModel newNote}) async {
    Database db = await initDB();
    int rowsEffected = await db.insert(TABLE_NOTE, newNote.toMap());
    return rowsEffected > 0;
  }

  Future<List<NoteModel>> fetchAllNotes() async {
    Database db = await initDB();
    List<Map<String, dynamic>> mNotes = await db.query(TABLE_NOTE);
    List<NoteModel> allNotes = [];

    /*for(int i = 0; i<mNotes.length; i++){
      NoteModel eachNote = NoteModel.fromMap(mNotes[i]);
      allNotes.add(eachNote);
    }*/

    for(Map<String, dynamic> eachMap in mNotes){
      allNotes.add(NoteModel.fromMap(eachMap));
    }

    return allNotes;
  }

  Future<bool> updateNote({
    required String updatedTitle,
    required String updatedDesc,
    required int id,
  }) async {
    Database db = await initDB();
    int rowsEffected = await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: updatedTitle,
      COLUMN_NOTE_DESC: updatedDesc,
    }, where: "$COLUMN_NOTE_ID = $id");
    return rowsEffected > 0;
  }

  Future<bool> deleteNote({required int id}) async {
    Database db = await initDB();
    int rowsEffected = await db.delete(TABLE_NOTE,
        where: "$COLUMN_NOTE_ID = ?",
        whereArgs: ["$id"]);
    return rowsEffected>0;
  }
}
