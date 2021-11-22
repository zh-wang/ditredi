import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

class ObjParser {
  final _whiteSpace = RegExp(r"\s+");

  Future<List<Face3D>> parse(String data) async {
    final lines = data.split("\n");
    final vertices = <Vector3>[];
    final faces = <Face3D>[];

    for (var line in lines) {
      List<String> chars = line.split(_whiteSpace);

      if (chars[0] == "v") {
        // vertex
        final vertex = Vector3(
          double.parse(chars[1]),
          double.parse(chars[3]),
          double.parse(chars[2]),
        );

        vertices.add(vertex);
      } else if (chars[0] == "f") {
        // face
        faces.add(Face3D(Triangle.points(
          vertices[_parseVertexIndex(chars[1]) - 1].clone(),
          vertices[_parseVertexIndex(chars[2]) - 1].clone(),
          vertices[_parseVertexIndex(chars[3]) - 1].clone(),
        )));
      }
    }

    return faces;
  }

  int _parseVertexIndex(String s) {
    if (s.contains("/")) {
      return int.parse(s.split("/").first);
    } else {
      return int.parse(s);
    }
  }
}
