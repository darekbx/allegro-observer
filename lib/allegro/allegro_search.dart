import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:allegro_observer/allegro/model/listing_wrapper.dart';
import 'package:allegro_observer/allegro/allegro_base.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/allegro/model/item.dart';
import 'range.dart';

class AllegroSearch {
  final String SEARCH_ENDPOINT = "/listing";

  Future<ListingWrapper> search(Filter filter) async {
    var headers = { "Accept": "application/vnd.allegro.public.v3+json"};
    var query = {
      "categoryId": filter.category.id,
      "phrase": filter.keyword,
      "include": "-sortingOptions"
    };

    var uri = Uri.https(EDGE_API_URL, SEARCH_ENDPOINT, query);
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      var jsonMap = json.decode(response.body);
      var wrapper =  ListingWrapper.fromJson(jsonMap);

      wrapper.items.promoted.removeWhere((item) => isValidItem(filter, item));
      wrapper.items.regular.removeWhere((item) => isValidItem(filter, item));

      return wrapper;
    } else {
      return null;
    }
  }

  bool isValidItem(Filter filter, Item item) {

    if (!filter.searchUsed || !filter.searchNew) {
      var state = item.parameters.firstWhere(
              (parameter) => parameter.name == "Stan",
          orElse: () => null);

      if (state != null) {
        var value = state.values.first;
        if (filter.searchNew && value != "Nowy") {
          return false;
        }
        if (filter.searchUsed && value != "Używany") {
          return false;
        }
      }
    }

    if (filter.priceFrom != null || filter.priceTo != null) {
      var from = filter.priceFrom ?? 0.0;
      var to = filter.priceTo ?? double.minPositive;
      var sellingMode = item.sellingMode;
      var auction = sellingMode.auction != null ? sellingMode.auction.price : null;
      var buyNow = sellingMode.buyNow != null ? sellingMode.buyNow.price : null;
      var range = Range(from, to);

      if (auction != null) {
        if (!range.contains(double.parse(auction.amount))) {
          return false;
        }
      }

      if (buyNow != null) {
        if (!range.contains(double.parse(buyNow.amount))) {
          return false;
        }
      }
    }

    return true;
  }
}