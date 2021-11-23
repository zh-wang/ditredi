import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('modifier_3d/transformation.png', (tester, controller) async {
    final transformation = Matrix4.identity()
      ..setRotationX(10)
      ..setRotationY(10)
      ..setRotationZ(10);
    await tester.pumpWidget(DiTreDi(
      figures: [
        TransformModifier3D(Cube3D(2, Vector3(0, 0, 0)), transformation),
      ],
      controller: controller,
    ));
  });

  // diTreDiDrawTest('modifier_3d/group.png', (tester, controller) async {
  //   final transformation = Matrix4.identity()
  //     ..setRotationX(10)
  //     ..setRotationY(10)
  //     ..setRotationZ(10);
  //   await tester.pumpWidget(DiTreDi(
  //     figures: [
  //       TransformModifier3D(
  //         Group3D([
  //           Cube3D(2, Vector3(0, 0, 0)),
  //           Cube3D(2, Vector3(4, 4, 4)),
  //         ]),
  //         transformation,
  //       ),
  //     ],
  //     controller: controller,
  //   ));
  // });
}
