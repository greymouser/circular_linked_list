# CircularLinkedList Package

A lightweight and flexible Dart package providing a circular doubly-linked list with advanced entry-level controls. This package is useful for developers who need efficient insertion, deletion, and traversal operations in a circular data structure.

## Features

- Circular doubly-linked list structure
- Entry-level operations: insertBefore, insertAfter, unlink
- Iterable support for easy Dart `for` loops
- Dynamic head reassignment with `setToHead`
- Custom iterator and length tracking

## Getting started

Add the package to your `pubspec.yaml` (if publishing), or include the source files in your project. No external dependencies required.

## Usage

```dart
final class StringEntry with CircularLinkedListEntry<StringEntry> {
  String value;
  StringEntry(this.value);
}

final list = CircularLinkedList<StringEntry>();

// Add entries
list.add(StringEntry('A'));
list.add(StringEntry('B'));
list.add(StringEntry('C'));

// Iterate over the list
for (var entry in list) {
  print(entry.value);
}

// Move an entry to head
var b = list.firstWhere((e) => e.value == 'B');
b.setToHead();

// Insert after
b.insertAfter(StringEntry('B1'));

// Insert before
var c = list.firstWhere((e) => e.value == 'C');
c.insertBefore(StringEntry('X'));

// Remove an entry
var a = list.firstWhere((e) => e.value == 'A');
list.remove(a);

// Clear the list
list.clear();
```

## Additional information

- For full tests and example usage, see the `test/` folder.
- Contributions and pull requests are welcome!
- Please report issues or feature requests on the project repository.
- Maintained by the package author Armando DiCianno <armando@noonshy.com>
