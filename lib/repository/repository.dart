import 'dart:async';
import 'package:allegro_observer/repository/local/database_provider.dart';
import 'package:allegro_observer/model/filter.dart';

class Repository {
  final dbName = 'allegro-observer.db';

  DatabaseProvider _provider;

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