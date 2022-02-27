import 'dart:math';
import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/line_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

/// A 3D line.
class Line3D with Line3DPainter implements Model3D<Line3D> {
  /// Start point.
  final Vector3 a;

  /// End point.
  final Vector3 b;

  /// Width of the line. Defaults to [DiTreDiConfig] setting.
  final double? width;

  /// Color of the line. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Creates a new line.
  Line3D(this.a, this.b, {this.width, this.color});

  @override
  int verticesCount() {
    return 6;
  }

  @override
  Line3D clone() {
    return Line3D(a.clone(), b.clone(), width: width, color: color);
  }

  /// Copies the line.
  Line3D copyWith({
    Vector3? a,
    Vector3? b,
    double? width,
    Color? color,
  }) {
    return Line3D(
      a ?? this.a,
      b ?? this.b,
      width: width ?? this.width,
      color: color ?? this.color,
    );
  }

  @override
  List<Line3D> toLines() => [this];

  @override
  List<Point3D> toPoints() {
    return [
      Point3D(a, color: color),
      Point3D(b, color: color),
    ];
  }

  @override
  Aabb3 getBounds() {
    return Aabb3.minMax(
        Vector3(
          min(a.x, b.x),
          min(a.y, b.y),
          min(a.z, b.z),
        ),
        Vector3(
          max(a.x, b.x),
          max(a.y, b.y),
          max(a.z, b.z),
        ));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return identical(this, other) ||
        other is Line3D &&
            runtimeType == other.runtimeType &&
            other.a == a &&
            other.b == b &&
            other.width == width &&
            other.color == color;
  }

  @override
  int get hashCode => Object.hashAll([a, b, width ?? -1, color?.value ?? -1]);
}
