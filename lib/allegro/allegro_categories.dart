import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:allegro_observer/allegro/model/category_wrapper.dart';
import 'allegro_base.dart';

class AllegroCategories {
  final String CATEGORIES_ENDPOINT = "/categories?parent.id=";

  Future<CategoryWrapper> getMainCategories() async => getCategories(CATEGORY_PARENT_ID);

  Future<CategoryWrapper> getCategories(String parentId) async {
    var address = API_URL + CATEGORIES_ENDPOINT + parentId;
    var headers =  { "Accept": "application/vnd.allegro.public.v1+json" };
    var response = await http.get(address, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      var jsonMap = json.decode(response.body);
      return CategoryWrapper.fromJson(jsonMap);
    } else {
      return null;
    }
  }
}