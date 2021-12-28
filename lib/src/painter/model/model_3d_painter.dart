import 'dart:typed_data';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

export 'package:ditredi/src/painter/model/face_3d_painter.dart';
export 'package:ditredi/src/painter/model/group_3d_painter.dart';
export 'package:ditredi/src/painter/model/line_3d_painter.dart';
export 'package:ditredi/src/painter/model/point_3d_painter.dart';

/// Abstraction for painting a [Model3D] in a drawer buffer.
abstract class Model3DPainter<T extends Model3D<T>> {
  /// Fills the buffer with the [Model3D] data.
  void paint(
    DiTreDiConfig config,
    DiTreDiController controller,
    PaintViewPort viewPort,
    T model,
    Matrix4 matrix,
    int vertexIndex,
    Float32List zIndices,
    Int32List colors,
    Float32List vertices,
  );
}

/// Describes painting ViewPort (ViewPort is a rectangle in the buffer).
abstract class PaintViewPort {
  /// Checks if vector is visible in the current viewport.
  bool isVectorVisible(Vector3 vector);

  /// Checks if line is visible in the current viewport.
  bool isLineVisible(Vector3 a, Vector3 b);

  /// Checks if triangle is visible in the current viewport.
  bool isTriangleVisible(Triangle t);
}
