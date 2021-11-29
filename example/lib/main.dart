import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final aController = DiTreDiController(rotationX: -20, rotationY: 30);
  final bController = DiTreDiController(rotationX: -20, rotationY: 30);
  final cController = DiTreDiController(rotationX: -20, rotationY: 30);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      title: 'DiTreDi Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: LayoutBuilder(
                builder: (_, constraints) {
                  final cubes = _generateCubes();
                  return Flex(
                    direction: constraints.maxWidth < 600
                        ? Axis.vertical
                        : Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DiTreDiDraggable(
                          controller: aController,
                          child: DiTreDi(
                            figures: cubes.toList(),
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
                              ...cubes
                                  .map((e) => e.toLines())
                                  .flatten()
                                  .map((e) => e.copyWith(
                                      color: Colors.red.withAlpha(20)))
                                  .toList()
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
                      Expanded(
                        flex: 1,
                        child: DiTreDiDraggable(
                          controller: cController,
                          child: DiTreDi(
                            figures: _generatePoints().toList(),
                            controller: cController,
                            // disable z index to boost drawing performance
                            // for wireframes and points
                            config: const DiTreDiConfig(
                              defaultPointWidth: 2,
                              supportZIndex: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Drag to rotate. Scroll to zoom"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Iterable<Cube3D> _generateCubes() sync* {
  final colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

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
          color: colors[(x + y + z) % colors.length],
        );
      }
    }
  }
}

Iterable<Point3D> _generatePoints() sync* {
  for (var x = 0; x < 10; x++) {
    for (var y = 0; y < 10; y++) {
      for (var z = 0; z < 10; z++) {
        yield Point3D(
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
