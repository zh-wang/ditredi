import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

/// A plane with list of points.
/// Used often to present a scale.
class PointPlane3D extends Group3D {
  /// Facing axis (x to left/right, y to up/down, z to far/near).
  final Axis3D axis;

  /// Size of the plane.
  final double size;

  /// Gap between points.
  final double gap;

  /// Center of the plane.
  final Vector3 position;

  /// Color of the plane. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Width of points. Defaults to [DiTreDiConfig] setting.
  final double? pointWidth;

  /// Creates a new [PointPlane3D].
  PointPlane3D(
    this.size,
    this.axis,
    this.gap,
    this.position, {
    this.color,
    this.pointWidth,
  }) : super(_generateFigures(size, gap, axis, position, color, pointWidth));

  /// Copies the plane.
  PointPlane3D copyWith({
    Axis3D? axis,
    double? size,
    double? gap,
    Vector3? position,
    Color? color,
    double? pointWidth,
  }) {
    return PointPlane3D(
      size ?? this.size,
      axis ?? this.axis,
      gap ?? this.gap,
      position ?? this.position,
      color: color ?? this.color,
      pointWidth: pointWidth ?? this.pointWidth,
    );
  }

  @override
  PointPlane3D clone() {
    return PointPlane3D(
      size,
      axis,
      gap,
      position,
      color: color,
      pointWidth: pointWidth,
    );
  }

  @override
  int get hashCode => Object.hash(size, axis, gap, position, color, pointWidth);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PointPlane3D &&
            runtimeType == other.runtimeType &&
            size == other.size &&
            axis == other.axis &&
            gap == other.gap &&
            position == other.position &&
            color == other.color &&
            pointWidth == other.pointWidth;
  }
}

List<Model3D<Model3D<dynamic>>> _generateFigures(double size, double gap,
    Axis3D axis, Vector3 position, Color? color, double? thickness) {
  if (gap == 0) return [];
  final count = (size / gap).ceil();
  return List.generate(count * count, (index) {
    final row = index % count;
    final column = index ~/ count;
    final dx = -size / 2 + row * gap;
    final dy = -size / 2 + column * gap;
    switch (axis) {
      case Axis3D.x:
        return Point3D(
          Vector3(
            position.x,
            position.y + dy,
            position.z + dx,
          ),
          width: thickness,
          color: color,
        );
      case Axis3D.y:
        return Point3D(
          Vector3(
            position.x + dx,
            position.y,
            position.z + dy,
          ),
          width: thickness,
          color: color,
        );
      case Axis3D.z:
        return Point3D(
          Vector3(
            position.x + dx,
            position.y + dy,
            position.z,
          ),
          width: thickness,
          color: color,
        );
    }
  });
}
