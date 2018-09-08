import 'category.dart';

class CategoryWrapper {
  List<Category> categories;

  CategoryWrapper(this.categories);

  CategoryWrapper.fromJson(Map<String, dynamic> json)
      : categories = new List<Category>.from(json['categories']);
}