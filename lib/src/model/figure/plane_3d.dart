import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

class Plane3D extends Group3D {
  final Axis3D axis;
  final bool negative;
  final double size;
  final Vector3 position;
  final Color? color;

  Plane3D(this.size, this.axis, this.negative, this.position, {this.color})
      : super(_getFigures(size, axis, negative, position, color));

  @override
  Plane3D clone() {
    return Plane3D(size, axis, negative, position, color: color);
  }

  @override
  int get hashCode => Object.hash(axis, negative, size, position, color);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Plane3D &&
            runtimeType == other.runtimeType &&
            other.axis == axis &&
            other.negative == negative &&
            other.size == size &&
            other.position == position &&
            other.color == color;
  }
}

List<Model3D> _getFigures(
    double size, Axis3D axis, bool negative, Vector3 position, Color? color) {
  switch (axis) {
    case Axis3D.x:
      if (negative) {
        return [
          Face3D(
            Triangle.points(
                Vector3(position.x, position.y + size, position.z + size),
                Vector3(position.x, position.y + -size, position.z + size),
                Vector3(position.x, position.y + -size, position.z + -size)),
            color: color,
          ),
          Face3D(
            Triangle.points(
                Vector3(position.x, position.y + -size, position.z + -size),
                Vector3(position.x, position.y + size, position.z + -size),
                Vector3(position.x, position.y + size, position.z + size)),
            color: color,
          ),
        ];
      } else {
        return [
          Face3D(
            Triangle.points(
                Vector3(position.x, position.y + -size, position.z + -size),
                Vector3(position.x, position.y + -size, position.z + size),
                Vector3(position.x, position.y + size, position.z + size)),
            color: color,
          ),
          Face3D(
            Triangle.points(
                Vector3(position.x, position.y + size, position.z + size),
                Vector3(position.x, position.y + size, position.z + -size),
                Vector3(position.x, position.y + -size, position.z + -size)),
            color: color,
          ),
        ];
      }
    case Axis3D.y:
      if (negative) {
        return [
          Face3D(
            Triangle.points(
                Vector3(position.x + -size, position.y, position.z + -size),
                Vector3(position.x + -size, position.y, position.z + size),
                Vector3(position.x + size, position.y, position.z + size)),
            color: color,
          ),
          Face3D(
            Triangle.points(
                Vector3(position.x + size, position.y, position.z + size),
                Vector3(position.x + size, position.y, position.z + -size),
                Vector3(position.x + -size, position.y, position.z + -size)),
            color: color,
          ),
        ];
      } else {
        return [
          Face3D(
            Triangle.points(
                Vector3(position.x + size, position.y, position.z + size),
                Vector3(position.x + -size, position.y, position.z + size),
                Vector3(position.x + -size, position.y, position.z + -size)),
            color: color,
          ),
          Face3D(
            Triangle.points(
                Vector3(position.x + -size, position.y, position.z + -size),
                Vector3(position.x + size, position.y, position.z + -size),
                Vector3(position.x + size, position.y, position.z + size)),
            color: color,
          ),
        ];
      }
    case Axis3D.z:
      if (negative) {
        return [
          Face3D(
            Triangle.points(
                Vector3(position.x + -size, position.y + -size, position.z),
                Vector3(position.x + -size, position.y + size, position.z),
                Vector3(position.x + size, position.y + size, position.z)),
            color: color,
          ),
          Face3D(
            Triangle.points(
                Vector3(position.x + size, position.y + size, position.z),
                Vector3(position.x + size, position.y + -size, position.z),
                Vector3(position.x + -size, position.y + -size, position.z)),
            color: color,
          ),
        ];
      } else {
        return [
          Face3D(
            Triangle.points(
                Vector3(position.x + size, position.y + size, position.z),
                Vector3(position.x + -size, position.y + size, position.z),
                Vector3(position.x + -size, position.y + -size, position.z)),
            color: color,
          ),
          Face3D(
            Triangle.points(
                Vector3(position.x + -size, position.y + -size, position.z),
                Vector3(position.x + size, position.y + -size, position.z),
                Vector3(position.x + size, position.y + size, position.z)),
            color: color,
          ),
        ];
      }
  }
}
