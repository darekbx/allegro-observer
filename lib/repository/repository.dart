import 'dart:async';
import 'package:allegro_observer/repository/local/database_provider.dart';
import 'package:allegro_observer/repository/remote/firebase_provider.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/allegro/model/items_wrapper.dart';

class Repository {
  final dbName = 'allegro-observer.db';

  static int _openCount = 0;
  DatabaseProvider _provider;

  Future<int> addItems(int filterId, ItemsWrapper itemsWrappwer) async {
    await _provider.addItems(filterId, itemsWrappwer.promoted);
    await _provider.addItems(filterId, itemsWrappwer.regular);
    var addedCount = (await _provider.fetchNewItemIds(filterId)).length;

    if (addedCount == 0) {
      addedCount = -(await _provider.fetchItemIds(filterId)).length;
    }

    return addedCount;
  }

  Future deleteFilter(int filterId) async => _provider.deleteFilter(filterId);

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

  Future exportToFirebase() async {
    var firebaseProvider = FirebaseProvider();
    var filters = await _provider.fetchFilters();
    for (var filter in filters) {
      await firebaseProvider.add(filter);
    }
  }

  Future<int> countRemoteFilters() async {
    var firebaseProvider = FirebaseProvider();
    return firebaseProvider.countFilters();
  }

  Future<List<Filter>> importFilters() async {
    var firebaseProvider = FirebaseProvider();
    return await firebaseProvider.fetchFilters();
  }

  Future open() async {
    _openCount++;
    _provider = DatabaseProvider();
    await _provider.open(dbName);
  }

  Future close() async {
    _openCount--;
    if (_openCount > 0) {
      return;
    }
    await _provider.close();
  }
}