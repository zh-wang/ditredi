import 'package:vector_math/vector_math_64.dart';

/// Line in 3D space.
class Line3 {
  /// Start point of the line.
  final Vector3 a;

  /// End point of the line.
  final Vector3 b;

  /// Creates a new line.
  Line3(this.a, this.b);

  @override
  int get hashCode => Object.hash(a, b);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Line3 &&
            runtimeType == other.runtimeType &&
            a == other.a &&
            b == other.b;
  }
}
