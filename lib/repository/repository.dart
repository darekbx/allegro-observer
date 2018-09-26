import 'dart:async';
import 'package:allegro_observer/repository/local/database_provider.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/allegro/model/items_wrapper.dart';

class Repository {
  final dbName = 'allegro-observer.db';

  DatabaseProvider _provider;

  Future<int> addItems(ItemsWrapper itemsWrappwer) async {
    var addedCount = 0;
    addedCount += await _provider.addItems(itemsWrappwer.promoted);
    addedCount += await _provider.addItems(itemsWrappwer.regular);
    return addedCount;
  }

  Future<List<String>> fetchNewItemIds() async {
    return await _provider.fetchNewItemIds();
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
    _provider = DatabaseProvider();
    await _provider.open(dbName);
  }

  Future close() async => await _provider.close();
}