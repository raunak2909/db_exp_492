import 'package:db_exp_492/db_helper.dart';

class NoteModel {
  int? id;
  String title;
  String desc;
  int createdAt;

  NoteModel({
    this.id,
    required this.title,
    required this.createdAt,
    required this.desc,
  });

  ///fromMapToModel(fetched data)
  factory NoteModel.fromMap(Map<String, dynamic> map){
    return NoteModel(
        id: map[DBHelper.COLUMN_NOTE_ID],
        title: map[DBHelper.COLUMN_NOTE_TITLE],
        createdAt: int.parse(map[DBHelper.COLUMN_NOTE_CREATED_AT]),
        desc: map[DBHelper.COLUMN_NOTE_DESC]);
  }
  ///fromModelToMap(insert, update)
  Map<String, dynamic> toMap(){
    return {
      DBHelper.COLUMN_NOTE_TITLE : title,
      DBHelper.COLUMN_NOTE_DESC : desc,
      DBHelper.COLUMN_NOTE_CREATED_AT : createdAt.toString(),
    };
  }
}
