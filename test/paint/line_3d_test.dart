import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as m;
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('line_3d/default.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Line3D(Vector3(0, 0, 0), Vector3(2, 3, 4)),
    ], controller: controller));
  });

  diTreDiDrawTest('line_3d/color.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Line3D(Vector3(0, 0, 0), Vector3(2, 3, 4), color: m.Colors.green),
    ], controller: controller));
  });

  diTreDiDrawTest('line_3d/width.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Line3D(Vector3(0, 1, 0), Vector3(2, 1, 4), width: 8),
      Line3D(Vector3(0, 2, 0), Vector3(2, 2, 4), width: 6),
      Line3D(Vector3(0, 3, 0), Vector3(2, 3, 4), width: 4),
      Line3D(Vector3(0, 4, 0), Vector3(2, 4, 4), width: 2),
      Line3D(Vector3(0, 5, 0), Vector3(2, 5, 4), width: 1),
    ], controller: controller));
  });
}
