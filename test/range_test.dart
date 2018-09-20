import 'package:test/test.dart';

import 'package:allegro_observer/allegro/range.dart';

void main() {
  test('Test range', () async {
    // Given
    var range = Range(5.0, 40.0);

    // When / Then
    expect(false, range.contains(4.0));
    expect(false, range.contains(50.0));
    expect(true, range.contains(5.1));
    expect(true, range.contains(39.9));
    expect(true, range.contains(20.0));
  });
}
