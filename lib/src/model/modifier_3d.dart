import 'dart:typed_data';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

abstract class Modifier3D implements Model3D<Modifier3D> {
  final Model3D figure;

  Modifier3D(this.figure);

  @override
  List<Line3D> toLines() {
    return figure.toLines();
  }

  @override
  List<Point3D> toPoints() {
    return figure.toPoints();
  }

  @override
  int verticesCount() {
    return figure.verticesCount();
  }

  @override
  Aabb3 getBounds() {
    return figure.getBounds();
  }

  @override
  void paint(
      DiTreDiConfig config,
      Model3D model,
      Matrix4 matrix,
      Vector3 normalizedLight,
      int vertexIndex,
      Float32List zIndices,
      Int32List colors,
      Float32List vertices) {
    figure.paint(
      config,
      model,
      matrix,
      normalizedLight,
      vertexIndex,
      zIndices,
      colors,
      vertices,
    );
  }
}

class TransformModifier3D extends Modifier3D {
  final Matrix4 transformation;

  TransformModifier3D(Model3D figure, this.transformation) : super(figure);

  @override
  TransformModifier3D clone() {
    return TransformModifier3D(figure.clone() as Model3D, transformation);
  }

  final Matrix4 tmp = Matrix4.zero();

  @override
  void paint(
      DiTreDiConfig config,
      Model3D model,
      Matrix4 matrix,
      Vector3 normalizedLight,
      int vertexIndex,
      Float32List zIndices,
      Int32List colors,
      Float32List vertices) {
    tmp.setFrom(matrix);
    tmp.multiply(transformation);
    figure.paint(config, model, tmp, normalizedLight, vertexIndex, zIndices,
        colors, vertices);
  }
}
