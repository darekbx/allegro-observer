
class Item {

  final String id;
  final String name;
  final String url;

  Item(this.id, this.name, this.url);

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'];
}