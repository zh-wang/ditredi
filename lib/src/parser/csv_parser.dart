import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

/// Parser for a csv file.
class CsvParser {
  /// Parses a csv file with ',' as separator and x,y,z coordinates.
  /// Creates a [List] of [Point3D]s.
  Future<List<Point3D>> parse(String data) async {
    return data
        .split('\n')
        .map((line) => line.split(','))
        .where((element) => element.length == 3)
        .map((e) =>
            Vector3(double.parse(e[0]), double.parse(e[2]), double.parse(e[1])))
        .map((e) => Point3D(e))
        .toList();
  }
}
