/*
MIT License

Copyright (c) 2025 Armando DiCianno <armando@noonshy.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:circular_linked_list/circular_linked_list.dart';
// Example usage of CircularLinkedList

final class StringEntry with CircularLinkedListEntry<StringEntry> {
  String value;

  StringEntry(this.value);

  @override
  String toString() => value;
}

void main() {
  final list = CircularLinkedList<StringEntry>();

  // Add entries
  list.add(StringEntry('A'));
  list.add(StringEntry('B'));
  list.add(StringEntry('C'));
  print('After adding A, B, C:');
  list.forEach((e) => print(e));

  // Set 'B' as head
  var b = list.firstWhere((e) => e.value == 'B');
  b.setToHead();
  print('\nAfter setting B as head:');
  list.forEach((e) => print(e));

  // Insert after
  b.insertAfter(StringEntry('B1'));
  print('\nAfter inserting B1 after B:');
  list.forEach((e) => print(e));

  // Insert before
  var c = list.firstWhere((e) => e.value == 'C');
  c.insertBefore(StringEntry('X'));
  print('\nAfter inserting X before C:');
  list.forEach((e) => print(e));

  // Remove an entry
  var a = list.firstWhere((e) => e.value == 'A');
  list.remove(a);
  print('\nAfter removing A:');
  list.forEach((e) => print(e));

  // Iterate with for-in
  print('\nIterating with for-in:');
  for (var entry in list) {
    print(entry);
  }

  // Convert to list
  var asList = list.map((e) => e.value).toList();
  print('\nAs Dart List: $asList');

  // Iterate over the circle greater than the length of items in it
  print('\nIterating for a 10-count over the circular list:');
  var count = 1;
  for (var entry in list.iterate(count: 10)) {
    print('$count. ${entry.value}');
    count++;
  }

  // Clear the list
  list.clear();
  print('\nAfter clearing, is list empty? ${list.isEmpty}');
}
