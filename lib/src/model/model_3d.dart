import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/model_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

export 'package:ditredi/src/model/figure/cube_3d.dart';
export 'package:ditredi/src/model/figure/face_3d.dart';
export 'package:ditredi/src/model/figure/group_3d.dart';
export 'package:ditredi/src/model/figure/line_3d.dart';
export 'package:ditredi/src/model/figure/mesh_3d.dart';
export 'package:ditredi/src/model/figure/plane_3d.dart';
export 'package:ditredi/src/model/figure/point_3d.dart';
export 'package:ditredi/src/model/figure/point_plane_3d.dart';

/// Abstraction for all 3D figures.
abstract class Model3D<T extends Model3D<T>> implements Model3DPainter<T> {
  /// Makes a copy of this model.
  T clone();

  /// Returns number of vertices.
  int verticesCount();

  /// Converts model to a [List] of [Point3D].
  List<Point3D> toPoints();

  /// Converts model to a [List] of [Line3D].
  List<Line3D> toLines();

  /// Gets bounds of a model (min and max coordinates).
  Aabb3 getBounds();
}
