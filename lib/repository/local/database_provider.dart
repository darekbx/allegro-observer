import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  final version = 1;
  Database db;

  Future open(String path) async {
    db = await openDatabase(
        path,
        version: version,
        onCreate: (Database db, int version) {
          _executeCreateTables(db);
        });
  }

  Future close() async => db.close();

  _executeCreateTables(Database db) async {
    await db.execute('''
      CREATE TABLE filter (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NULL,
        priceFrom DOUBLE NULL,
        priceTo DOUBLE NULL,
        searchUsed INTEGER DEFAULT 0,
        searchNew INTEGER DEFAULT 1,
        categoryName TEXT NOT NULL,
        categoryId TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE item (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        allegroId TEXT NULL,
        name TEXT NULL,
        price TEXT NULL,
        startingPrice TEXT NULL,
        minimalPrice TEXT NULL,
        endDate TEXT NULL,
        city TEXT NULL,
        imageUrl TEXT NULL
      )
    ''');
  }
}