import 'package:flutter/material.dart';
import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final aController = DiTreDiController();
  final bController = DiTreDiController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiTreDi Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: DiTreDiDraggable(
                controller: aController,
                child: DiTreDi(
                  figures: _generateCubes().toList(),
                  controller: aController,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: DiTreDiDraggable(
                controller: bController,
                child: DiTreDi(
                  figures: [
                    // place figures in drawing order when z-index is disabled
                    ...Cube3D(2, vector.Vector3(-5, 0, -5), color: Colors.black)
                        .toLines(),
                    ...Cube3D(2, vector.Vector3(-5, 4, -5), color: Colors.black)
                        .toLines(),
                    ...Cube3D(2, vector.Vector3(-5, 8, -5), color: Colors.black)
                        .toLines(),
                    ...Cube3D(2, vector.Vector3(-5, 12, -5),
                            color: Colors.black)
                        .toLines(),
                    ...Cube3D(2, vector.Vector3(-5, 16, -5),
                            color: Colors.black)
                        .toLines(),
                    ..._generateCubeLines(),
                  ],
                  controller: bController,
                  // disable z index to boost drawing performance
                  // for wireframes and points
                  config: const DiTreDiConfig(
                    supportZIndex: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Iterable<Cube3D> _generateCubes() sync* {
  for (var x = 0; x < 10; x++) {
    for (var y = 0; y < 10; y++) {
      for (var z = 0; z < 10; z++) {
        yield Cube3D(
          0.5,
          vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
        );
      }
    }
  }
}

Iterable<Line3D> _generateCubeLines() sync* {
  for (var x = 0; x < 10; x++) {
    for (var y = 0; y < 10; y++) {
      for (var z = 0; z < 10; z++) {
        yield* Cube3D(
          0.5,
          vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
        ).toLines().map((e) => e.copyWith(color: Colors.red.withAlpha(20)));
      }
    }
  }
}
