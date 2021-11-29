import 'dart:ui';

import 'package:ditredi/src/controller/ditredi_controller.dart';
import 'package:ditredi/src/model/ditredi_config.dart';
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
export 'package:ditredi/src/model/ditredi_config.dart';
export 'package:ditredi/src/model/modifier_3d.dart';
export 'package:ditredi/src/model/vertices/line_3.dart';
export 'package:ditredi/src/model/vertices/poly_line3.dart';
export 'package:ditredi/src/parser/csv_parser.dart';
export 'package:ditredi/src/parser/obj_parser.dart';
export 'package:ditredi/src/controller/ditredi_controller.dart';

/// A widget that displays a 3D objects.
class DiTreDi extends StatelessWidget {
  /// List of [Model3D] to display.
  final List<Model3D> figures;

  /// Bounds of the 3D space.
  final Aabb3? bounds;

  /// The [DitrediConfig] to use.
  final DiTreDiConfig config;

  /// The controller to controll the camera.
  final DiTreDiController controller;

  /// Creates a [DiTreDi] widget.
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

/// A widget that controls the [DiTreDi] camera with gestures.
class DiTreDiDraggable extends StatefulWidget {
  /// The [DiTreDiController] to control.
  /// Should be the same as the one used in the [DiTreDi] widget.
  final DiTreDiController controller;

  /// The [DiTreDi] widget or its container.
  final Widget child;

  /// If true, the camera will be rotated with the finger.
  final bool rotationEnabled;

  /// If true, the zoom will be changed with the mouse scroll.
  final bool scaleEnabled;

  /// Creates a [DiTreDiDraggable] widget.
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
