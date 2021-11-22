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

abstract class Model3D<T extends Model3D<T>> implements Model3DPainter<T> {
  T clone();

  int verticesCount();

  List<Point3D> toPoints();

  List<Line3D> toLines();

  Aabb3 getBounds();
}
