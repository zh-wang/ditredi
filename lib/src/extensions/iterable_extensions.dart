extension WindowedList<E> on List<E> {
  List<List<E>> windowed(int windowSize) {
    final result = List<List<E>>.empty(growable: true);
    for (var i = 0; i < length; i += windowSize) {
      result.add(getRange(i, i + windowSize).toList());
    }
    return result;
  }

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

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }

  Iterable<E> sorted([int Function(E a, E b)? compare]) {
    return toList()..sort(compare);
  }
}

extension FlattenIterable<E> on Iterable<Iterable<E>> {
  Iterable<E> flatten() sync* {
    for (var i in this) {
      yield* i;
    }
  }
}
