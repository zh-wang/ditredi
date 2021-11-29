import 'dart:io';

import 'package:ditredi/ditredi.dart';
import 'package:flutter/widgets.dart';

/// Abstraction over file loading to support web platform.
Future<List<Face3D>> parseFromFileUri(ObjParser parser, Uri uri) async {
  final _whiteSpace = RegExp(r"\s+");
  final objFile = File.fromUri(uri);
  final lines = objFile.readAsLinesSync();
  final objDir = objFile.parent.uri;
  final materialLib = <String, Map<String, ObjMaterial>>{};
  for (var line in lines) {
    if (line.startsWith(ObjParser.mtllib)) {
      final libName = line.split(_whiteSpace).last;
      final libPath = Uri.parse("$objDir$libName");
      try {
        final content = File.fromUri(libPath).readAsStringSync();
        final material = await parser.parseMtlLib(content);
        if (material != null) {
          materialLib[libName] = material;
        }
      } on FileSystemException {
        debugPrint("Could not find material library: $libName");
      }
    }
  }
  return parser.parseLines(lines, materialLib: materialLib);
}
