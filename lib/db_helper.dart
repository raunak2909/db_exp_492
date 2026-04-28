import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  ///private constructor
  DBHelper._();

  static DBHelper getInstance() => DBHelper._();

  Database? mDB;

  Future<Database> initDB() async {
    mDB ??= await openDB();
    return mDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "notesDB.db");

    return await openDatabase(dbPath);
  }

  ///queries
  insertNote(){

  }

  fetchAllNotes(){

  }

  updateNote(){

  }

  deleteNote(){

  }

}