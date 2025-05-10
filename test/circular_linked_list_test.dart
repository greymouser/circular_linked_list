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

import 'package:circular_linked_list/circular_linked_list.dart';
import 'package:test/test.dart';

final class StringEntry with CircularLinkedListEntry<StringEntry> {
  String value;

  StringEntry(this.value);
}

void main() {
  group('CircularLinkedList', () {
    late CircularLinkedList<StringEntry> list;

    setUp(() {
      list = CircularLinkedList<StringEntry>();
    });

    test('add and length', () {
      list.add(StringEntry('A'));
      list.add(StringEntry('B'));
      list.add(StringEntry('C'));
      expect(list.length, 3);
    });

    test('addAll', () {
      list.addAll([StringEntry('X'), StringEntry('Y'), StringEntry('Z')]);
      expect(list.length, 3);
      expect(list.map((e) => e.value).toList(), ['X', 'Y', 'Z']);
    });

    test('contains', () {
      var a = StringEntry('A');
      var b = StringEntry('B');
      list.add(a);
      list.add(b);
      expect(list.contains(a), isTrue);
      expect(list.contains(b), isTrue);
    });

    test('forEach', () {
      list.add(StringEntry('1'));
      list.add(StringEntry('2'));
      list.add(StringEntry('3'));
      var collected = '';
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach((e) => collected += e.value);
      expect(collected, '123');
    });

    test('insertAfter and insertBefore', () {
      var a = StringEntry('A');
      var b = StringEntry('B');
      var c = StringEntry('C');
      list.add(a);
      list.add(c);
      a.insertAfter(b);
      expect(list.map((e) => e.value).toList(), ['A', 'B', 'C']);

      var x = StringEntry('X');
      c.insertBefore(x);
      expect(list.map((e) => e.value).toList(), ['A', 'B', 'X', 'C']);
    });

    test('unlink and remove', () {
      var a = StringEntry('A');
      var b = StringEntry('B');
      var c = StringEntry('C');
      list.add(a);
      list.add(b);
      list.add(c);

      expect(list.remove(b), isTrue);
      expect(list.length, 2);
      expect(list.map((e) => e.value).toList(), ['A', 'C']);

      a.unlink();
      expect(list.length, 1);
      expect(list.map((e) => e.value).toList(), ['C']);
    });

    test('clear', () {
      list.add(StringEntry('X'));
      list.add(StringEntry('Y'));
      list.clear();
      expect(list.isEmpty, isTrue);
      expect(list.length, 0);
    });

    test('iterate over circular structure', () {
      list.add(StringEntry('A'));
      list.add(StringEntry('B'));
      list.add(StringEntry('C'));
      var result = '';
      for (var entry in list) {
        result += entry.value;
      }
      expect(result, 'ABC');
    });

    test('single item points to itself', () {
      var solo = StringEntry('Solo');
      list.add(solo);
      expect(solo.next, solo);
      expect(solo.previous, solo);
    });
  });

  group('CircularLinkedList with setToHead', () {
    late CircularLinkedList<StringEntry> list;

    setUp(() {
      list = CircularLinkedList<StringEntry>();
    });

    test('add and setToHead', () {
      var a = StringEntry('A');
      var b = StringEntry('B');
      var c = StringEntry('C');
      list.add(a);
      list.add(b);
      list.add(c);

      expect(list.map((e) => e.value).toList(), ['A', 'B', 'C']);

      b.setToHead();
      expect(list.first.value, 'B');
      expect(list.map((e) => e.value).toList(), ['B', 'C', 'A']);

      c.setToHead();
      expect(list.first.value, 'C');
      expect(list.map((e) => e.value).toList(), ['C', 'A', 'B']);
    });

    test('setToHead with single node', () {
      var solo = StringEntry('Solo');
      list.add(solo);
      solo.setToHead();
      expect(list.first.value, 'Solo');
      expect(list.length, 1);
      expect(solo.next, solo);
      expect(solo.previous, solo);
    });

    test('setToHead after unlinking others', () {
      var a = StringEntry('A');
      var b = StringEntry('B');
      var c = StringEntry('C');
      list.add(a);
      list.add(b);
      list.add(c);
      a.unlink();
      b.setToHead();
      expect(list.first.value, 'B');
      expect(list.map((e) => e.value).toList(), ['B', 'C']);
    });
  });

  group('CircularLinkedList iterate() tests', () {
    late CircularLinkedList<StringEntry> list;

    setUp(() {
      list = CircularLinkedList<StringEntry>();
      list.add(StringEntry('A'));
      list.add(StringEntry('B'));
      list.add(StringEntry('C'));
    });

    test('iterate over exact length', () {
      var result = list.iterate(count: 3).map((e) => e.value).join();
      expect(result, 'ABC');
    });

    test('iterate over more than length', () {
      var result = list.iterate(count: 7).map((e) => e.value).join();
      expect(result, 'ABCABCA');
    });

    test('iterate with count zero', () {
      var result = list.iterate(count: 0).map((e) => e.value).join();
      expect(result, '');
    });

    test('iterate on empty list', () {
      var emptyList = CircularLinkedList<StringEntry>();
      var result = emptyList.iterate(count: 5).map((e) => e.value).join();
      expect(result, '');
    });

    test('iterate single-item list repeatedly', () {
      var singleList = CircularLinkedList<StringEntry>();
      singleList.add(StringEntry('X'));
      var result = singleList.iterate(count: 4).map((e) => e.value).join();
      expect(result, 'XXXX');
    });
  });
}
