import 'package:ditredi/ditredi.dart';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';

/// A polyline containing a [List] of [Line3].
class PolyLine3 {
  /// Intermediate lines.
  final List<Line3> lines;

  /// Creates a polyline.
  PolyLine3(this.lines);

  /// Gets first point of the polyline.
  Vector3 get start => lines.first.a;

  /// Gets last point of the polyline.
  Vector3 get stop => lines.last.b;

  @override
  int get hashCode => Object.hashAll(lines);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PolyLine3 &&
            runtimeType == other.runtimeType &&
            listEquals(lines, other.lines);
  }
}
