import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  final version = 1;
  Database db;

  Future open(String path) async {
    db = await openDatabase(
        path,
        version: version,
        onCreate: (Database db, int version) async {
          await _executeCreateTables(db);
        });
  }

  Future _executeCreateTables(Database db) async {
    return await db.execute('''
      
      create
      
      ''');
  }
}