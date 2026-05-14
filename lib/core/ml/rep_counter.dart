import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pose_tracker/core/ml/angle_calculator.dart';
import 'package:pose_tracker/models/exercise.dart';

enum WorkoutState { up, down, unknown }

class RepCounter {
  WorkoutState _currentState = WorkoutState.unknown;
  final Exercise _exercise;

  RepCounter(this._exercise);

  // Return true if a repetition was just completed in this frame.
  bool countRep(Pose pose) {
    if (_exercise.name.toLowerCase().contains("squat")) {
      return _processSquat(pose);
    } else if (_exercise.name.toLowerCase().contains("push")) {
      return _processPushup(pose);
    } else if (_exercise.name.toLowerCase().contains("jack")) {
      return _processJumpingJack(pose);
    }
    return false;
  }

  bool _processSquat(Pose pose) {
    // Squat depends on Hip, Knee, Ankle angles
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];

    if (leftHip == null || leftKnee == null || leftAnkle == null) return false;

    // Check visibility
    if (leftHip.likelihood < 0.5 || leftKnee.likelihood < 0.5 || leftAnkle.likelihood < 0.5) return false;

    final angle = AngleCalculator.calculateAngle(leftHip, leftKnee, leftAnkle);

    // Thresholds
    if (angle > 160.0) {
      if (_currentState == WorkoutState.down) {
        _currentState = WorkoutState.up;
        return true; // Rep finished
      }
      _currentState = WorkoutState.up;
    } else if (angle < 90.0) {
      _currentState = WorkoutState.down;
    }

    return false;
  }

  bool _processPushup(Pose pose) {
    // Pushup depends on Shoulder, Elbow, Wrist
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];

    if (leftShoulder == null || leftElbow == null || leftWrist == null) return false;
    if (leftShoulder.likelihood < 0.5 || leftElbow.likelihood < 0.5 || leftWrist.likelihood < 0.5) return false;

    final angle = AngleCalculator.calculateAngle(leftShoulder, leftElbow, leftWrist);

    if (angle > 160.0) {
      if (_currentState == WorkoutState.down) {
        _currentState = WorkoutState.up;
        return true; // Rep completed
      }
      _currentState = WorkoutState.up;
    } else if (angle < 90.0) {
      _currentState = WorkoutState.down;
    }

    return false;
  }

  bool _processJumpingJack(Pose pose) {
    // Simplification for Jumping Jack: look at wrists distance relative to shoulders width
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

    if (leftWrist == null || rightWrist == null || leftShoulder == null || rightShoulder == null) return false;
    
    // Check if hands are above shoulders
    bool handsUp = leftWrist.y < leftShoulder.y && rightWrist.y < rightShoulder.y;
    bool handsDown = leftWrist.y > leftShoulder.y && rightWrist.y > rightShoulder.y;

    if (handsDown) {
      if (_currentState == WorkoutState.up) {
        _currentState = WorkoutState.down;
        return true; // Rep finished
      }
      _currentState = WorkoutState.down;
    } else if (handsUp) {
      _currentState = WorkoutState.up;
    }

    return false;
  }
}
