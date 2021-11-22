import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

import '../extensions.dart';

void main() {
  diTreDiDrawTest('group_3d/cubes.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Group3D([
        Cube3D(1, Vector3(0, 0, 0)),
        Cube3D(1, Vector3(3, 3, 3)),
      ]),
    ], controller: controller));
  });

  diTreDiDrawTest('group_3d/various.png', (tester, controller) async {
    await tester.pumpWidget(DiTreDi(figures: [
      Group3D([
        Line3D(Vector3(0, 0, 0), Vector3(3, 3, 3)),
        Cube3D(1, Vector3(0, 0, 0)),
        Cube3D(1, Vector3(3, 3, 3)),
        Point3D(Vector3(1.5, 1.5, 1.5), width: 4),
      ]),
    ], controller: controller));
  });
}
