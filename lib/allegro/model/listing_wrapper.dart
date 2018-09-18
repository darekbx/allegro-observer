import 'package:allegro_observer/allegro/model/items_wrapper.dart';

class ListingWrapper {
  final ItemsWrapper items;

  ListingWrapper(this.items);

  ListingWrapper.fromJson(Map<String, dynamic> json)
      : items = ItemsWrapper.fromJson(json['items']);
}