import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('modifier_3d/transformation.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        TransformModifier3D(
            Cube3D(2, Vector3(1, 1, 1)),
            Matrix4.identity()
              ..setRotationX(10)
              ..setRotationY(10)
              ..setRotationZ(10)),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('modifier_3d/self_rotation.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(2, Vector3(0, 0, 0)),
        TransformModifier3D(
            Cube3D(2, Vector3(2, 2, 2)),
            Matrix4.identity()
              ..translate(2.0, 2.0, 2.0)
              ..rotateZ(10)
              ..rotateX(10)
              ..translate(-2.0, -2.0, -2.0)),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('modifier_3d/group.png', (tester, controller) async {
    controller.userScale = 0.8;
    final transformation = Matrix4.identity()
      ..setRotationX(20)
      ..setRotationZ(20);
    await tester.pumpWidget(DiTreDi(
      figures: [
        Cube3D(2, Vector3(0, 0, 0)),
        TransformModifier3D(
          Group3D([
            Cube3D(2, Vector3(2, 2, 2)),
            Cube3D(2, Vector3(4, 4, 4)),
          ]),
          transformation,
        ),
      ],
      controller: controller,
    ));
  });
}
