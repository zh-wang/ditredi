import 'dart:ui';

import 'package:ditredi/src/model/model_3d.dart';
import 'package:ditredi/src/painter/canvas_model_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

export 'package:ditredi/src/extensions/double_extensions.dart';
export 'package:ditredi/src/extensions/iterable_extensions.dart';
export 'package:ditredi/src/extensions/vector_extensions.dart';
export 'package:ditredi/src/model/axis.dart';
export 'package:ditredi/src/model/model_3d.dart';
export 'package:ditredi/src/model/modifier_3d.dart';
export 'package:ditredi/src/model/vertices/line_3.dart';
export 'package:ditredi/src/model/vertices/poly_line3.dart';
export 'package:ditredi/src/parser/csv_parser.dart';
export 'package:ditredi/src/parser/obj_parser.dart';

class DiTreDi extends StatelessWidget {
  final List<Model3D> figures;
  final Aabb3? bounds;
  final DiTreDiConfig config;
  final DiTreDiController controller;

  DiTreDi({
    Key? key,
    required this.figures,
    DiTreDiController? controller,
    this.config = const DiTreDiConfig(),
    this.bounds,
  })  : controller = controller ?? DiTreDiController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        size: Size.infinite,
        painter: CanvasModelPainter(
          figures,
          bounds,
          controller,
          config,
        ),
      ),
    );
  }
}

class DiTreDiConfig {
  final Color defaultColorMesh;
  final Color defaultColorPoints;
  final double defaultPointWidth;
  final double defaultLineWidth;
  final bool perspective;
  final bool supportZIndex;

  const DiTreDiConfig({
    this.defaultColorMesh = const Color.fromARGB(255, 255, 255, 255),
    this.defaultColorPoints = const Color.fromARGB(255, 200, 200, 200),
    this.defaultPointWidth = 1,
    this.defaultLineWidth = 1,
    this.perspective = true,
    this.supportZIndex = true,
  });
}

class DiTreDiController extends ChangeNotifier {
  double modelScale;
  double viewScale;
  double userScale;
  double rotationX;
  double rotationY;
  double rotationZ;
  Offset translation;
  Vector3 light;

  DiTreDiController({
    this.modelScale = 1,
    this.viewScale = 1,
    this.userScale = 1,
    this.rotationX = -45,
    this.rotationY = 45,
    this.rotationZ = 0,
    this.translation = const Offset(0, 0),
    Vector3? light,
  }) : light = light ?? Vector3(10, -20, 20).normalized();

  void update({
    double? modelScale,
    double? viewScale,
    double? userScale,
    double? rotationX,
    double? rotationY,
    double? rotationZ,
    Offset? translation,
    Vector3? light,
  }) {
    this.modelScale = modelScale ?? this.modelScale;
    this.viewScale = viewScale ?? this.viewScale;
    this.userScale = userScale ?? this.userScale;
    this.rotationX = rotationX ?? this.rotationX;
    this.rotationY = rotationY ?? this.rotationY;
    this.rotationZ = rotationZ ?? this.rotationZ;
    this.translation = translation ?? this.translation;
    if (light != null) {
      light.normalizeInto(this.light);
    }
    notifyListeners();
  }

  double get scale => modelScale * viewScale * userScale;
}

class DiTreDiDraggable extends StatefulWidget {
  final DiTreDiController controller;
  final Widget child;
  final bool rotationEnabled;
  final bool scaleEnabled;

  const DiTreDiDraggable({
    Key? key,
    required this.controller,
    required this.child,
    this.rotationEnabled = true,
    this.scaleEnabled = true,
  }) : super(key: key);

  @override
  State<DiTreDiDraggable> createState() => _DiTreDiDraggableState();
}

class _DiTreDiDraggableState extends State<DiTreDiDraggable> {
  var _lastX = 0.0;
  var _lastY = 0.0;

  void _updateTap(DragStartDetails data) {
    _lastX = data.globalPosition.dx;
    _lastY = data.globalPosition.dy;
  }

  void _updateCube(DragUpdateDetails data) {
    final controller = widget.controller;
    if (!widget.rotationEnabled) return;

    final dx = data.globalPosition.dx - _lastX;
    final dy = data.globalPosition.dy - _lastY;

    _lastX = data.globalPosition.dx;
    _lastY = data.globalPosition.dy;

    controller.update(
      rotationX: (controller.rotationX - dy / 2).clamp(-90, -20),
      rotationY: ((controller.rotationY - dx / 2 + 360) % 360).clamp(0, 360),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent && widget.scaleEnabled) {
          final scaledDy =
              pointerSignal.scrollDelta.dy / widget.controller.viewScale;
          widget.controller.update(
            userScale: (widget.controller.userScale - scaledDy).clamp(0.8, 3.0),
          );
        }
      },
      child: GestureDetector(
        onPanStart: _updateTap,
        onPanUpdate: _updateCube,
        child: widget.child,
      ),
    );
  }
}
