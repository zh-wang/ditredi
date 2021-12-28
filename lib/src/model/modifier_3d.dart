import 'dart:typed_data';

import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/model_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

/// Modifies drawing of [Model3D] objects.
abstract class Modifier3D implements Model3D<Modifier3D> {
  /// A figure to modify.
  final Model3D figure;

  /// Creates a new modifier.
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
      DiTreDiController controller,
      PaintViewPort viewPort,
      Model3D model,
      Matrix4 matrix,
      int vertexIndex,
      Float32List zIndices,
      Int32List colors,
      Float32List vertices) {
    figure.paint(
      config,
      controller,
      viewPort,
      model,
      matrix,
      vertexIndex,
      zIndices,
      colors,
      vertices,
    );
  }
}

/// Transformation of [Model3D] objects with [Matrix4].
class TransformModifier3D extends Modifier3D {
  /// A transformation matrix being multiplied
  /// with the current transformation.
  final Matrix4 transformation;

  /// Creates a new transformation modifier.
  TransformModifier3D(Model3D figure, this.transformation) : super(figure);

  @override
  TransformModifier3D clone() {
    return TransformModifier3D(figure.clone() as Model3D, transformation);
  }

  static final Matrix4 _tmp = Matrix4.zero();

  @override
  void paint(
      DiTreDiConfig config,
      DiTreDiController controller,
      PaintViewPort viewPort,
      Model3D model,
      Matrix4 matrix,
      int vertexIndex,
      Float32List zIndices,
      Int32List colors,
      Float32List vertices) {
    _tmp.setFrom(matrix);
    _tmp.multiply(transformation);
    figure.paint(
      config,
      controller,
      viewPort,
      figure,
      _tmp,
      vertexIndex,
      zIndices,
      colors,
      vertices,
    );
  }
}
