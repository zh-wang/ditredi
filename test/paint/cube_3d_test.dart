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
        ..._generateCubes(),
      ],
      config: const DiTreDiConfig(),
      controller: controller,
    ));
  });
}

Iterable<Cube3D> _generateCubes() sync* {
  for (var x = 0; x < 50; x++) {
    for (var y = 0; y < 50; y++) {
      for (var z = 0; z < 50; z++) {
        yield Cube3D(
          0.5,
          Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
        );
      }
    }
  }
}
