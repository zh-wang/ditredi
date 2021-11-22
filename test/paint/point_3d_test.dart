import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as m;
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('point_3d/default.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Point3D(Vector3(0, 0, 0)),
      ],
      controller: controller,
      bounds: Aabb3.minMax(Vector3(0, 0, 0), Vector3(1, 1, 1)),
    ));
  });

  diTreDiDrawTest('point_3d/bold.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Point3D(Vector3(0, 0, 0), width: 20),
      ],
      controller: controller,
      bounds: Aabb3.minMax(Vector3(0, 0, 0), Vector3(1, 1, 1)),
    ));
  });

  diTreDiDrawTest('point_3d/color.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Point3D(Vector3(0, 0, 0), width: 2, color: m.Colors.green),
      ],
      controller: controller,
      bounds: Aabb3.minMax(Vector3(0, 0, 0), Vector3(1, 1, 1)),
    ));
  });
}
