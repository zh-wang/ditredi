import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

/// Extensions for [Plane].
extension PlaneExtensions on Plane {
  /// Returns [Plane] intersection with a given line (from [a] to [b]).
  Vector3? intersectionWithLine(Vector3 a, Vector3 b) {
    return _getPlaneLineIntersection(this, a, b);
  }

  /// Returns [Plane] intersection with a given [triangle].
  Set<Line3> intersectionWithTriangle(Triangle triangle) {
    final a = intersectionWithLine(triangle.point0, triangle.point1);
    final b = intersectionWithLine(triangle.point1, triangle.point2);
    final c = intersectionWithLine(triangle.point2, triangle.point0);
    final result = {
      if (a != null && b != null) Line3(a, b),
      if (a != null && c != null) Line3(a, c),
      if (b != null && c != null) Line3(b, c),
    };
    return result;
  }
}

/// Extensions for [Triangle].
extension TriangleExtensions on Triangle {
  /// Returns [Triangle] intersection with a given [plane].
  Set<Line3> intersectionWithPlane(Plane p) {
    return p.intersectionWithTriangle(this);
  }
}

/// Extensions for [Line3].
extension LineExtensions on List<Line3> {
  /// Joins list of [Line3] to a single [PolyLine3].
  List<PolyLine3> joinToPolyLine() {
    final polys = <PolyLine3>{};
    for (var l in this) {
      polys.add(PolyLine3([l]));
    }

    var merged = false;
    const eps = 0.0001;
    do {
      merged = false;
      for (var p1 in polys) {
        // closed curve
        if (p1.start == p1.stop && p1.lines.length > 2) {
          continue;
        }

        for (var p2 in polys) {
          if (p1 == p2) {
            continue;
          }

          // distance
          if (p1.stop.distanceTo(p2.start) < eps) {
            polys.remove(p1);
            polys.remove(p2);
            polys.add(PolyLine3([
              ...p1.lines,
              ...p2.lines,
            ]));
            merged = true;
            break;
          } else if (p2.stop.distanceTo(p1.start) < eps) {
            polys.remove(p1);
            polys.remove(p2);
            polys.add(PolyLine3([
              ...p2.lines,
              ...p1.lines,
            ]));
            merged = true;
            break;
          } else if (p1.stop.distanceTo(p2.stop) < eps) {
            polys.remove(p1);
            polys.remove(p2);
            polys.add(PolyLine3([
              ...p1.lines,
              ...p2.lines.reversed.map((e) => Line3(e.b, e.a)),
            ]));
            merged = true;
            break;
          } else if (p1.start.distanceTo(p2.start) < eps) {
            polys.remove(p1);
            polys.remove(p2);
            polys.add(PolyLine3([
              ...p1.lines.reversed.map((e) => Line3(e.b, e.a)),
              ...p2.lines,
            ]));
            merged = true;
            break;
          }
        }
        if (merged) break;
      }
    } while (merged);
    return polys.toList();
  }

  /// Smooths [Line3] using bezier smoothing algorithm.
  List<Line3> bezierSmooth() {
    if (length <= 1) return this;
    const smooth = 0.1;
    final result = <Line3>[];

    result.add(this[0]);
    for (var i = 1; i < length - 1; i += 1) {
      final previous = this[i - 1].a;
      final next = this[i + 1].b;
      final currentA = this[i].a;
      final currentB = this[i].b;

      final controlA = Vector3(
        currentA.x - (previous.x - currentA.x) * smooth,
        currentA.y - (previous.y - currentA.y) * smooth,
        currentA.z - (previous.z - currentA.z) * smooth,
      );
      final controlB = Vector3(
        currentB.x - (next.x - currentB.x) * smooth,
        currentB.y - (next.y - currentB.y) * smooth,
        currentB.z - (next.z - currentB.z) * smooth,
      );

      final lines = [0.0, 0.3, 0.6, 1.0];
      lines
          .map((e) => _bezier4(currentA, controlA, controlB, currentB, e))
          .toList()
          .windowedWithStep(2, 1)
          .map((e) => Line3(e.elementAt(0), e.elementAt(1)))
          .forEach((element) => result.add(element));
    }
    result.add(this[length - 1]);
    return result;
  }

  Vector3 _bezier4(Vector3 av, Vector3 bv, Vector3 cv, Vector3 dv, double t) {
    final t2 = t * t;
    final mt = 1.0 - t;
    final mt2 = mt * mt;

    final a = mt2 * mt;
    final b = mt2 * t * 3;
    final c = mt * t2 * 3;
    final d = t * t2;

    final point = Vector3.copy(av);
    point.scale(a);
    point.addScaled(bv, b);
    point.addScaled(cv, c);
    point.addScaled(dv, d);

    return point;
  }
}

Vector3? _getPlaneLineIntersection(Plane p, Vector3 v1, Vector3 v2) {
  final d1 = _distFromPlane(p, v1);
  final d2 = _distFromPlane(p, v2);

  if (d1 == 0) return v1;
  if (d2 == 0) return v2;
  if (d1 * d2 > 0) return null; // same side

  final t = d1 / (d1 - d2);
  final minus = (v2 - v1);
  minus.scale(t);
  return v1 + minus;
}

double _distFromPlane(Plane p, Vector3 v) {
  return p.normal.dot(v) - p.constant;
}
