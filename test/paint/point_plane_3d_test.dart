import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as m;
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('point_plane_3d/default.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      PointPlane3D(1, Axis3D.y, 0.1, Vector3(0, 0, 0)),
    ], controller: controller));
  });

  diTreDiDrawTest('point_plane_3d/color.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      PointPlane3D(1, Axis3D.y, 0.1, Vector3(0, 0, 0), color: m.Colors.green),
    ], controller: controller));
  });

  diTreDiDrawTest('point_plane_3d/bold.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      PointPlane3D(1, Axis3D.y, 0.1, Vector3(0, 0, 0), pointWidth: 5),
      Cube3D(0.1, Vector3(0, 0, 0)),
    ], controller: controller));
  });
}
