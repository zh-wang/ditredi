import 'dart:io';
import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vector_math/vector_math_64.dart';

/// Parser for Wavefront .obj files.
class ObjParser {
  static const _usemtl = "usemtl";
  static const _mtllib = "mtllib";
  static const _newmtl = "newmtl";
  static const _kd = "Kd";

  static final _whiteSpace = RegExp(r"\s+");

  /// Parses a Wavefront OBJ file from the given [objResourceName].
  Future<List<Face3D>> loadFromResources(String objResourceName) async {
    assert(
      !objResourceName.endsWith('.mtl'),
      "The resource name must not end with '.mtl'. Use filename with obj extension: ${objResourceName.replaceAll(".mtl", ".obj")}",
    );

    final modelData = await rootBundle.loadString(objResourceName);
    final resourcePath = Uri(path: objResourceName);
    final dirPath =
        resourcePath.pathSegments.take(resourcePath.pathSegments.length - 1);
    final lines = modelData.split('\n');
    final materialLib = <String, Map<String, ObjMaterial>>{};
    for (var line in lines) {
      if (line.startsWith(_mtllib)) {
        final libName = line.split(_whiteSpace).last;
        final content = await rootBundle
            .loadString(Uri(pathSegments: [...dirPath, libName]).path)
            .onError((_, __) => "");
        final material = await _parseMtlLib(content);
        if (material != null) {
          materialLib[libName] = material;
        }
      }
    }
    return parseLines(lines, materialLib: materialLib);
  }

  /// Parses a Wavefront OBJ file from the given [resourceName].
  Future<List<Face3D>> loadFromFile(File objFile) async {
    assert(
      !objFile.path.endsWith('.mtl'),
      "The filename name must not end with '.mtl'. Use filename with obj extension: ${objFile.path.replaceAll(".mtl", ".obj")}",
    );

    final lines = objFile.readAsLinesSync();
    final objDir = objFile.parent.uri;
    final materialLib = <String, Map<String, ObjMaterial>>{};
    for (var line in lines) {
      if (line.startsWith(_mtllib)) {
        final libName = line.split(_whiteSpace).last;
        final libPath = Uri.parse("$objDir$libName");
        try {
          final content = File.fromUri(libPath).readAsStringSync();
          final material = await _parseMtlLib(content);
          if (material != null) {
            materialLib[libName] = material;
          }
        } on FileSystemException {
          debugPrint("Could not find material library: $libName");
        }
      }
    }
    return parseLines(lines, materialLib: materialLib);
  }

  /// Creates a [List] of [Face3D] for given obj [data] and [materialLib].
  Future<List<Face3D>> parse(
    String data, {
    Map<String, Map<String, ObjMaterial>> materialLib = const {},
  }) async {
    return parseLines(data.split('\n'), materialLib: materialLib);
  }

  /// Creates a [List] of [Face3D] for given obj [lines] and [materialLib].
  Future<List<Face3D>> parseLines(
    List<String> lines, {
    Map<String, Map<String, ObjMaterial>> materialLib = const {},
  }) async {
    final vertices = <Vector3>[];
    final faces = <Face3D>[];
    Map<String, ObjMaterial> materials = {};
    ObjMaterial currentMaterial = ObjMaterial.defaultMaterial();
    for (var line in lines) {
      List<String> chars = line.split(_whiteSpace);

      if (chars[0] == "v") {
        // vertex
        vertices.add(Vector3(
          double.parse(chars[1]),
          double.parse(chars[3]),
          double.parse(chars[2]),
        ));
      } else if (chars[0] == "f") {
        // face
        for (int i = 1; i < chars.length - 1; i++) {
          faces.add(Face3D(
            Triangle.points(
              vertices[_parseVertexIndex(chars[1]) - 1].clone(),
              vertices[_parseVertexIndex(chars[i]) - 1].clone(),
              vertices[_parseVertexIndex(chars[i + 1]) - 1].clone(),
            ),
            color: currentMaterial.color,
          ));
        }
      } else if (chars[0] == _usemtl) {
        currentMaterial = materials[chars[1]] ?? ObjMaterial.defaultMaterial();
      } else if (chars[0] == _mtllib) {
        materials = materialLib[chars[1]] ?? <String, ObjMaterial>{};
      }
    }

    return faces;
  }

  Future<Map<String, ObjMaterial>?> _parseMtlLib(String? materialData) async {
    final materials = <String, ObjMaterial>{};

    if (materialData == null || materialData.isEmpty) return null;

    final lines = materialData.split("\n");
    String name = '';
    for (var line in lines) {
      List<String> chars = line.split(_whiteSpace);
      if (chars[0] == _newmtl) {
        name = chars[1];
      }
      if (chars[0] == _kd) {
        final r = double.parse(chars[1]);
        final g = double.parse(chars[2]);
        final b = double.parse(chars[3]);
        materials[name] = ObjMaterial(
          color: Color.fromARGB(
            255,
            (255 * r).toInt(),
            (255 * g).toInt(),
            (255 * b).toInt(),
          ),
        );
      }
    }
    return materials;
  }

  int _parseVertexIndex(String s) {
    if (s.contains("/")) {
      return int.parse(s.split("/").first);
    } else {
      return int.parse(s);
    }
  }
}

/// Material used for [Face3D].
class ObjMaterial {
  /// Color specified in the material file.
  final Color? color;

  /// Creates a new [ObjMaterial].
  ObjMaterial({required this.color});

  /// Creates a default (empty) material.
  factory ObjMaterial.defaultMaterial() {
    return ObjMaterial(
      color: null, // default color is applied from DiTreDiConfig.
    );
  }
}
