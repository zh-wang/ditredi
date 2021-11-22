import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as m;
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('plane_3d/y.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Plane3D(5, Axis3D.y, false, Vector3(0, 0, 0), color: m.Colors.green),
    ], controller: controller));
  });

  diTreDiDrawTest('plane_3d/x.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Plane3D(5, Axis3D.x, false, Vector3(0, 0, 0), color: m.Colors.green),
    ], controller: controller));
  });

  diTreDiDrawTest('plane_3d/z.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Plane3D(5, Axis3D.z, false, Vector3(0, 0, 0), color: m.Colors.green),
    ], controller: controller));
  });

  diTreDiDrawTest('plane_3d/lines.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      ...Plane3D(5, Axis3D.z, false, Vector3(0, 0, 0)).toLines(),
    ], controller: controller));
  });

  diTreDiDrawTest('plane_3d/points.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      ...Plane3D(5, Axis3D.z, false, Vector3(0, 0, 0)).toPoints(),
    ], controller: controller));
  });
}
