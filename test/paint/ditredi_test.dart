import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as m;
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('ditredi/empty.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: const [], controller: controller));
  });

  diTreDiDrawTest('ditredi/color.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
      ],
      controller: controller,
      config: const DiTreDiConfig(
        defaultColorMesh: m.Colors.red,
      ),
    ));
  });

  diTreDiDrawTest('ditredi/multiple.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
        Cube3D(1, Vector3(-3, 0, 0)),
        Cube3D(1, Vector3(3, 0, 0)),
        Cube3D(1, Vector3(0, -3, 0)),
        Cube3D(1, Vector3(0, 3, 0)),
        Cube3D(1, Vector3(0, 0, -3)),
        Cube3D(1, Vector3(0, 0, 3)),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('ditredi/ortho.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
      ],
      controller: controller,
      config: const DiTreDiConfig(
        perspective: false,
      ),
    ));
  });

  diTreDiDrawTest('ditredi/x_rotation.png', (tester, controller) async {
    controller.update(
      rotationX: 30,
      rotationY: 0,
      rotationZ: 0,
    );
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
      ],
      controller: controller,
      config: const DiTreDiConfig(),
    ));
  });

  diTreDiDrawTest('ditredi/y_rotation.png', (tester, controller) async {
    controller.update(
      rotationX: 0,
      rotationY: 30,
      rotationZ: 0,
    );
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
      ],
      controller: controller,
      config: const DiTreDiConfig(),
    ));
  });

  diTreDiDrawTest('ditredi/z_rotation.png', (tester, controller) async {
    controller.update(
      rotationX: 0,
      rotationY: 0,
      rotationZ: 30,
    );
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
      ],
      controller: controller,
      config: const DiTreDiConfig(),
    ));
  });

  diTreDiDrawTest('ditredi/190_x_rotation.png', (tester, controller) async {
    controller.update(
      rotationX: 190,
      rotationY: 0,
      rotationZ: 0,
    );
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
      ],
      controller: controller,
      config: const DiTreDiConfig(),
    ));
  });

  diTreDiDrawTest('ditredi/190_y_rotation.png', (tester, controller) async {
    controller.update(
      rotationX: 0,
      rotationY: 190,
      rotationZ: 0,
    );
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
      ],
      controller: controller,
      config: const DiTreDiConfig(),
    ));
  });

  diTreDiDrawTest('ditredi/190_z_rotation.png', (tester, controller) async {
    controller.update(
      rotationX: 0,
      rotationY: 0,
      rotationZ: 190,
    );
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(1, Vector3(0, 0, 0)),
      ],
      controller: controller,
      config: const DiTreDiConfig(),
    ));
  });
}
