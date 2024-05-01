# Utils collection toolkit

### all
Get all the items in the collection, after some modification/operation
```dart
collection.push(1).push(2);
collection.all()
```
### pluck

Extracts a list of values corresponding to a specified key from each item in the collection.

- **Usage**: Use `pluck` to retrieve values of a specific attribute/key from each item in the collection.
- **How to Use**: Call `pluck` on the collection and provide the attribute/key name as a string.
- **Example**:
  ```dart
  Collection collection = Collection([
    {'name': 'Alice', 'age': 20},
    {'name': 'Bob', 'age': 23,'notes':[{'english':20,'french':4},{'french':20,'english':7}]}
  ]);
  
  // Extract 'age' attribute from each item
  var ages = collection.pluck<int>('age');

   // Extract 'age' attribute from each item
  var ages = collection.pluck<int>('notes.1.english'); // 7
  ```
- **Returns**: Returns a new collection containing the extracted values of the specified attribute/key from each item.

This method is useful for extracting specific data attributes from a collection for further processing or analysis.
 
### sort

Sorts the collection's items based on the provided criteria.

- **Usage**: Use `sort` to arrange items either by a specific attribute/key or by a custom sorting function.
- **How to Use**: Call `sort` on the collection and provide either a string representing the attribute to sort by or a custom sorting function.
- **Example**:
  ```dart
    // for nested object/map in the collection
    collection.sort('notes.courses.dart'); 
    // Sort by the first element of list notes
    collection.sort('notes.0');
    // sort by custum callback
    collection.sort<int>((a, b) => a['age'] - b['age']);
  ```
- **Returns**: Returns the sorted collection.

This method is useful for organizing data in ascending order based on a specific attribute or applying custom sorting logic to the collection.


### where

### sum

### avg

### min

### max

### count

### push

### add 

### remove

### filter

### every

### some

### sortByDesc