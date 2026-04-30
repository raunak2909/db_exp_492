import 'dart:io';

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
  Future<bool> insertNote({required String title, required String desc}) async {
    Database db = await initDB();
    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
      COLUMN_NOTE_CREATED_AT: DateTime.now().millisecondsSinceEpoch.toString()
    });
    return rowsEffected>0;
  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    Database db = await initDB();
    return await db.query(TABLE_NOTE);
  }

  updateNote() {}

  deleteNote() {}
}
