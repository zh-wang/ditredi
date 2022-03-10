import 'dart:typed_data';
import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/model_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

/// Draws a [Face3D].
mixin Face3DPainter implements Model3DPainter<Face3D> {
  static final _t =
      Triangle.points(Vector3.zero(), Vector3.zero(), Vector3.zero());
  static final _secondFirst = Vector3.zero();
  static final _secondThird = Vector3.zero();
  static final _jnv = Vector3.zero();

  @override
  void paint(
      DiTreDiConfig config,
      DiTreDiController controller,
      PaintViewPort viewPort,
      Face3D model,
      Matrix4 matrix,
      int vertexIndex,
      Float32List zIndices,
      Int32List colors,
      Float32List vertices) {
    _t.copyFrom(model.triangle);
    matrix.perspectiveTransform(_t.point0);
    matrix.perspectiveTransform(_t.point1);
    matrix.perspectiveTransform(_t.point2);

    if (_shouldDraw(viewPort, _t)) {
      // z-index
      zIndices[vertexIndex ~/ 3] =
          (_t.point0.z + _t.point1.z + _t.point2.z) / 3;

      // color
      final originColor = _getFaceColor(model, config, controller, _t);
      colors[vertexIndex + 0] = originColor;
      colors[vertexIndex + 1] = originColor;
      colors[vertexIndex + 2] = originColor;
    } else {
      colors[vertexIndex + 0] = 0;
      colors[vertexIndex + 1] = 0;
      colors[vertexIndex + 2] = 0;
      _t.point0.setZero();
      _t.point1.setZero();
      _t.point2.setZero();
    }

    // vertex
    final pointIndex = vertexIndex * 2;
    vertices[pointIndex + 0] = _t.point0.x;
    vertices[pointIndex + 1] = _t.point0.y;
    vertices[pointIndex + 2] = _t.point1.x;
    vertices[pointIndex + 3] = _t.point1.y;
    vertices[pointIndex + 4] = _t.point2.x;
    vertices[pointIndex + 5] = _t.point2.y;
  }

  bool _shouldDraw(PaintViewPort viewPort, Triangle t) {
    return (t.point1.x - t.point0.x) * (t.point2.y - t.point0.y) -
                (t.point1.y - t.point0.y) * (t.point2.x - t.point0.x) <
            0.0 &&
        viewPort.isTriangleVisible(t);
  }

  int _getFaceColor(Face3D model, DiTreDiConfig config,
      DiTreDiController controller, Triangle t) {
    final color = model.color ?? config.defaultColorMesh;
    _normalVector3(t.point0, t.point1, t.point2, _jnv);
    final p = (_jnv.dot(controller.light) * controller.lightStrength)
        .clamp(controller.ambientLightStrength, double.infinity);
    return Color.fromARGB(
      color.alpha,
      (color.red.toDouble() * p).round().clamp(0, 255),
      (color.green.toDouble() * p).round().clamp(0, 255),
      (color.blue.toDouble() * p).round().clamp(0, 255),
    ).value;
  }

  void _normalVector3(
      Vector3 first, Vector3 second, Vector3 third, Vector3 out) {
    _secondFirst.setFrom(second);
    _secondFirst.sub(first);
    _secondThird.setFrom(second);
    _secondThird.sub(third);

    out
      ..setValues(
        (_secondFirst.y * _secondThird.z) - (_secondFirst.z * _secondThird.y),
        (_secondFirst.z * _secondThird.x) - (_secondFirst.x * _secondThird.z),
        (_secondFirst.x * _secondThird.y) - (_secondFirst.y * _secondThird.x),
      )
      ..normalize();
  }
}
