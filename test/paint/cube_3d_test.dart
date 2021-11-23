import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('cube/default.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Cube3D(2, Vector3(0, 0, 0)),
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

  diTreDiDrawTest('cube/large_set.png', (tester, controller) async {
    controller.update(rotationY: 0, rotationX: 0);
    await tester.pumpWidget(DiTreDi(
      figures: [
        TransformModifier3D(
          Group3D([..._generateCubes()]),
          Matrix4.identity()..rotateY(10),
        ),
      ],
      config: const DiTreDiConfig(),
      controller: controller,
    ));
  });
}

Iterable<Cube3D> _generateCubes() sync* {
  for (var x = -20; x < 20; x++) {
    for (var y = -20; y < 20; y++) {
      for (var z = -20; z < 20; z++) {
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
