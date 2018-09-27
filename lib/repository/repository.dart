import 'dart:async';
import 'package:allegro_observer/repository/local/database_provider.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/allegro/model/items_wrapper.dart';

class Repository {
  final dbName = 'allegro-observer.db';

  static int _openCount = 0;
  DatabaseProvider _provider;

  Future<int> addItems(int filterId, ItemsWrapper itemsWrappwer) async {
    var addedCount = 0;
    addedCount += await _provider.addItems(filterId, itemsWrappwer.promoted);
    addedCount += await _provider.addItems(filterId, itemsWrappwer.regular);
    addedCount += (await _provider.fetchNewItemIds(filterId)).length;
    return addedCount;
  }

  Future<List<String>> fetchNewItemIds(int filterId) async {
    return await _provider.fetchNewItemIds(filterId);
  }

  Future clearIsNew(List<String> newIds) async {
    return await _provider.clearIsNew(newIds);
  }

  Future<int> addFilter(Filter filter) async {
    var id = await _provider.addFilter(filter);
    return id;
  }

  Future<List<Filter>> fetchFilters() async {
    var filters = await _provider.fetchFilters();
    return filters;
  }

  Future open() async {
    _openCount++;
    _provider = DatabaseProvider();
    await _provider.open(dbName);
    print("open $_openCount");
  }

  Future close() async {
    _openCount--;
    if (_openCount > 0) {
      print("block close");
      return;
    }
    await _provider.close();
    print("close $_openCount");
  }
}