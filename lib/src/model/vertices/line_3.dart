import 'package:vector_math/vector_math_64.dart';

class Line3 {
  final Vector3 a;
  final Vector3 b;

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
