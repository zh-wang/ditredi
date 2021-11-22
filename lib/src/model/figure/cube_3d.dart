import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

class Cube3D extends Group3D {
  final double size;
  final Vector3 position;
  final Color? color;

  Cube3D(this.size, this.position, {this.color})
      : super([
          //     o-----o
          //   /     / |
          // o-----o   o
          // |  /  | /
          // o-----o
          /////
          Plane3D(size, Axis3D.x, true,
              Vector3(position.x - size, position.y, position.z),
              color: color),
          Plane3D(size, Axis3D.x, false,
              Vector3(position.x + size, position.y, position.z),
              color: color),
          /////
          Plane3D(size, Axis3D.y, false,
              Vector3(position.x, position.y + size, position.z),
              color: color),
          Plane3D(size, Axis3D.y, true,
              Vector3(position.x, position.y - size, position.z),
              color: color),
          /////
          Plane3D(size, Axis3D.z, false,
              Vector3(position.x, position.y, position.z - size),
              color: color),
          Plane3D(size, Axis3D.z, true,
              Vector3(position.x, position.y, position.z + size),
              color: color),
        ]);

  @override
  Group3D clone() {
    return Cube3D(size, position);
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
