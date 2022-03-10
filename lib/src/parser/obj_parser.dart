import 'dart:convert';
import 'dart:ui';

import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vector_math/vector_math_64.dart';
import 'package:ditredi/src/parser/file/file_loader.dart'
    if (dart.library.io) 'package:ditredi/src/parser/file/file_loader_io.dart'
    if (dart.library.html) 'package:ditredi/src/parser/file/file_loader_web.dart';

/// Parser for Wavefront .obj files.
class ObjParser {
  final LineSplitter _lineSplitter = const LineSplitter();

  /// Material usage tag.
  static const usemtl = "usemtl";

  /// Material library tag.
  static const mtllib = "mtllib";

  /// Material tag.
  static const newmtl = "newmtl";

  /// Vertex material tagd.
  static const _kd = "Kd";
  static const _tr = "Tr";

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
    final lines = _lineSplitter.convert(modelData);
    final materialLib = <String, Map<String, ObjMaterial>>{};
    for (var line in lines) {
      if (line.startsWith(mtllib)) {
        final libName = line.trim().split(_whiteSpace).last;
        final content = await rootBundle
            .loadString(Uri(pathSegments: [...dirPath, libName]).path)
            .onError((_, __) => "");
        final material = await parseMtlLib(content);
        if (material != null) {
          materialLib[libName] = material;
        }
      }
    }
    return parseLines(lines, materialLib: materialLib);
  }

  /// Parses a Wavefront OBJ file from the given [objFilePath].
  Future<List<Face3D>> loadFromFile(Uri objFilePath) async {
    assert(
      !objFilePath.path.endsWith('.mtl'),
      "The filename name must not end with '.mtl'. Use filename with obj extension: ${objFilePath.path.replaceAll(".mtl", ".obj")}",
    );

    return parseFromFileUri(this, objFilePath);
  }

  /// Creates a [List] of [Face3D] for given obj [data] and [materialLib].
  Future<List<Face3D>> parse(
    String data, {
    Map<String, Map<String, ObjMaterial>> materialLib = const {},
  }) async {
    return parseLines(_lineSplitter.convert(data), materialLib: materialLib);
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
      List<String> chars = line.trim().split(_whiteSpace);

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
      } else if (chars[0] == usemtl) {
        currentMaterial = materials[chars[1]] ?? ObjMaterial.defaultMaterial();
      } else if (chars[0] == mtllib) {
        materials = materialLib[chars[1]] ?? <String, ObjMaterial>{};
      }
    }

    return faces;
  }

  /// Gets map of materials from [materialData] (mtl file content).
  Future<Map<String, ObjMaterial>?> parseMtlLib(String? materialData) async {
    final materials = <String, ObjMaterial>{};

    if (materialData == null || materialData.isEmpty) return null;

    final lines = _lineSplitter.convert(materialData);
    String name = '';
    double r = 0, g = 0, b = 0;
    for (var line in lines) {
      List<String> chars = line.trim().split(_whiteSpace);
      if (chars[0] == newmtl) {
        name = chars[1];
      }
      if (chars[0] == _kd) {
        r = double.parse(chars[1]);
        g = double.parse(chars[2]);
        b = double.parse(chars[3]);
        materials[name] = ObjMaterial(
          color: Color.fromARGB(
            255,
            (255 * r).toInt(),
            (255 * g).toInt(),
            (255 * b).toInt(),
          ),
        );
      } else if (chars[0] == _tr) {
        final a = double.parse(chars[1]);
        materials[name] = ObjMaterial(
          color: Color.fromARGB(
            (255 * a).toInt(),
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
