import 'dart:io';

import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_test/flutter_test.dart';
import 'package:stack_trace/stack_trace.dart' as stacktrace;

import '../extensions.dart';

void main() {
  diTreDiDrawTest('mesh_3d/torus.png', (tester, controller) async {
    final mesh = await _getTorus();
    await tester.pumpWidget(DiTreDi(figures: [mesh], controller: controller));
  });

  diTreDiDrawTest('mesh_3d/torus_ortho.png', (tester, controller) async {
    final mesh = await _getTorus();
    await tester.pumpWidget(DiTreDi(
      figures: [mesh],
      controller: controller,
      config: const DiTreDiConfig(perspective: false),
    ));
  });

  diTreDiDrawTest('mesh_3d/torus_color.png', (tester, controller) async {
    final mesh = await _getTorus();
    await tester.pumpWidget(DiTreDi(
      figures: [mesh],
      controller: controller,
      config: const DiTreDiConfig(defaultColorMesh: m.Colors.red),
    ));
  });

  diTreDiDrawTest('mesh_3d/torus_lines.png', (tester, controller) async {
    final mesh = await _getTorus();
    await tester.pumpWidget(DiTreDi(
      figures: [
        ...mesh.toLines(),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('mesh_3d/torus_points.png', (tester, controller) async {
    final mesh = await _getTorus();
    await tester.pumpWidget(DiTreDi(
      figures: [
        ...mesh.toPoints(),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('mesh_3d/terrain.png', (tester, controller) async {
    final mesh = await _getTerrain();
    await tester.pumpWidget(DiTreDi(figures: [mesh], controller: controller));
  });

  diTreDiDrawTest('mesh_3d/terrain_ortho.png', (tester, controller) async {
    final mesh = await _getTerrain();
    await tester.pumpWidget(DiTreDi(
      figures: [mesh],
      controller: controller,
      config: const DiTreDiConfig(perspective: false),
    ));
  });

  diTreDiDrawTest('mesh_3d/terrain_color.png', (tester, controller) async {
    final mesh = await _getTerrain();
    await tester.pumpWidget(DiTreDi(
      figures: [mesh],
      controller: controller,
      config: const DiTreDiConfig(defaultColorMesh: m.Colors.red),
    ));
  });

  diTreDiDrawTest('mesh_3d/terrain_lines.png', (tester, controller) async {
    final mesh = await _getTerrain();
    await tester.pumpWidget(DiTreDi(
      figures: [
        ...mesh.toLines(),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('mesh_3d/terrain_points.png', (tester, controller) async {
    final mesh = await _getTerrain();
    await tester.pumpWidget(DiTreDi(
      figures: [
        ...mesh.toPoints(),
      ],
      controller: controller,
    ));
  });

  diTreDiDrawTest('mesh_3d/terrain_csv_points.png', (tester, controller) async {
    final mesh = await _getTerrainCsv();
    await tester.pumpWidget(DiTreDi(
      figures: [...mesh],
      controller: controller,
    ));
  });

  diTreDiDrawTest('mesh_3d/lowpolytree.png', (tester, controller) async {
    final mesh = await _getPolytree();
    await tester.pumpWidget(DiTreDi(figures: [mesh], controller: controller));
  });
}

Future<Mesh3D> _getTorus() async => _getObjModel("torus.obj");

Future<Mesh3D> _getTerrain() async => _getObjModel("terrain.obj");

Future<Mesh3D> _getPolytree() async => _getObjModel("lowpolytree.obj");

Future<List<Point3D>> _getTerrainCsv() async => _getCsv("terrain.csv");

Future<Mesh3D> _getObjModel(String filename) async {
  final file = File("${_getCurrentDir()}/../assets/$filename");
  final faces = await ObjParser().loadFromFile(file);
  return Mesh3D(faces);
}

Future<List<Point3D>> _getCsv(String filename) async {
  final file = File("${_getCurrentDir()}/../assets/$filename");
  return await CsvParser().parse(file.readAsStringSync());
}

String _getCurrentDir() =>
    File(stacktrace.Frame.caller(1).library).parent.absolute.path;
