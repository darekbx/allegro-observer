import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allegro_observer/model/filter.dart';

class FirebaseProvider {

  var _COLLECTION_KEY = "filters";

  Future add(Filter filter) async {
    await Firestore.instance.collection(_COLLECTION_KEY)
        .document()
        .setData(filter.toMap());
  }

  Future<int> countFilters() async {
    var documentsFuture = await Firestore.instance.collection(_COLLECTION_KEY)
        .getDocuments();
    return documentsFuture.documents.length;
  }

  Future<List<Filter>> fetchFilters() async {
    var documentsFuture = await Firestore.instance.collection(_COLLECTION_KEY)
        .getDocuments();
    return documentsFuture.documents
        .map((document) => Filter.fromMap(document.data)).toList();
  }
}