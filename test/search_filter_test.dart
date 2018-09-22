import 'package:test/test.dart';

import 'package:allegro_observer/allegro/allegro_search.dart';
import 'package:allegro_observer/allegro/model/item.dart';
import 'package:allegro_observer/allegro/model/image.dart';
import 'package:allegro_observer/allegro/model/parameter.dart';
import 'package:allegro_observer/allegro/model/sellingmode.dart';
import 'package:allegro_observer/model/filter.dart';

void main() {
  test('Check if item is valid, new with price', () async {
    // Given
    var allegroSearch = AllegroSearch();

    var filter = Filter(priceFrom: 10.00, priceTo: 20.00, searchNew: true, searchUsed: false);
    var images =  [Image("Image url")];
    var parameters = [Parameter("Stan", ["Nowy"])];
    var sellingMode = SellingMode(SellingModeItem(Price("13.44", "PLN")), null);
    var item = Item("1", "Frame", "Url", images, parameters, sellingMode);

    // When / Then
    expect(allegroSearch.isValidItem(filter, item), true);
  });

  test('Check if item is valid, used no price', () async {
    // Given
    var allegroSearch = AllegroSearch();

    var filter = Filter(searchNew: false, searchUsed: true);
    var images =  [Image("Image url")];
    var parameters = [Parameter("Stan", ["Używany"])];
    var sellingMode = SellingMode(SellingModeItem(Price("1.44", "PLN")), null);
    var item = Item("1", "Frame", "Url", images, parameters, sellingMode);

    // When / Then
    expect(allegroSearch.isValidItem(filter, item), true);
  });

  test('Check if item is invalid, new, wrong to price', () async {
    // Given
    var allegroSearch = AllegroSearch();

    var filter = Filter(priceTo: 100.0, searchNew: true, searchUsed: false);
    var images =  [Image("Image url")];
    var parameters = [Parameter("Stan", ["Nowy"])];
    var sellingMode = SellingMode(SellingModeItem(Price("200.00", "PLN")), null);
    var item = Item("1", "Frame", "Url", images, parameters, sellingMode);

    // When / Then
    expect(allegroSearch.isValidItem(filter, item), false);
  });

  test('Check if item is invalid, used, wrong from price', () async {
    // Given
    var allegroSearch = AllegroSearch();

    var filter = Filter(priceFrom: 10.0, searchNew: false, searchUsed: true);
    var images =  [Image("Image url")];
    var parameters = [Parameter("Stan", ["Używany"])];
    var sellingMode = SellingMode(SellingModeItem(Price("0.99", "PLN")), null);
    var item = Item("1", "Frame", "Url", images, parameters, sellingMode);

    // When / Then
    expect(allegroSearch.isValidItem(filter, item), false);
  });
}
