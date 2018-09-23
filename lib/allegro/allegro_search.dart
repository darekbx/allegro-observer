import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:allegro_observer/allegro/model/listing_wrapper.dart';
import 'package:allegro_observer/allegro/allegro_base.dart';
import 'package:allegro_observer/model/filter.dart';

class AllegroSearch {
  final String SEARCH_ENDPOINT = "/listing";

  Future<ListingWrapper> search(Filter filter) async {
    var headers = { "Accept": "application/vnd.allegro.public.v3+json"};
    var query = {
      "categoryId": filter.category.id,
      "phrase": filter.keyword,
      "include": "-sortingOptions",
      "limit": LIMIT.toString(),
      "stan": filter.priceQuery()
    };

    if (filter.priceFrom != null) {
      query["price_from"] = filter.priceFrom.toString();
    }

    if (filter.priceFrom != null) {
      query["price_to"] = filter.priceTo.toString();
    }

    var uri = Uri.https(EDGE_API_URL, SEARCH_ENDPOINT, query);
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      var jsonMap = json.decode(response.body);
      var wrapper = ListingWrapper.fromJson(jsonMap);
      return wrapper;
    } else {
      return null;
    }
  }
}