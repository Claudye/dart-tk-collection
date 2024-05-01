/// Retrieves a value from a data object or list using a key string.
///
/// This function supports accessing nested properties using dot notation.
/// If the value is not found, it returns the specified default value.
///
/// Example:
/// ```dart
/// void main() {
///   var data = {
///     'name': 'John',
///     'age': 30,
///     'address': {
///       'city': 'New York',
///       'zip': 10001
///     }
///   };
///
///   // Retrieve values from nested data
///   var name = dataGet(data, 'name');
///   var city = dataGet(data, 'address.city');
///   var country = dataGet(data, 'address.country', 'Unknown');
///
///   print('Name: $name');       // Output: Name: John
///   print('City: $city');       // Output: City: New York
///   print('Country: $country'); // Output: Country: Unknown
/// }
/// ```
dynamic dataGet(data, String key, [Object? defaults]) {
  //Get value from data object/list
  var keys = key.split(".").map((e) => e.trim());
  if (data is Map || data is List) {
    bool isMap = data is Map;
    bool isList = data is List;

    for (var k in keys) {
      try {
        if (isMap) {
          data = data[k] ?? defaults;
          isMap = data is Map;
          isList = data is List;
        } else if (isList) {
          data = data[int.parse(k)] ?? defaults;
          isList = data is List;
          isMap = data is Map;
        } else {
          data = defaults;
        }
      } catch (e) {
        data = defaults;
      }
    }
    return data;
  } else {
    return defaults;
  }
}
