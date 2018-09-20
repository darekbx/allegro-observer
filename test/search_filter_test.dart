import 'package:test/test.dart';

import 'package:allegro_observer/allegro/allegro_search.dart';
import 'package:allegro_observer/allegro/model/item.dart';
import 'package:allegro_observer/model/filter.dart';

void main() {
  test('Check if item is valid', () async {
    // Given
    var allegroSearch = AllegroSearch();

    var filter = Filter();
    var item = Item();

    // When / Then
    expect(false, allegroSearch.isValidItem(filter, item);
  });
}
