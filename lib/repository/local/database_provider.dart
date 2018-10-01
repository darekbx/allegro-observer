import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/allegro/model/item.dart';

class DatabaseProvider {

  final _filterTableName = "filter";
  final _itemTableName = "item";
  final _version = 1;
  Database _db;

  Future open(String dbName) async {
    //Sqflite.devSetDebugModeOn(true);
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    _db = await openDatabase(
        path,
        version: _version,
        onCreate: (Database db, int version) {
          _executeCreateTables(db);
        });
  }

  Future close() async => await _db.close();

  Future deleteFilter(int filterId) async {
    await _db.delete(_filterTableName, where: "_id = ?", whereArgs: [filterId]);
    await _db.delete(_itemTableName, where: "filterId = ?", whereArgs: [filterId]);
  }

  Future<int> addItems(int filterId, List<Item> items) async {
    var addedCount = 0;
    var ids = await fetchItemIds(filterId);
    for (Item item in items) {
      if (ids.contains(item.id)) {
        continue;
      }
      Map<String, dynamic> itemMap = item.toMap();
      itemMap["filterId"] = filterId;
      await _db.insert(_itemTableName, itemMap);
      addedCount++;
    }
    return addedCount;
  }

  Future<List<String>> fetchItemIds(int filterId) async {
    List<Map> maps = await _db.query(
        _itemTableName,
        where: "filterId = ?",
        whereArgs: [filterId]);
    return maps.map((map) {
      var value = map["allegroId"].toString();
      return value;
    }).toList();
  }

  Future<List<String>> fetchNewItemIds(int filterId) async {
    List<Map> maps = await _db.query(_itemTableName,
        where: "filterId = ? AND isNew = ?",
        whereArgs: [filterId, 1]);
    return maps.map((map) {
      var value = map["allegroId"].toString();
      return value;
    }).toList();
  }

  Future clearIsNew(List<String> newIds) async {
    for (String id in newIds) {
      await _db.update(_itemTableName,
          {"isNew": 0},
          where: "allegroId = ?",
          whereArgs: [id]);
    }
  }

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
        isNew INTEGER DEFAULT 0,
        filterId INTEGER
      )
    ''');
  }
}