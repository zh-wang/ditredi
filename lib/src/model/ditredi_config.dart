import 'dart:ui';

import 'package:ditredi/ditredi.dart';

/// Configuration of [DiTreDi].
class DiTreDiConfig {
  /// Default color for [Face3D], [Mesh3D], [Cube3D] etc.
  final Color defaultColorMesh;

  /// Default color for [Point3D].
  final Color defaultColorPoints;

  /// Default width for [Point3D].
  final double defaultPointWidth;

  /// Default color for [Line3D].
  final double defaultLineWidth;

  /// If true, objects will be drawn with depth.
  /// Defaults to true.
  final bool perspective;

  /// If true, drawn objects will be sorted by distance to the camera.
  /// Disable to improve performance.
  final bool supportZIndex;

  /// Creates a new [DiTreDiConfig].
  const DiTreDiConfig({
    this.defaultColorMesh = const Color.fromARGB(255, 255, 255, 255),
    this.defaultColorPoints = const Color.fromARGB(255, 200, 200, 200),
    this.defaultPointWidth = 1,
    this.defaultLineWidth = 1,
    this.perspective = true,
    this.supportZIndex = true,
  });
}
