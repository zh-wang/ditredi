import 'dart:typed_data';

import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/model_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

/// Draws [Pain3D].
mixin Point3DPainter implements Model3DPainter<Point3D> {
  static final _p = Vector3.zero();

  @override
  void paint(
    DiTreDiConfig config,
    DiTreDiController controller,
    PaintViewPort viewPort,
    Point3D model,
    Matrix4 matrix,
    int vertexIndex,
    Float32List zIndices,
    Int32List colors,
    Float32List vertices,
  ) {
    _p.setFrom(model.position);
    matrix.perspectiveTransform(_p);

    // z-index
    zIndices[vertexIndex ~/ 3 + 0] = _p.z;
    zIndices[vertexIndex ~/ 3 + 1] = _p.z;

    final pointPosition = vertexIndex * 2;
    if (viewPort.isVectorVisible(_p)) {
      // color
      final vertexColor = model.color?.value ?? config.defaultColorPoints.value;
      colors[vertexIndex + 0] = vertexColor;
      colors[vertexIndex + 1] = vertexColor;
      colors[vertexIndex + 2] = vertexColor;
      colors[vertexIndex + 3] = vertexColor;
      colors[vertexIndex + 4] = vertexColor;
      colors[vertexIndex + 5] = vertexColor;

      // vertex
      final dx = (model.width ?? config.defaultPointWidth) * 0.5;
      vertices[pointPosition + 00] = _p.x - dx;
      vertices[pointPosition + 01] = _p.y - dx;
      vertices[pointPosition + 02] = _p.x - dx;
      vertices[pointPosition + 03] = _p.y + dx;
      vertices[pointPosition + 04] = _p.x + dx;
      vertices[pointPosition + 05] = _p.y + dx;
      vertices[pointPosition + 06] = _p.x + dx;
      vertices[pointPosition + 07] = _p.y + dx;
      vertices[pointPosition + 08] = _p.x + dx;
      vertices[pointPosition + 09] = _p.y - dx;
      vertices[pointPosition + 10] = _p.x - dx;
      vertices[pointPosition + 11] = _p.y - dx;
    } else {
      vertices[pointPosition + 00] = 0;
      vertices[pointPosition + 01] = 0;
      vertices[pointPosition + 02] = 0;
      vertices[pointPosition + 03] = 0;
      vertices[pointPosition + 04] = 0;
      vertices[pointPosition + 05] = 0;
      vertices[pointPosition + 06] = 0;
      vertices[pointPosition + 07] = 0;
      vertices[pointPosition + 08] = 0;
      vertices[pointPosition + 09] = 0;
      vertices[pointPosition + 10] = 0;
      vertices[pointPosition + 11] = 0;
    }
  }
}
