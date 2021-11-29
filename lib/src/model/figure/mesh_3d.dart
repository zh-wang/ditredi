import 'package:ditredi/ditredi.dart';

/// A mesh made of [Face3D] (triangles).
class Mesh3D extends Group3D {
  /// List of faces making a mesh.
  final List<Face3D> faces;

  /// Creates a new mesh.
  Mesh3D(
    this.faces,
  ) : super(faces);

  /// Copies the mesh.
  Mesh3D copyWith({List<Face3D>? faces}) {
    return Mesh3D(faces ?? this.faces);
  }

  @override
  Mesh3D clone() {
    return Mesh3D(
      faces.map((e) => e.clone()).toList(),
    );
  }

  @override
  int get hashCode => Object.hashAll(faces);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Mesh3D &&
            runtimeType == other.runtimeType &&
            other.faces.length == faces.length &&
            other.faces.every((e) => faces.contains(e));
  }
}
