import 'dart:math' as math;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:ditredi/ditredi.dart';
import 'package:ditredi/src/painter/model/model_3d_painter.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

/// Draws a [DiTreDi] data on a [Canvas].
/// Shouldn't be used directly, use [DiTreDi] instead.
class CanvasModelPainter extends CustomPainter implements PaintViewPort {
  static const _dimension = 2;
  static const _maxDepth = 5000.0;

  var _isDirty = true;
  final DiTreDiController _controller;
  Aabb3 _bounds = Aabb3();

  final List<Model3D<dynamic>> _figures;

  var _viewPortWidth = 0.0;
  var _viewPortHeight = 0.0;
  var _colorsToDraw = Int32List(0);
  var _colorsBuffer = Int32List(0);
  var _verticesToDraw = Float32List(0);
  var _verticesBuffer = Float32List(0);
  var _zIndex = Float32List(0);
  late PriorityQueue _priorityQueue;

  final Paint _vPaint = Paint()..isAntiAlias = true;
  final DiTreDiConfig _config;

  /// Creates a [CanvasModelPainter].
  CanvasModelPainter(
    this._figures,
    Aabb3? bounds,
    this._controller,
    this._config,
  ) : super(repaint: _controller) {
    _controller.addListener(() {
      _isDirty = true;
    });

    _setupBounds(_figures, bounds);

    final verticesCount = _figures.fold(0, (int p, e) => p + e.verticesCount());
    _verticesToDraw = Float32List(verticesCount * _dimension);
    _colorsToDraw = Int32List(verticesCount);
    _zIndex = Float32List(verticesCount ~/ 3);

    if (_config.supportZIndex) {
      _verticesBuffer = Float32List(verticesCount * _dimension);
      _colorsBuffer = Int32List(verticesCount);
      _priorityQueue = PriorityQueue((a, b) {
        return _zIndex[a].compareTo(_zIndex[b]);
      });
    }
  }

  /////////////////////////
  // paint cache values
  /////////////////////////
  final _matrix = Matrix4.zero();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    _viewPortWidth = size.width / 2;
    _viewPortHeight = size.height / 2;

    canvas.translate(_viewPortWidth, _viewPortHeight);

    _controller.viewScale = math.min(_viewPortWidth, _viewPortHeight);
    _isDirty = false;

    final rotationX = _degreeToRadians(_controller.rotationX);
    final rotationY = _degreeToRadians(_controller.rotationY);
    final rotationZ = _degreeToRadians(_controller.rotationZ);

    final dx = _bounds.center.x;
    final dy = _bounds.center.y;
    final dz = _bounds.center.z;

    final scale = _controller.scale;

    _matrix.setIdentity();

    if (_config.perspective) _matrix.setEntry(3, 2, -0.001);

    _matrix
      ..translate(_controller.translation.dx, _controller.translation.dy, 0)
      ..translate(-dx * scale, dy * scale, dz * scale)
      ..scale(scale, -scale, -scale)
      ..translate(dx, dy, dz)
      ..rotateX(rotationX)
      ..rotateY(rotationY)
      ..rotateZ(rotationZ)
      ..translate(-dx, -dy, -dz);

    var vertexIndex = 0;
    for (var i = 0; i < _figures.length; i++) {
      final figure = _figures[i];
      figure.paint(
        _config,
        _controller,
        this,
        figure,
        _matrix,
        vertexIndex,
        _zIndex,
        _colorsToDraw,
        _verticesToDraw,
      );
      vertexIndex += figure.verticesCount();
    }

    if (_config.supportZIndex) {
      _drawWithZIndex(canvas);
    } else {
      _drawFlat(canvas);
    }

    canvas.restore();
  }

  void _drawFlat(Canvas canvas) {
    canvas.drawVertices(
      Vertices.raw(
        VertexMode.triangles,
        _verticesToDraw,
        colors: _colorsToDraw,
      ),
      BlendMode.dst,
      _vPaint,
    );
  }

  void _drawWithZIndex(Canvas canvas) {
    _priorityQueue.clear();
    for (var i = 0; i < _zIndex.length; i++) {
      _priorityQueue.add(i);
    }

    var verticesCounter = 0;
    var colorCounter = 0;
    while (_priorityQueue.isNotEmpty) {
      final faceIndex = _priorityQueue.removeFirst();
      final vertexIndex = faceIndex * 6;
      _verticesBuffer[verticesCounter + 0] = _verticesToDraw[vertexIndex + 0];
      _verticesBuffer[verticesCounter + 1] = _verticesToDraw[vertexIndex + 1];
      _verticesBuffer[verticesCounter + 2] = _verticesToDraw[vertexIndex + 2];
      _verticesBuffer[verticesCounter + 3] = _verticesToDraw[vertexIndex + 3];
      _verticesBuffer[verticesCounter + 4] = _verticesToDraw[vertexIndex + 4];
      _verticesBuffer[verticesCounter + 5] = _verticesToDraw[vertexIndex + 5];

      final colorIndex = faceIndex * 3;
      _colorsBuffer[colorCounter + 0] = _colorsToDraw[colorIndex];
      _colorsBuffer[colorCounter + 1] = _colorsToDraw[colorIndex];
      _colorsBuffer[colorCounter + 2] = _colorsToDraw[colorIndex];

      verticesCounter += 6;
      colorCounter += 3;
    }

    canvas.drawVertices(
      Vertices.raw(
        VertexMode.triangles,
        _verticesBuffer,
        colors: _colorsBuffer,
      ),
      BlendMode.dst,
      _vPaint,
    );
  }

  void _setupBounds(List<Model3D<dynamic>> figures, Aabb3? bounds) {
    if (figures.isEmpty) return;

    if (bounds == null) {
      final points =
          figures.map((e) => e.toPoints()).flatten().map((e) => e.position);
      bounds = Aabb3.minMax(points.first, points.first);
      for (var p in points) {
        bounds.hullPoint(p);
      }
    }

    double spreadX = bounds.max.x - bounds.min.x;
    double spreadY = bounds.max.y - bounds.min.y;
    double spreadZ = bounds.max.z - bounds.min.z;
    _controller.modelScale = 1 / max(spreadX, max(spreadY, spreadZ));

    _bounds = bounds;
  }

  double _degreeToRadians(double degree) {
    return degree * (math.pi / 180.0);
  }

  /// Checks if vector is visible in the current viewport.
  @override
  bool isVectorVisible(Vector3 vector) {
    return vector.x >= -_viewPortWidth &&
        vector.x <= _viewPortWidth &&
        vector.y >= -_viewPortHeight &&
        vector.y <= _viewPortHeight &&
        vector.z <= _maxDepth;
  }

  /// Checks if line is visible in the current viewport.
  @override
  bool isLineVisible(Vector3 a, Vector3 b) {
    if (a.x < -_viewPortWidth && b.x < -_viewPortWidth) return false;
    if (a.x > _viewPortWidth && b.x > _viewPortWidth) return false;
    if (a.y < -_viewPortHeight && b.y < -_viewPortHeight) return false;
    if (a.y > _viewPortHeight && b.y > _viewPortHeight) return false;
    if (a.z > _maxDepth || b.z > _maxDepth) return false;
    return true;
  }

  /// Checks if triangle is visible in the current viewport.
  @override
  bool isTriangleVisible(Triangle t) {
    return isLineVisible(t.point0, t.point1) ||
        isLineVisible(t.point1, t.point2) ||
        isLineVisible(t.point2, t.point0);
  }

  @override
  bool shouldRepaint(CanvasModelPainter oldDelegate) => _isDirty;
}
