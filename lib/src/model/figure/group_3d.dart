import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/group_3d_painter.dart';
import 'package:vector_math/vector_math_64.dart';

/// A group of 3D objects.
class Group3D with Group3DPainter implements Model3D<Group3D> {
  /// The list of 3D objects in a group.
  final List<Model3D> figures;
  final int _verticesCount;

  /// Creates a group of 3D objects.
  Group3D(
    this.figures,
  ) : _verticesCount = figures.fold(0, (int p, e) => p + e.verticesCount());

  @override
  Group3D clone() {
    return Group3D(
      figures.map((e) => e.clone() as Model3D).toList(),
    );
  }

  @override
  int verticesCount() => _verticesCount;

  @override
  List<Line3D> toLines() =>
      figures.map((e) => e.toLines()).flatten().toSet().toList();

  @override
  List<Point3D> toPoints() =>
      figures.map((e) => e.toPoints()).flatten().toSet().toList();

  @override
  Aabb3 getBounds() {
    if (figures.isEmpty) return Aabb3();
    final result = Aabb3.copy(figures.first.getBounds());
    for (var e in figures) {
      result.hull(e.getBounds());
    }
    return result;
  }

  @override
  int get hashCode => Object.hashAll(figures);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Group3D &&
            runtimeType == other.runtimeType &&
            other.figures.length == figures.length &&
            other.figures.every((e) => figures.contains(e));
  }
}
