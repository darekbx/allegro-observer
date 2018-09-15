import 'package:allegro_observer/allegro/model/category.dart';

class Filter {

  String id;
  String keyword;
  double priceFrom;
  double priceTo;
  bool searchUsed;
  bool searchNew;
  Category category;

  Filter({this.id, this.keyword, this.priceFrom, this.priceTo, this.searchUsed,
      this.searchNew, this.category});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "keyword": keyword,
      "priceFrom": priceFrom,
      "priceTo": priceTo,
      "searchUsed": _mapToInt(searchUsed),
      "searchNew": _mapToInt(searchNew),
      "categoryName": category.name,
      "categoryId": category.id
    };
  }

  Filter.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    keyword = map["keyword"];
    priceFrom = map["priceFrom"];
    priceTo = map["priceTo"];
    searchUsed = map["searchUsed"] == 1;
    searchNew = map["searchNew"] == 1;
    category = Category(map["categoryId"], map["categoryName"], false);
  }

  int _mapToInt(bool value) => value == true ? 1 : 0;

  bool hasKeyword() => keyword != null && !keyword.isEmpty;
  bool hasPriceFrom() => priceFrom != null && priceFrom > 0.0;
  bool hasPriceTo() => priceTo != null && priceTo > 0.0;
  int priceFromInt() => priceFrom.toInt();
  int priceToInt() => priceTo.toInt();

  @override
  String toString() {
    return this.keyword +
        ", " + this.priceFrom.toString() +
        ", " + this.priceTo.toString() +
        ", " + (this.searchUsed ? "Used" : "") +
        ", " + (this.searchNew ? "Used" : "") +
        ", " + this.category.name;
  }
}