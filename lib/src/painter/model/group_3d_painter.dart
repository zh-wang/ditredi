import 'dart:typed_data';

import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/model_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

mixin Group3DPainter implements Model3DPainter<Group3D> {
  @override
  void paint(
      DiTreDiConfig config,
      Group3D model,
      Matrix4 matrix,
      Vector3 normalizedLight,
      int vertexIndex,
      Float32List zIndices,
      Int32List colors,
      Float32List vertices) {
    var counter = 0;
    for (var figure in model.figures) {
      figure.paint(
        config,
        figure,
        matrix,
        normalizedLight,
        vertexIndex + counter,
        zIndices,
        colors,
        vertices,
      );
      counter += figure.verticesCount();
    }
  }
}
