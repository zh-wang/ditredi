import 'dart:math';
import 'dart:typed_data';

import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/model_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

/// Draws a [Line3D].
mixin Line3DPainter implements Model3DPainter<Line3D> {
  static final _a = Vector3.zero();
  static final _b = Vector3.zero();

  @override
  void paint(
      DiTreDiConfig config,
      DiTreDiController controller,
      PaintViewPort viewPort,
      Line3D model,
      Matrix4 matrix,
      int vertexIndex,
      Float32List zIndices,
      Int32List colors,
      Float32List vertices) {
    _a.setFrom(model.a);
    _b.setFrom(model.b);
    matrix
      ..perspectiveTransform(_a)
      ..perspectiveTransform(_b);

    // z-index
    final z = (_a.z + _b.z) / 2.0 + 0.4;
    zIndices[vertexIndex ~/ 3 + 0] = z;
    zIndices[vertexIndex ~/ 3 + 1] = z;

    final pointIndex = vertexIndex * 2;

    if (viewPort.isLineVisible(_a, _b)) {
      // color
      final vertexColor = model.color?.value ?? config.defaultColorPoints.value;
      colors[vertexIndex + 0] = vertexColor;
      colors[vertexIndex + 1] = vertexColor;
      colors[vertexIndex + 2] = vertexColor;
      colors[vertexIndex + 3] = vertexColor;
      colors[vertexIndex + 4] = vertexColor;
      colors[vertexIndex + 5] = vertexColor;

      // vertex
      // d           c
      // o-----------o
      // |         x |
      // |     x     |
      // | x         |
      // o-----------o
      // a           b
      var dx = _b.x - _a.x;
      var dy = _b.y - _a.y;
      final lineLength = sqrt(dx * dx + dy * dy);
      if (lineLength != 0) {
        dx /= lineLength;
        dy /= lineLength;
      }
      final thick = model.width ?? config.defaultLineWidth;
      final px = 0.5 * thick * (-dy);
      final py = 0.5 * thick * dx;
      // a
      vertices[pointIndex + 00] = _a.x + px;
      vertices[pointIndex + 01] = _a.y + py;
      // b
      vertices[pointIndex + 02] = _b.x + px;
      vertices[pointIndex + 03] = _b.y + py;
      // c
      vertices[pointIndex + 04] = _b.x - px;
      vertices[pointIndex + 05] = _b.y - py;
      // d
      vertices[pointIndex + 06] = _a.x - px;
      vertices[pointIndex + 07] = _a.y - py;
      // a
      vertices[pointIndex + 08] = _a.x + px;
      vertices[pointIndex + 09] = _a.y + py;
      // c
      vertices[pointIndex + 10] = _b.x - px;
      vertices[pointIndex + 11] = _b.y - py;
    } else {
      vertices[pointIndex + 00] = 0;
      vertices[pointIndex + 01] = 0;
      vertices[pointIndex + 02] = 0;
      vertices[pointIndex + 03] = 0;
      vertices[pointIndex + 04] = 0;
      vertices[pointIndex + 05] = 0;
      vertices[pointIndex + 06] = 0;
      vertices[pointIndex + 07] = 0;
      vertices[pointIndex + 08] = 0;
      vertices[pointIndex + 09] = 0;
      vertices[pointIndex + 10] = 0;
      vertices[pointIndex + 11] = 0;
    }
  }
}
