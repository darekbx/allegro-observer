import 'image.dart';
import 'parameter.dart';
import 'sellingmode.dart';

class Item {

  final String id;
  final String name;
  final String url;
  final List<Image> images;
  final List<Parameter> parameters;
  final SellingMode sellingMode;

  Item(this.id, this.name, this.url, this.images, this.parameters,
      this.sellingMode);

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'],
        images = (json['images'] as List)
            .map((item) => Image.fromJson(item))
            .toList(),
        parameters = (json['parameters'] as List)
            .map((item) => Parameter.fromJson(item))
            .toList(),
        sellingMode = SellingMode.fromJson(json['sellingMode']);

  String priceFormatted() {
    if (sellingMode.auction != null) {
      return sellingMode.auction.price.toString();
    }
    else {
      return sellingMode.buyNow.price.toString();
    }
  }
}