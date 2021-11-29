import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:ditredi/ditredi.dart';

/// A widget that controls [DiTreDi] camera state - position, rotation, zoom.
class DiTreDiController extends ChangeNotifier {
  /// Scale factor for the model to fit in [-1, 1] bounds.
  double modelScale;

  /// Scale factor for the screen to draw [-1, 1] bounded model.
  double viewScale;

  /// User scale. By default it's 1.0.
  double userScale;

  /// Camera rotation around X-axis (vertical).
  /// Minus moves camera "above" the model, with plus it's "below".
  double rotationX;

  /// Camera rotation around Y-axis (horizontal).
  double rotationY;

  /// Camera rotation around Z-axis (roll).
  double rotationZ;

  /// Translation of the displayed model on the screen.
  Offset translation;

  /// Light direction for 3D objects.
  Vector3 light;

  /// Creates a new [DiTreDiController] instance.
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

  /// Updates controller and notifies listeners (including [DiTreDi] widget).
  void update({
    double? viewScale,
    double? userScale,
    double? rotationX,
    double? rotationY,
    double? rotationZ,
    Offset? translation,
    Vector3? light,
  }) {
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

  /// Combination of all scale factors to pixel coordinates.
  double get scale => modelScale * viewScale * userScale;
}