import 'package:test/test.dart';

import 'package:allegro_observer/repository/repository.dart';
import 'package:allegro_observer/model/filter.dart';
import 'package:allegro_observer/allegro/model/category.dart';

void main() {
  test('Add filter and list', () async {
    // Given
    var category = Category("50", "Part", false);
    var filter = Filter(name: "Kcnc",
        priceFrom: null,
        priceTo: 100.0,
        searchUsed: true,
        searchNew: false,
        category: category);
    var repository = Repository();

    // When
    var id = await repository.addFilter(filter);

    // Then
    expect(id, inExclusiveRange(0, 100));
    List<Filter> list = await repository.fetchFilters();

    expect(list.length, 1);
  });
}
