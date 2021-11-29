import 'dart:math';

/// Extensions to transform radians and degrees.
extension DegreeExtensions on double {
  /// Converts degrees to radians.
  double toRadians() => this * pi / 180;

  /// Converts radians to degrees.
  double toDegrees() => this * 180 / pi;
}
