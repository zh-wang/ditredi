import 'package:flutter/material.dart';
import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiTreDi Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'DiTreDi Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DiTreDiController controller;

  @override
  void initState() {
    super.initState();
    controller = DiTreDiController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    controller.update(rotationY: controller.rotationY + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DiTreDiDraggable(
        controller: controller,
        child: DiTreDi(
          figures: [
            ..._generateCubes(),
          ],
          controller: controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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
