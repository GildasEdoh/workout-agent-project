import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MediaPipePoseService {
  final PoseDetector _poseDetector;
  bool _isBusy = false;

  MediaPipePoseService()
      : _poseDetector = PoseDetector(
          options: PoseDetectorOptions(
            model: PoseDetectionModel.base,
            mode: PoseDetectionMode.stream,
          ),
        );

  Future<List<Pose>?> processCameraImage(
      CameraImage image, int sensorOrientation, CameraLensDirection lensDirection) async {
    if (_isBusy) return null;
    _isBusy = true;

    try {
      final inputImage = _inputImageFromCameraImage(image, sensorOrientation, lensDirection);
      if (inputImage == null) {
        debugPrint('MediaPipe Debug: _inputImageFromCameraImage returned null');
        _isBusy = false;
        return null;
      }

      final poses = await _poseDetector.processImage(inputImage);
      debugPrint('MediaPipe Debug: Detected ${poses.length} poses');
      _isBusy = false;
      return poses;
    } catch (e) {
      debugPrint('MediaPipe Error: $e');
      _isBusy = false;
      return null;
    }
  }

  InputImage? _inputImageFromCameraImage(
      CameraImage image, int sensorOrientation, CameraLensDirection lensDirection) {
    // Determine the InputImageRotation
    final InputImageRotation? rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) {
       debugPrint('MediaPipe Debug: Invalid sensorOrientation $sensorOrientation');
       return null;
    }

    // Determine the InputImageFormat
    final InputImageFormat? format = InputImageFormatValue.fromRawValue(image.format.raw);
    
    // Only supported formats are nv21, yv12, bgra8888
    if (format == null || 
        (defaultTargetPlatform == TargetPlatform.android && format != InputImageFormat.nv21 && format != InputImageFormat.yv12) ||
        (defaultTargetPlatform == TargetPlatform.iOS && format != InputImageFormat.bgra8888)) {
      // NOTE: ML Kit supports bgra8888 on iOS, and nv21/yv12 on Android.
      // Usually camera plugin on Android uses yuv420! We must construct the planes.
    }

    if (image.planes.isEmpty) return null;

    final plane = image.planes.first;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    // Compose InputImageMetadata
    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation, // user sensor orientation directly
      format: defaultTargetPlatform == TargetPlatform.iOS 
          ? InputImageFormat.bgra8888 
          // Force NV21 on Android since MLKit native requires it instead of YUV_420_888
          : InputImageFormat.nv21,
      bytesPerRow: image.planes[0].bytesPerRow, // Use first plane
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }


  void dispose() {
    _poseDetector.close();
  }
}
