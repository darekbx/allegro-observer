import 'category.dart';
import 'parent.dart';

class CategoryWrapper {
  List<Category> categories;
  Parent parent;

  CategoryWrapper(this.parent, this.categories);

  CategoryWrapper.fromJson(Map<String, dynamic> json)
      : parent = Parent.fromJson(json['parent']),
        categories = (json['categories'] as List).map((item) =>
            Category.fromJson(item)).toList();
}