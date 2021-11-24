import 'dart:io';

import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stack_trace/stack_trace.dart' as stacktrace;

import '../extensions.dart';

void main() {
  diTreDiDrawTest('splash.png', (tester, controller) async {
    controller.update(
      userScale: 10,
      rotationX: -30,
      rotationY: 30,
      translation: const Offset(30, -130),
    );
    final mesh = await _getTerrainCsv();
    await tester.pumpWidget(Container(
      color: Colors.black,
      child: DiTreDi(
        figures: [...mesh],
        controller: controller,
        config: const DiTreDiConfig(defaultPointWidth: 2),
      ),
    ));
  }, width: 776, height: 300);
}

Future<List<Point3D>> _getTerrainCsv() async => _getCsv("terrain2.csv");

Future<List<Point3D>> _getCsv(String filename) async {
  final file = File("${_getCurrentDir()}/../assets/$filename");
  return await CsvParser().parse(file.readAsStringSync());
}

String _getCurrentDir() =>
    File(stacktrace.Frame.caller(1).library).parent.absolute.path;
