import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/face_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

/// A face - triangle with direction.
/// The face is defined by three points.
/// Faces not facing the camera are not drawn.
class Face3D with Face3DPainter implements Model3D<Face3D> {
  /// Points of the face.
  final Triangle triangle;

  /// Face color. Defaults to [DiTreDiConfig] setting.
  final Color? color;

  /// Creates a face with the given points.
  Face3D(this.triangle, {this.color});

  /// Creates a face from vertices.
  factory Face3D.fromVertices(
    Vector3 a,
    Vector3 b,
    Vector3 c, {
    Color? color,
  }) {
    return Face3D(Triangle.points(a, b, c), color: color);
  }

  /// Copies the face.
  Face3D copyWith({
    Triangle? triangle,
    Color? color,
  }) {
    return Face3D(triangle ?? this.triangle, color: color ?? this.color);
  }

  @override
  int verticesCount() {
    return 3;
  }

  @override
  Face3D clone() {
    return Face3D(Triangle.copy(triangle), color: color);
  }

  @override
  List<Line3D> toLines() {
    return [
      Line3D(triangle.point0, triangle.point1, color: color),
      Line3D(triangle.point1, triangle.point2, color: color),
      Line3D(triangle.point2, triangle.point0, color: color),
    ];
  }

  @override
  List<Point3D> toPoints() => [
        Point3D(triangle.point0, color: color),
        Point3D(triangle.point1, color: color),
        Point3D(triangle.point2, color: color),
      ];

  @override
  Aabb3 getBounds() {
    return Aabb3.fromTriangle(triangle);
  }

  @override
  int get hashCode => Object.hash(triangle, color);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Face3D &&
            runtimeType == other.runtimeType &&
            triangle == other.triangle &&
            color == other.color;
  }
}
