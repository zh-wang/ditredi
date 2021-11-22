import 'package:ditredi/ditredi.dart';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';

class PolyLine3 {
  final List<Line3> lines;

  PolyLine3(this.lines);

  Vector3 get start => lines.first.a;

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
