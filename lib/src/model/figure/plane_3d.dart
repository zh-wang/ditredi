import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

/// A plane.
class Plane3D extends Group3D {
  /// Facing axis (x to left/right, y to up/down, z to far/near).
  final Axis3D axis;

  /// If true, the plane is facing the camera in a standard rotation.
  final bool negative;

  /// Size of the plane.
  final double size;

  /// Center of the plane.
  final Vector3 position;

  /// Color of the plane. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Creates a new [Plane3D].
  Plane3D(this.size, this.axis, this.negative, this.position, {this.color})
      : super(_getFigures(size, axis, negative, position, color));

  /// Copies the plane.
  Plane3D copyWith({
    Axis3D? axis,
    bool? negative,
    double? size,
    Vector3? position,
    Color? color,
  }) {
    return Plane3D(
      size ?? this.size,
      axis ?? this.axis,
      negative ?? this.negative,
      position ?? this.position,
      color: color ?? this.color,
    );
  }

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
