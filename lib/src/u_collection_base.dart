import 'package:as_collection/src/helpers.dart';
import 'package:as_collection/src/operators.dart';
import 'dart:math' as math;

class Collection<T> {
  List<T> items = [];

  final List<T>? _original;
  Collection(List<T> this._original) {
    this._init(_original);
  }

  /// Get all the items in the collection.
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   // Create a collection of integers
  ///   var collection = Collection<int>([1, 2, 3, 4, 5]);
  ///
  ///   // Retrieve all items from the collection
  ///   var allItems = collection.all();
  ///
  ///   // Display the items from the collection
  ///   print('All items in the collection: $allItems');
  /// }
  /// ```
  List<T> all() {
    return items;
  }

  /// Add an item to the end of the collection.
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   // Create a collection of strings
  ///   var collection = Collection<String>(['apple', 'banana', 'orange']);
  ///
  ///   // Add a new fruit to the collection
  ///   collection.push('grape');
  ///
  ///   // Display the updated collection
  ///   print('Updated collection: ${collection.all()}');
  /// }
  /// ```
  Collection push(T item) {
    items.add(item);
    return this;
  }

  /// Add an item to the end of the collection.
  ///
  /// This method is an alias of [push()].
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   // Create a collection of strings
  ///   var collection = Collection<String>(['apple', 'banana', 'orange']);
  ///
  ///   // Add a new fruit to the collection
  ///   collection.add('grape');
  ///
  ///   // Display the updated collection
  ///   print('Updated collection: ${collection.all()}');
  /// }
  /// ```
  Collection add(T item) {
    this.push(item);
    return this;
  }

  Collection remove(int index) {
    items.removeAt(index);
    return this;
  }

  Collection filter(bool Function(T) callback) {
    items = items.where(callback).toList();
    return this;
  }

  Collection sort<SortArgType>([SortArgType? compare]) {
    if (compare is Function) {
      items.sort(compare as int Function(T, T));
    } else if (compare is String) {
      items.sort((a, b) {
        var x = dataGet(a, compare);
        var y = dataGet(b, compare);
        if (x is String && y is String) {
          return x.compareTo(y);
        }
        if (x is int && y is int) {
          return x - y;
        }
        if (x is List && y is List) {
          return x.length - y.length;
        }
        return 0;
      });
    } else {
      items.sort();
    }

    return this;
  }

  bool every<EveryArgType>([EveryArgType? condition]) {
    if (condition is Function) {
      return items.every(condition as bool Function(T));
    }

    if (condition is String) {
      return this.items.every((element) => dataGet(element, condition) != null);
    }
    return items.every((item) => item != null);
  }

  bool some<SomeArgType>([SomeArgType? condition]) {
    return !this.every(SomeArgType);
  }

  Collection sortByDesc<SortArgType>([SortArgType? compare]) {
    return this.sort(compare).reverse();
  }

  Collection reverse() {
    items = items.reversed.toList();
    return this;
  }

  Collection<MT> map<MT>(MT Function(T) callback) {
    var results = items.map<MT>(callback);
    return Collection<MT>(results.toList());
  }

  String join([String separator = '']) {
    return items.join(separator);
  }

  Collection where(Object filter, [Object? operator, Object? value]) {
    if (filter is Function) {
      return this.filter(filter as bool Function(T));
    }
    return this.filterBy(filter, operator, value);
  }

  Collection filterBy(dynamic key, Object? operator, value) {
    if (key is Function) {
      return this.filter(filter as bool Function(T));
    }

    if (key is String) {
      if (!Operator.isOperator(operator)) {
        value = operator;
        operator = Operator.equals;
      }

      if (operator != null && value != null) {
        switch (operator) {
          case Operator.equals:
            return this.filter((p0) => dataGet(p0, key) == value);
          case "<=":
            return this.filter((p0) => dataGet(p0, key) <= value);
          case "<":
            return this.filter((p0) => dataGet(p0, key) < value);
          case ">":
            return this.filter((p0) => dataGet(p0, key) > value);
          case "!=":
            return this.filter((p0) => dataGet(p0, key) != value);
          case "like":
            return this
                .filter((p0) => (dataGet(p0, key) as String).contains(value));
          default:
        }
      }
    }
    return this.filter((item) => item != null && item != '');
  }

  Collection<MP> pluck<MP>(String selector) {
    var mapped = this.map<MP>((p0) => dataGet(p0, selector)).all();

    return Collection<MP>(mapped);
  }

  Collection orderBy<OrderByArgType>([OrderByArgType? compare]) {
    return this.sort(compare);
  }

  Collection orderByDesc<OrderByArgType>([OrderByArgType? compare]) {
    return this.sortByDesc(compare);
  }

  T value(int index) {
    return this.items.elementAt(index);
  }

  Collection put(int index, T item) {
    this.items[index] = item;
    return this;
  }

  T first() {
    return this.items.first;
  }

  T last() {
    return this.items.last;
  }

  Collection insert(int index, T item) {
    this.items.insert(index, item);
    return this;
  }

  Collection clear() {
    this.items = [];
    return this;
  }

  _init(List<T>? value) {
    items = value ?? [];
  }

  Collection<Map<Object, List<T>>> groupBy<P>(P param) {
    final groups = <Object, List<T>>{};
    for (final item in items) {
      Object groupKey;
      if (param is Function) {
        groupKey = param(item) ?? "";
      } else if (param is String) {
        groupKey = dataGet(item, param) ?? "";
      } else if (param is Map) {
        groupKey = param;
      } else if (param is List) {
        groupKey = param;
      } else {
        throw ArgumentError(
            'Invalid groupBy parameter type: ${param.runtimeType}');
      }

      groups[groupKey] ??= []; // Initialize empty list if key doesn't exist
      groups[groupKey]!.add(item);
    }
    var collect = Collection<Map<Object, List<T>>>([]);
    for (var element in groups.entries) {
      collect.push({element.key: element.value});
    }
    return collect;
  }

  Collection when(bool condition, Function(Collection collection) callback) {
    if (condition) {
      var instance = callback(this);

      if (instance is Collection) {
        return instance;
      }
    }

    return this;
  }

  num sum([Object? param]) {
    return this.items.fold(0, (previousValue, element) {
      if (param is String) {
        final v = dataGet(element, param);
        if (v is num) {
          return previousValue + v;
        }
      } else if (param is Function) {
        final v = param(element);
        if (v is num) {
          return previousValue + v;
        }
      } else if (param == null) {
        return previousValue + (element is num ? element : 0);
      }
      return 0;
    });
  }

  num avg([Object? param]) {
    final sum = this.sum(param);
    final itemCount = this.items.length;
    if (itemCount == 0) {
      return 0;
    }
    return sum / itemCount;
  }

  bool areNumbers() {
    return this.every((item) => item is num);
  }

  bool isEmpty() {
    return this.items.isEmpty;
  }

  bool isNotEmpty() {
    return this.items.isNotEmpty;
  }

  num? min() {
    if (this.isEmpty()) {
      return null;
    }

    if (this.areNumbers()) {
      if (items is List<int>) {
        return (items as List<int>).reduce(math.min);
      } else if (items is List<double>) {
        return (items as List<double>).reduce(math.min);
      }
    }
    return null;
  }

  num? max() {
    if (this.isEmpty()) {
      return null;
    }

    if (this.areNumbers()) {
      if (items is List<int>) {
        return (items as List<int>).reduce(math.max);
      } else if (items is List<double>) {
        return (items as List<double>).reduce(math.max);
      }
    }
    return null;
  }

  Collection<List<T>> chunk(int size) {
    if (size <= 0) {
      throw ArgumentError("Chunk size must be greater than zero.");
    }

    List<List<T>> chunkedItems = [];
    int index = 0;

    while (index < items.length) {
      chunkedItems
          .add(items.sublist(index, math.min(index + size, items.length)));
      index += size;
    }

    return Collection<List<T>>(chunkedItems);
  }

  T? firstWhere(bool Function(T) predicate) {
    for (var item in items) {
      if (predicate(item)) {
        return item;
      }
    }
    return null;
  }

  Collection<T> take(int count) {
    if (count <= 0) {
      return Collection<T>([]);
    }
    return Collection<T>(items.take(count).toList());
  }

  Collection<T> skip(int count) {
    if (count <= 0) {
      return Collection<T>(items);
    }
    return Collection<T>(items.skip(count).toList());
  }

  bool contains(T element) {
    return items.contains(element);
  }

  Collection shuffle() {
    items.shuffle();
    return this;
  }

  int count() {
    return this.items.length;
  }
}
