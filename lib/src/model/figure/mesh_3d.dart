import 'package:ditredi/ditredi.dart';

class Mesh3D extends Group3D {
  final List<Face3D> faces;

  Mesh3D(
    this.faces,
  ) : super(faces);

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
