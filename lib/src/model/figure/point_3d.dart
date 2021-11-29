import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/point_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

/// A point.
class Point3D with Point3DPainter implements Model3D<Point3D> {
  /// Position of the point.
  final Vector3 position;

  /// Width of the point.
  final double? width;

  /// Color of the point. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Creates a point.
  Point3D(this.position, {this.width, this.color});

  @override
  int verticesCount() {
    return 6;
  }

  @override
  Point3D clone() {
    return Point3D(position.clone(), width: width, color: color);
  }

  /// Copies the point.
  Point3D copyWith({Vector3? position, double? width, Color? color}) {
    return Point3D(
      position ?? this.position,
      width: width ?? this.width,
      color: color ?? this.color,
    );
  }

  @override
  List<Line3D> toLines() {
    return [];
  }

  @override
  List<Point3D> toPoints() => [this];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Point3D &&
            runtimeType == other.runtimeType &&
            position == other.position &&
            width == other.width &&
            color == other.color;
  }

  @override
  int get hashCode => Object.hash(position, width, color);

  @override
  Aabb3 getBounds() {
    return Aabb3.minMax(position, position);
  }
}
