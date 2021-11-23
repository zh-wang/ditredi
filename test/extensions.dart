import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:flutter_test/flutter_test.dart';

void diTreDiDrawTest(
    String filename,
    Future<void> Function(WidgetTester tester, DiTreDiController controller)
        testBody,
    {double width = 1000,
    double height = 1000}) {
  testWidgets(filename, (WidgetTester tester) async {
    final controller = DiTreDiController();
    await tester.setScreenSize(width: width, height: height);
    await testBody(tester, controller);
    await expectLater(
        find.byType(DiTreDi), matchesGoldenFile("golden/$filename"));
  });
}

extension _SetScreenSize on WidgetTester {
  Future<void> setScreenSize(
      {double width = 1000,
      double height = 1000,
      double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = pixelDensity;
  }
}
