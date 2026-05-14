import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class AngleCalculator {
  /// Calculates the 2D angle (in degrees) formed by three points:
  /// [first], [middle] (vertex of the angle), and [last].
  static double calculateAngle(PoseLandmark first, PoseLandmark middle, PoseLandmark last) {
    final double radians = atan2(last.y - middle.y, last.x - middle.x) -
        atan2(first.y - middle.y, first.x - middle.x);

    double angle = (radians * 180.0 / pi).abs();

    if (angle > 180.0) {
      angle = 360.0 - angle;
    }

    return angle;
  }
}
