import 'dart:math';

extension DegreeExtensions on double {
  double toRadians() => this * pi / 180;
  double toDegrees() => this * 180 / pi;
}
