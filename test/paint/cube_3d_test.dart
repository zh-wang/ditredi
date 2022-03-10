import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart' as m;

import '../extensions.dart';

void main() {
  diTreDiDrawTest('cube/default.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Cube3D(2, Vector3(0, 0, 0)),
    ], controller: controller));
  });

  diTreDiDrawTest('cube/ambient_light.png', (tester, controller) async {
    controller.update(ambientLightStrength: 1.0);
    await tester.pumpWidget(DiTreDi(figures: [
      Cube3D(2, Vector3(0, 0, 0), color: m.Colors.red),
    ], controller: controller));
  });

  diTreDiDrawTest('cube/translated.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Cube3D(2, Vector3(1, 2, 3)),
    ], controller: controller));
  });

  diTreDiDrawTest('cube/large.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(3, Vector3(1, 2, 3)),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('cube/rotated.png', (tester, controller) async {
    controller.update(rotationY: 30, rotationX: 30);
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(3, Vector3(1, 2, 3)),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('cube/ortho.png', (tester, controller) async {
    controller.update(rotationY: 30, rotationX: 30);
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(3, Vector3(1, 2, 3)),
      ],
      config: const DiTreDiConfig(perspective: false),
    ));
  });

  diTreDiDrawTest('cube/axis.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(0.5, Vector3(0, 0, 0), color: m.Colors.red),
        Cube3D(0.5, Vector3(1, 0, 0), color: m.Colors.red),
        Cube3D(0.5, Vector3(2, 0, 0), color: m.Colors.red),
        Cube3D(0.5, Vector3(0, 0, 0), color: m.Colors.blue),
        Cube3D(0.5, Vector3(0, 1, 0), color: m.Colors.blue),
        Cube3D(0.5, Vector3(0, 2, 0), color: m.Colors.blue),
        Cube3D(0.5, Vector3(2, 0, 0), color: m.Colors.red),
        Cube3D(0.5, Vector3(0, 0, 0), color: m.Colors.green),
        Cube3D(0.5, Vector3(0, 0, 1), color: m.Colors.green),
        Cube3D(0.5, Vector3(0, 0, 2), color: m.Colors.green),
      ],
    ));
  });

  diTreDiDrawTest('cube/large_set.png', (tester, controller) async {
    controller.update(rotationY: 30, rotationX: 0, userScale: 3);
    await tester.pumpWidget(DiTreDi(
      figures: [..._generateCubes()],
      config: const DiTreDiConfig(),
      controller: controller,
    ));
  }, width: 1000, height: 400);

  diTreDiDrawTest('cube/large_set_multicolor.png', (tester, controller) async {
    controller.update(rotationY: 30, rotationX: 0, userScale: 3);
    await tester.pumpWidget(DiTreDi(
      figures: [..._generateMultiColorCubes()],
      config: const DiTreDiConfig(),
      controller: controller,
    ));
  });

  diTreDiDrawTest('cube/large_set_transparency.png',
      (tester, controller) async {
    controller.update(rotationY: 30, rotationX: 0, userScale: 3);
    await tester.pumpWidget(DiTreDi(
      figures: [..._generateMultiColorCubesWithTransparency()],
      config: const DiTreDiConfig(),
      controller: controller,
    ));
  });
}

Iterable<Cube3D> _generateCubes() sync* {
  for (var x = -20; x < 20; x++) {
    for (var y = -10; y < 10; y++) {
      for (var z = -5; z < 5; z++) {
        yield Cube3D(
          1,
          Vector3(
            x.toDouble() * 1.5,
            y.toDouble() * 1.5,
            z.toDouble() * 1.5,
          ),
        );
      }
    }
  }
}

Iterable<Cube3D> _generateMultiColorCubes() sync* {
  final colors = [
    m.Colors.white,
    m.Colors.blue,
    m.Colors.yellow,
    m.Colors.red,
    m.Colors.orange,
    m.Colors.pink,
    m.Colors.purple,
    m.Colors.indigo,
  ];

  const count = 8;
  for (var x = count; x > 0; x--) {
    for (var y = count; y > 0; y--) {
      for (var z = count; z > 0; z--) {
        yield Cube3D(
          0.9,
          Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
          color: colors[(colors.length - y) % colors.length],
        );
      }
    }
  }
}

Iterable<Cube3D> _generateMultiColorCubesWithTransparency() sync* {
  final colors = [
    m.Colors.white.withAlpha(20),
    m.Colors.blue.withAlpha(20),
    m.Colors.yellow.withAlpha(20),
    m.Colors.red.withAlpha(20),
    m.Colors.orange.withAlpha(20),
    m.Colors.pink.withAlpha(20),
    m.Colors.purple.withAlpha(20),
    m.Colors.indigo.withAlpha(20),
  ];

  const count = 8;
  for (var x = count; x > 0; x--) {
    for (var y = count; y > 0; y--) {
      for (var z = count; z > 0; z--) {
        yield Cube3D(
          0.9,
          Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
          color: colors[(colors.length - y) % colors.length],
        );
      }
    }
  }
}
