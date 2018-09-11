import 'package:allegro_observer/allegro/model/category.dart';

class Filter {
  final String name;
  final double priceFrom;
  final double priceTo;
  final bool searchUsed;
  final bool searchNew;
  final Category category;

  Filter(this.name, this.priceFrom, this.priceTo, this.searchUsed,
      this.searchNew, this.category);

  @override
  String toString() {
    return this.name +
        ", " + this.priceFrom.toString() +
        ", " + this.priceTo.toString() +
        ", " + (this.searchUsed ? "Used" : "") +
        ", " + (this.searchNew ? "Used" : "") +
        ", " + this.category.name;
  }
}