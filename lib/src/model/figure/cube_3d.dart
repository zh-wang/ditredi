import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

/// A 3D cube.
class Cube3D extends Group3D {
  /// Cube size.
  final double size;

  /// Cube position.
  final Vector3 position;

  /// Cube color. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Creates a cube.
  Cube3D(this.size, this.position, {this.color})
      : super([
          //     o-----o
          //   /     / |
          // o-----o   o
          // |  /  | /
          // o-----o
          /////
          Plane3D(size / 2, Axis3D.x, true,
              Vector3(position.x - size / 2, position.y, position.z),
              color: color),
          Plane3D(size / 2, Axis3D.x, false,
              Vector3(position.x + size / 2, position.y, position.z),
              color: color),
          /////
          Plane3D(size / 2, Axis3D.y, false,
              Vector3(position.x, position.y + size / 2, position.z),
              color: color),
          Plane3D(size / 2, Axis3D.y, true,
              Vector3(position.x, position.y - size / 2, position.z),
              color: color),
          /////
          Plane3D(size / 2, Axis3D.z, false,
              Vector3(position.x, position.y, position.z - size / 2),
              color: color),
          Plane3D(size / 2, Axis3D.z, true,
              Vector3(position.x, position.y, position.z + size / 2),
              color: color),
        ]);

  @override
  Group3D clone() {
    return Cube3D(size, position);
  }

  /// Copies the cube.
  Cube3D copyWith({
    double? size,
    Vector3? position,
    Color? color,
  }) {
    return Cube3D(
      size ?? this.size,
      position ?? this.position,
      color: color ?? this.color,
    );
  }

  @override
  int get hashCode => Object.hash(size, position, color);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Cube3D &&
            runtimeType == other.runtimeType &&
            size == other.size &&
            position == other.position &&
            color == other.color;
  }
}
