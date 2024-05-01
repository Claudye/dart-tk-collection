# Utils collection toolkit

### all
Get all the items in the collection, after some modification/operation
```dart
collection.push(1).push(2);
collection.all()
```
### sort
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

### pluck

### push

### add 

### remove

### filter

### every

### some

### sortByDesc