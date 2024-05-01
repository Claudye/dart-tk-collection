import 'package:as_collection/src/helpers.dart';
import 'package:test/test.dart';

void main() {
  group('dataGet tests', () {
    test('returns value from nested map', () {
      final data = {
        'user': {'name': 'Alice', 'age': 30}
      };
      final key = 'user.name';
      final expectedValue = 'Alice';

      final result = dataGet(data, key, null);

      expect(result, expectedValue);
    });

    test('returns value from nested list', () {
      final data = ['apple', 'banana', 'orange'];
      final key = '1'; // Index as key for lists
      final expectedValue = 'banana';

      final result = dataGet(data, key);

      expect(result, expectedValue);
    });

    test('returns from value map-list', () {
      final data = {
        'user': {
          'name': 'Alice',
          'notes': [
            {"english": 3},
            {"french": 4}
          ]
        }
      };
      final key = 'user.notes.1.english';
      final expectedValue = 3;

      final result = dataGet(data, key, expectedValue);

      expect(result, expectedValue);
    });

    test('returns default value for missing key', () {
      final data = {
        'user': {'name': 'Alice'}
      };
      final key = 'user.age';
      final expectedValue = 'unknown'; // Assuming defaults is set to 'unknown'

      final result = dataGet(data, key, 'unknown');

      expect(result, expectedValue);
    });

    test('returns default value for non-map/list data', () {
      final data = 'hello';
      final key = 'user.name';
      final expectedValue = 'unknown'; // Assuming defaults is set to 'unknown'

      final result = dataGet(data, key, 'unknown');

      expect(result, expectedValue);
    });

    test('throws error for invalid list index (out of bounds)', () {
      final data = ['apple', 'banana'];
      final key = '3'; // Index out of bounds

      expect(dataGet(data, key), null);
    });
  });
}
