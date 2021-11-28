import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final aController = DiTreDiController();
  final bController = DiTreDiController();
  final cController = DiTreDiController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiTreDi Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (_, constraints) => Flex(
            direction:
                constraints.maxWidth < 600 ? Axis.vertical : Axis.horizontal,
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
                    figures: _generateCubeLines().toList(),
                    controller: bController,
                    // disable z index to boost drawing performance
                    // for wireframes and points
                    config: const DiTreDiConfig(
                      supportZIndex: false,
                    ),
                  ),
                ),
              ),
              FutureBuilder<List<Face3D>>(
                  future:
                      ObjParser().loadFromResources('assets/lowpolytree.obj'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        flex: 1,
                        child: DiTreDiDraggable(
                          controller: cController,
                          child: DiTreDi(
                            figures: [Mesh3D(snapshot.data ?? [])],
                            controller: cController,
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
            ],
          ),
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
