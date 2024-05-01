import 'package:as_collection/u_collection.dart';
import 'package:test/test.dart';

void main() {
  const mapList = [
    {
      'name': 'Alice',
      'age': 20,
      'notes': {'english': 20, 'french': 18},
      'username': 'alice',
      'hobbies': ['football', 'music'],
      'votes': [
        {'post': 22, 'comments': 50, 'interraction': 10}
      ]
    },
    {
      'name': 'Caroline',
      'age': 30,
      'notes': {'english': 17, 'french': 16},
      'username': 'caroline99',
      'hobbies': ['painting', 'gardening'],
      'votes': [
        {'post': 18, 'comments': 40, 'interraction': 8}
      ]
    },
    {
      'name': 'David',
      'age': 20,
      'notes': {'english': 20, 'french': 13},
      'username': 'david22',
      'hobbies': ['photography', 'cooking'],
      'votes': [
        {'post': 22, 'comments': 60, 'interraction': 12}
      ]
    },
    {
      'name': 'Emily',
      'age': 27,
      'notes': {'english': 14, 'french': 18},
      'username': 'emily_art',
      'hobbies': ['drawing', 'writing'],
      'votes': [
        {'post': 17, 'comments': 35, 'interraction': 7}
      ]
    }
  ];
  group('Test the all() methods', () {
    final Collection collection = Collection([]);

    test('Test empty array', () {
      expect(collection.all(), []);
    });
    test('Test empty null', () {
      expect(collection.all(), []);
    });
  });

//Push method
  group("Test the push() method", () {
    final Collection collection = Collection<int>([0]);
    test('Test push', () {
      collection.push(1).push(2);
      expect(collection.all(), [0, 1, 2]);
    });
  });

  //Remove method
  group("Test the remove() method", () {
    final Collection collection = Collection<int>([3, 16, 2]);
    test('Test remove', () {
      collection.remove(1);
      expect(collection.all(), [3, 2]);
    });
  });

  group("Test the map() method", () {
    Collection collection2 = Collection<int>([3, 16, 2]);
    test('map', () {
      collection2 = collection2.map((x) => x * 2);
      expect(collection2.all(), [6, 32, 4]);
    });
  });

  group("Test the pluck() method", () {
    Collection collection = Collection<Map>([
      {
        'name': 'Alice',
        'age': 20,
        'notes': {'english': 20, 'french': 18}
      },
      {
        'name': 'Bob',
        'age': 23,
        'notes': {'english': 18, 'french': 18}
      }
    ]);
    test('pluck', () {
      collection = collection.pluck('notes.english');
      expect(collection.all(), [20, 18]);
    });
  });

  group("Test the sort() method", () {
    Collection collection = Collection<Map>([
      {
        'name': 'Alice',
        'age': 20,
        'notes': {'english': 20, 'french': 18}
      },
      {
        'name': 'Bob',
        'age': 23,
        'notes': {'english': 12, 'french': 20}
      },
      {
        'name': 'Marc',
        'age': 18,
        'notes': {'english': 15, 'french': 17}
      }
    ]);
    test('sort for string selector', () {
      collection = collection.sort('notes.english').pluck("notes.english");
      expect(collection.all(), [12, 15, 20]);
    });

    test('sort for string function', () {
      Collection collection = Collection<Map<String, int>>([
        {'vote': 20},
        {'vote': 10},
        {'vote': 12},
      ]);

      collection.sort<int Function(Map<String, int>, Map<String, int>)>((x, y) {
        var xv = x['vote'] as int;
        var yv = y['vote'] as int;
        return xv - yv;
      });

      expect(collection.all(), [
        {'vote': 10},
        {'vote': 12},
        {'vote': 20},
      ]);
    });
  });

  group("Test reverse", () {
    test('reverse', () {
      Collection collection = Collection<int>([1, 2, 3, 4, 5]);
      collection.reverse();
      expect(collection.all(), [5, 4, 3, 2, 1]);
    });
  });

  group("Test sortByDesc", () {
    test('sortByDesc', () {
      Collection collection = Collection<int>([1, 2, 3, 5, 4]).sortByDesc();
      expect(collection.all(), [5, 4, 3, 2, 1]);
    });
  });

  group("Test every()", () {
    Collection collection = Collection<int>([1, 2, 3, 5, 4]).sortByDesc();
    test("Test the collection has'nt not a null value", () {
      expect(collection.every(), isTrue);
    });

    test("Should return true if the collect has not null value", () {
      Collection collection = Collection<Map>([
        {'age': 20},
        {'age': 30},
        {'age': 12},
      ]);
      expect(collection.every(), isTrue);
    });

    test("Should return true if the collect has not null value", () {
      Collection collection = Collection<Map>([
        {'age': 20},
        {'age': 30},
        {'age': 12},
      ]);
      expect(collection.every("age"), isTrue);
    });

    test("Should return false if the collect has not null value", () {
      Collection collection = Collection<Map>([
        {'age': 20},
        {'age': 30},
        {'age': null},
      ]);
      expect(collection.every("age"), isFalse);
    });
  });

  group("Test filter function", () {
    Collection collection = Collection<int>([1, 2, 3, 5, 4]);
    test("Should return a valid filterd value", () {
      expect(collection.filter((x) => x % 2 == 0).all(), [2, 4]);
    });

    test("Should return valid map value", () {
      Collection collection = Collection<Map>([
        {'age': 20},
        {'age': 30},
        {'age': 12},
      ]);
      expect(collection.filter((x) => x['age'] == 20).all(), [
        {'age': 20},
      ]);
    });
  });

  group('Collection where tests', () {
    test('filters by callback function', () {
      final data = [1, 2, 3, 4, 5];
      final collection = Collection(data);

      final evenNumbers = collection.where((item) => item % 2 == 0);

      expect(evenNumbers.all(), [2, 4]);
    });

    test('filters by key (equal operator)', () {
      final data = [
        {'name': 'Alice', 'age': 30, 'city': 'New York'},
        {'age': 10}
      ];
      final collection = Collection(data);

      final ageFilter = collection.where('age', "<", 30);

      expect(ageFilter.all(), [
        {'age': 10}
      ]);
    });

    test('filters by key with operator (not equal)', () {
      final data = {'name': 'Alice', 'age': 30, 'city': 'New York'};
      final collection = Collection([data]);

      final notAlice = collection.where('name', '!=', 'Alice');

      expect(notAlice.all(), []);
    });

    test('filters by key with two parameters', () {
      final data = [
        {'name': 'Alice', 'age': 30, 'city': 'New York'},
        {'age': 10}
      ];

      final collection = Collection(data);

      final notAlice = collection.where('age', 10);

      expect(notAlice.all(), [
        {'age': 10}
      ]);
    });
    test('filters by key with operator (like)', () {
      final data = [
        {'name': 'Alice'},
        {'name': 'Bob'},
        {'name': 'Charlie'}
      ];
      final collection = Collection(data);

      final likeAlice = collection.where('name', 'like', 'Alice');

      expect(likeAlice.all(), [
        {'name': 'Alice'}
      ]);
    });
  });

  group("Test the groupBy", () {
    test("", () {
      var collection = Collection(mapList);
      var first = collection.groupBy<String>("votes.0.post").first();
      expect(first, {
        22: [
          {
            'name': 'Alice',
            'age': 20,
            'notes': {'english': 20, 'french': 18},
            'username': 'alice',
            'hobbies': ['football', 'music'],
            'votes': [
              {'post': 22, 'comments': 50, 'interraction': 10}
            ]
          },
          {
            'name': 'David',
            'age': 20,
            'notes': {'english': 20, 'french': 13},
            'username': 'david22',
            'hobbies': ['photography', 'cooking'],
            'votes': [
              {'post': 22, 'comments': 60, 'interraction': 12}
            ]
          }
        ]
      });
    });
  });

  group('Test the when method', () {
    test("Should do something in some condition", () {
      var collection = Collection(mapList);
      var actual = collection.when(true, (collection) {
        collection.where('name', "David");
      }).all();

      expect(actual, [
        {
          'name': 'David',
          'age': 20,
          'notes': {'english': 20, 'french': 13},
          'username': 'david22',
          'hobbies': ['photography', 'cooking'],
          'votes': [
            {'post': 22, 'comments': 60, 'interraction': 12}
          ]
        }
      ]);
    });
  });

  group('Collection sum method', () {
    test('should return sum of numeric values for a given key', () {
      final collection = Collection([
        {'value': 10},
        {'value': 20},
        {'value': 30},
      ]);

      expect(collection.sum('value'), equals(60));
    });

    test('should return 0 if the key does not exist', () {
      final collection = Collection([
        {'value': 10},
        {'value': 20},
        {'value': 30},
      ]);

      expect(collection.sum('nonExistentKey'), equals(0));
    });

    test('should return sum of values returned by the function', () {
      final collection = Collection([
        {'value': 10},
        {'value': 20},
        {'value': 30},
      ]);

      expect(collection.sum((item) => (item['value'] as int) * 2), equals(120));
    });

    test('should return 0 if the function returns a non-numeric value', () {
      final collection = Collection([
        {'value': 10},
        {'value': 20},
        {'value': 30},
      ]);

      expect(collection.sum((item) => item['nonExistentKey']), equals(0));
    });

    test('should return the sum if every item is  number', () {
      final collection = Collection([1, 2, 3, 4]);
      expect(collection.sum(), equals(10));
    });

    test('should return the sum of only number element if the arg is empty',
        () {
      final collection = Collection([1, 2, 3, 4, "foo"]);
      expect(collection.sum(), equals(10));
    });
  });

  group('Collection', () {
    test('avg should return the average of numeric values in the collection',
        () {
      // Arrange
      var collection = Collection([1, 2, 3, 4, 5]);

      // Act
      var average = collection.avg();

      // Assert
      expect(average, equals(3));
    });

    test('avg should return 0 if the collection is empty', () {
      // Arrange
      var collection = Collection([]);

      // Act
      var average = collection.avg();

      // Assert
      expect(average, equals(0));
    });

    test('avg should calculate the average based on a specified property', () {
      // Arrange
      var collection = Collection([
        {'value': 1},
        {'value': 2},
        {'value': 3},
        {'value': 4},
        {'value': 5},
      ]);

      // Act
      var average = collection.avg('value');

      // Assert
      expect(average, equals(3));
    });

    test('avg should return 0 if no numeric values are found in the collection',
        () {
      // Arrange
      var collection = Collection(['a', 'b', 'c']);

      // Act
      var average = collection.avg();

      // Assert
      expect(average, equals(0));
    });
  });

  group('Collection min method tests:', () {
    test('Min of a collection of integers', () {
      var collection = Collection([1, 5, 3, 2, 4]);
      expect(collection.min(), equals(1));
    });

    test('Min of a collection of doubles', () {
      var collection = Collection([1.5, 2.3, 0.8, 3.1]);
      expect(collection.min(), equals(0.8));
    });

    test('Min of an empty collection', () {
      var collection = Collection([]);
      expect(collection.min(), null);
    });
  });

  test('Chunk method should split the collection into chunks of the given size',
      () {
    var collection = Collection([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

    // Test chunk size 2
    var chunkedCollection = collection.chunk(2);
    expect(
        chunkedCollection.all(),
        equals([
          [1, 2],
          [3, 4],
          [5, 6],
          [7, 8],
          [9, 10]
        ]));

    // Test chunk size 3
    chunkedCollection = collection.chunk(3);
    expect(
        chunkedCollection.all(),
        equals([
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
          [10]
        ]));

    // Test chunk size 4
    chunkedCollection = collection.chunk(4);
    expect(
        chunkedCollection.all(),
        equals([
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 10]
        ]));

    // Test chunk size larger than collection size
    chunkedCollection = collection.chunk(12);
    expect(
        chunkedCollection.all(),
        equals([
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        ]));

    // Test chunk size 1
    chunkedCollection = collection.chunk(1);
    expect(
        chunkedCollection.all(),
        equals([
          [1],
          [2],
          [3],
          [4],
          [5],
          [6],
          [7],
          [8],
          [9],
          [10]
        ]));
  });

  test('Chunk method should throw ArgumentError for invalid chunk sizes', () {
    var collection = Collection([1, 2, 3, 4, 5]);

    // Test chunk size 0
    expect(() => collection.chunk(0), throwsArgumentError);

    // Test negative chunk size
    expect(() => collection.chunk(-1), throwsArgumentError);
  });

  group('Collection - firstWhere method', () {
    test('Finding the first even number in a list', () {
      var collection = Collection<int>([1, 2, 3, 4, 5]);
      var result = collection.firstWhere((item) => item % 2 == 0);
      expect(result, equals(2));
    });

    test('Finding the first string starting with "a"', () {
      var collection = Collection<String>(['apple', 'banana', 'orange']);
      var result = collection.firstWhere((item) => item.startsWith('a'));
      expect(result, equals('apple'));
    });

    test('Finding the first element that is null', () {
      var collection = Collection<int?>([null, 1, 2, 3]);
      var result = collection.firstWhere((item) => item == null);
      expect(result, isNull);
    });

    test('Finding the first element in an empty list', () {
      var collection = Collection<int>([]);
      var result = collection.firstWhere((item) => item == 1);
      expect(result, isNull);
    });
  });

  group('Collection - take and skip methods', () {
    test('Taking elements from the beginning of the collection', () {
      var collection = Collection<int>([1, 2, 3, 4, 5]);
      var taken = collection.take(3);
      expect(taken.all(), equals([1, 2, 3]));
    });

    test('Taking zero elements from the collection', () {
      var collection = Collection<int>([1, 2, 3, 4, 5]);
      var taken = collection.take(0);
      expect(taken.all(), equals([]));
    });

    test('Skipping elements from the beginning of the collection', () {
      var collection = Collection<int>([1, 2, 3, 4, 5]);
      var skipped = collection.skip(2);
      expect(skipped.all(), equals([3, 4, 5]));
    });

    test('Skipping zero elements from the collection', () {
      var collection = Collection<int>([1, 2, 3, 4, 5]);
      var skipped = collection.skip(0);
      expect(skipped.all(), equals([1, 2, 3, 4, 5]));
    });
  });
  group('Collection - contains method', () {
    test('Checking if the collection contains a specific element', () {
      var collection = Collection<int>([1, 2, 3, 4, 5]);

      expect(collection.contains(3),
          equals(true)); // Check if 3 is in the collection
      expect(collection.contains(6),
          equals(false)); // Check if 6 is in the collection
    });
  });

  group('Collection - join method', () {
    test('Joining elements of the collection with a separator', () {
      var collection = Collection<String>(['apple', 'banana', 'orange']);

      expect(
          collection.join(', '),
          equals(
              'apple, banana, orange')); // Join with comma and space separator
      expect(collection.join('-'),
          equals('apple-banana-orange')); // Join with dash separator
    });
  });
}
