import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allegro_observer/model/filter.dart';

class DatabaseProvider {

  final _filterTableName = "filter";
  final _itemTableName = "item";
  final _version = 1;
  Database _db;

  Future open(String dbName) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    _db = await openDatabase(
        path,
        version: _version,
        onCreate: (Database db, int version) {
          _executeCreateTables(db);
        });
  }

  Future close() async => _db.close();

  Future<int> addFilter(Filter filter) async {
    var id = await _db.insert(_filterTableName, filter.toMap());
    return id;
  }

  Future<List<Filter>> fetchFilters() async {
    List<Map> maps = await _db.query(_filterTableName);
    if (maps.length > 0) {
      return maps.map((map) => Filter.fromMap(map)).toList();
    }
    return null;
  }

  _executeCreateTables(Database db) async {
    await db.execute('''
      CREATE TABLE $_filterTableName (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        keyword TEXT NULL,
        priceFrom DOUBLE NULL,
        priceTo DOUBLE NULL,
        searchInDescription INTEGER DEFAULT 0,
        searchUsed INTEGER DEFAULT 0,
        searchNew INTEGER DEFAULT 1,
        categoryName TEXT NOT NULL,
        categoryId TEXT NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE $_itemTableName (
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