import 'dart:typed_data';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

export 'package:ditredi/src/painter/model/face_3d_painter.dart';
export 'package:ditredi/src/painter/model/group_3d_painter.dart';
export 'package:ditredi/src/painter/model/line_3d_painter.dart';
export 'package:ditredi/src/painter/model/point_3d_painter.dart';

abstract class Model3DPainter<T extends Model3D<T>> {
  void paint(
    DiTreDiConfig config,
    T model,
    Matrix4 matrix,
    Vector3 normalizedLight,
    int vertexIndex,
    Float32List zIndices,
    Int32List colors,
    Float32List vertices,
  );
}
