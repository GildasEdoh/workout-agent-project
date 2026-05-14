import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pose_tracker/core/theme/app_colors.dart';

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize; // Original camera frame size
  final bool isFrontCamera; 

  PosePainter({
    required this.poses,
    required this.imageSize,
    required this.isFrontCamera,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (poses.isEmpty) return;

    // Calculate scale between original image and the widget's render box
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    final Paint pointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary
      ..strokeWidth = 6.0;

    final Paint leftLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = AppColors.secondary.withOpacity(0.8);

    final Paint rightLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightBlueAccent.withOpacity(0.8);

    // Coordinate mapping helper
    double translateX(double x) {
      if (isFrontCamera) {
        return size.width - (x * scaleX);
      }
      return x * scaleX;
    }

    double translateY(double y) {
      return y * scaleY;
    }

    for (final pose in poses) {
      // Draw Connections (Bones)
      void paintLine(PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark? landmark1 = pose.landmarks[type1];
        final PoseLandmark? landmark2 = pose.landmarks[type2];
        if (landmark1 != null && landmark2 != null) {
          // You might check landmark.likelihood here if you want to skip low confidence
          if (landmark1.likelihood < 0.3 || landmark2.likelihood < 0.3) return;
          
          canvas.drawLine(
            Offset(translateX(landmark1.x), translateY(landmark1.y)),
            Offset(translateX(landmark2.x), translateY(landmark2.y)),
            paintType,
          );
        }
      }

      // Left arm and hand
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftLinePaint);
      paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftLinePaint);
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftThumb, leftLinePaint);
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftIndex, leftLinePaint);
      paintLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinky, leftLinePaint);
      paintLine(PoseLandmarkType.leftPinky, PoseLandmarkType.leftIndex, leftLinePaint);

      // Right arm and hand
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightLinePaint);
      paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightLinePaint);
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightThumb, rightLinePaint);
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightIndex, rightLinePaint);
      paintLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinky, rightLinePaint);
      paintLine(PoseLandmarkType.rightPinky, PoseLandmarkType.rightIndex, rightLinePaint);

      // Torso
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, leftLinePaint);
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftLinePaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightLinePaint);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, leftLinePaint);

      // Legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftLinePaint);
      paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftLinePaint);
      paintLine(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel, leftLinePaint);
      paintLine(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftFootIndex, leftLinePaint);
      paintLine(PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex, leftLinePaint);
      
      paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightLinePaint);
      paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightLinePaint);
      paintLine(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel, rightLinePaint);
      paintLine(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightFootIndex, rightLinePaint);
      paintLine(PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex, rightLinePaint);

      // Draw Landmarks (Joints)
      pose.landmarks.values.forEach((landmark) {
        if (landmark.likelihood < 0.3) return; // Skip drawing faint landmarks
        canvas.drawCircle(
          Offset(translateX(landmark.x), translateY(landmark.y)),
          4,
          pointPaint,
        );
      });
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize ||
           oldDelegate.poses != poses ||
           oldDelegate.isFrontCamera != isFrontCamera;
  }
}
