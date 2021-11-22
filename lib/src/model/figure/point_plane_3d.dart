import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

class PointPlane3D extends Group3D {
  final Axis3D axis;
  final double size;
  final double gap;
  final Vector3 position;
  final Color? color;
  final double? pointWidth;

  PointPlane3D(
    this.size,
    this.axis,
    this.gap,
    this.position, {
    this.color,
    this.pointWidth,
  }) : super(_generateFigures(size, gap, axis, position, color, pointWidth));

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
