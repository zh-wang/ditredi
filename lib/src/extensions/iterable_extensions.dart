/// Exensions for list operations.
extension WindowedList<E> on List<E> {
  /// Groups the elements in the list into a list of lists, each of the same [windowSize].
  List<List<E>> windowed(int windowSize) {
    final result = List<List<E>>.empty(growable: true);
    for (var i = 0; i < length; i += windowSize) {
      result.add(getRange(i, i + windowSize).toList());
    }
    return result;
  }

  /// Groups the elements in the list into a list of lists, each of the same [size],
  /// moving iterator by [step].
  Iterable<Iterable<E>> windowedWithStep(int size, int step,
      {bool partialWindows = false}) sync* {
    for (var i = 0; i < length - 1; i += step) {
      if (partialWindows) {
        yield getRange(i, i + size);
      } else {
        if (i + size <= length) {
          yield getRange(i, i + size);
        }
      }
    }
  }
}

/// Iterable extensions.
extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  /// Calls [f] for each element in the iterable.
  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    for (var e in this) {
      f(e, i++);
    }
  }

  /// Returns a sorted iterable of elements list.
  Iterable<E> sorted([int Function(E a, E b)? compare]) {
    return toList()..sort(compare);
  }
}

/// Extension for [Iterable] of [Iterable]s.
extension FlattenIterable<E> on Iterable<Iterable<E>> {
  /// Flattens the iterable of iterables into single iterable.
  Iterable<E> flatten() sync* {
    for (var i in this) {
      yield* i;
    }
  }
}
