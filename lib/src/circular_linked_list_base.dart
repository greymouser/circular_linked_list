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

abstract base mixin class CircularLinkedListEntry<
  E extends CircularLinkedListEntry<E>
> {
  E? next;
  E? previous;
  CircularLinkedList<E>? list;

  E get self => this as E;

  void insertAfter(E newEntry) {
    newEntry.list = list;
    newEntry.previous = self;
    newEntry.next = next;
    next?.previous = newEntry;
    next = newEntry;
    list?._length++;
  }

  void insertBefore(E newEntry) {
    newEntry.list = list;
    newEntry.next = self;
    newEntry.previous = previous;
    previous?.next = newEntry;
    previous = newEntry;
    if (list?._head == self) {
      list?._head = newEntry;
    }
    list?._length++;
  }

  void unlink() {
    previous?.next = next;
    next?.previous = previous;
    if (list?._head == this) {
      list?._head = next == this ? null : next;
    }
    list?._length--;
    list = null;
    next = null;
    previous = null;
  }

  void setToHead() {
    if (list != null) {
      list!._head = self;
    }
  }
}

base class CircularLinkedList<E extends CircularLinkedListEntry<E>>
    extends Iterable<E> {
  E? _head;
  int _length = 0;

  void add(E entry) {
    entry.list = this;
    if (_head == null) {
      entry.next = entry;
      entry.previous = entry;
      _head = entry;
    } else {
      final tail = _head!.previous!;
      tail.next = entry;
      entry.previous = tail;
      entry.next = _head;
      _head!.previous = entry;
    }
    _length++;
  }

  void addAll(Iterable<E> entries) {
    for (var entry in entries) {
      add(entry);
    }
  }

  void clear() {
    _head = null;
    _length = 0;
  }

  bool remove(E entry) {
    if (entry.list != this) return false;
    entry.unlink();
    return true;
  }

  @override
  bool contains(Object? element) {
    for (var item in this) {
      if (item == element) return true;
    }
    return false;
  }

  @override
  void forEach(void Function(E element) action) {
    for (var item in this) {
      action(item);
    }
  }

  /// Iterate over the list for a specified number of steps (even if greater than length)
  Iterable<E> iterate({required int count}) sync* {
    if (_head == null || count <= 0) return;
    var node = _head;
    for (var i = 0; i < count; i++) {
      yield node!;
      node = node.next;
    }
  }

  @override
  Iterator<E> get iterator =>
      _head == null
          ? <E>[].iterator
          : _CircularLinkedListIterator(_head!, _length);

  @override
  int get length => _length;

  @override
  bool get isEmpty => _length == 0;
}

class _CircularLinkedListIterator<E extends CircularLinkedListEntry<E>>
    implements Iterator<E> {
  final E _startNode;
  final int _count;
  int _visited = 0;
  E? _currentNode;

  _CircularLinkedListIterator(this._startNode, this._count);

  @override
  E get current => _currentNode!;

  @override
  bool moveNext() {
    if (_visited >= _count) return false;

    if (_currentNode == null) {
      _currentNode = _startNode;
    } else {
      _currentNode = _currentNode!.next as E;
    }

    _visited++;
    return true;
  }
}
