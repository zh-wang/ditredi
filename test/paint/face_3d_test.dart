import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as m;
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('face_3d/triangle.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Face3D(
        Triangle.points(
          Vector3(0, 0 - 1, 0 - 1),
          Vector3(0, 0 - 1, 0 + 1),
          Vector3(0, 0 + 1, 0 + 1),
        ),
      ),
    ], controller: controller));
  });

  diTreDiDrawTest('face_3d/color.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Face3D(
        Triangle.points(
          Vector3(0, 0 - 1, 0 - 1),
          Vector3(0, 0 - 1, 0 + 1),
          Vector3(0, 0 + 1, 0 + 1),
        ),
        color: m.Colors.green,
      ),
    ], controller: controller));
  });

  diTreDiDrawTest('face_3d/multiple_colors.png', (tester, controller) async {
    final a = Face3D(
      Triangle.points(
        Vector3(0, 0 - 1, 0 - 1),
        Vector3(0, 0 - 1, 0 + 1),
        Vector3(0, 0 + 1, 0 + 1),
      ),
      color: m.Colors.red,
    );
    final b = Face3D(
      Triangle.points(
        Vector3(1, 0 - 1, 0 - 1),
        Vector3(1, 0 - 1, 0 + 1),
        Vector3(1, 0 + 1, 0 + 1),
      ),
      color: m.Colors.red,
    );

    await tester.pumpWidget(DiTreDi(figures: [
      a,
      b.copyWith(color: m.Colors.green),
    ], controller: controller));
  });

  diTreDiDrawTest('face_3d/lines.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      ...Face3D(
        Triangle.points(
          Vector3(-1, 0, -1),
          Vector3(-1, 0, 1),
          Vector3(1, 0, 1),
        ),
      ).toLines(),
    ], controller: controller));
  });

  diTreDiDrawTest('face_3d/points.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      ...Face3D(
        Triangle.points(
          Vector3(-1, 0, -1),
          Vector3(-1, 0, 1),
          Vector3(1, 0, 1),
        ),
      ).toPoints(),
    ], controller: controller));
  });
}
