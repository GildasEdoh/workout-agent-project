import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pose_tracker/core/ml/mediapipe_pose_service.dart';
import 'package:pose_tracker/core/ml/rep_counter.dart';
import 'package:pose_tracker/models/exercise.dart';
import 'package:pose_tracker/core/theme/app_colors.dart';
import 'package:pose_tracker/screens/result_screen.dart';
import 'package:pose_tracker/widgets/pose_painter.dart';

class CameraWorkoutScreen extends StatefulWidget {
  final Exercise exercise;

  const CameraWorkoutScreen({super.key, required this.exercise});

  @override
  State<CameraWorkoutScreen> createState() => _CameraWorkoutScreenState();
}

class _CameraWorkoutScreenState extends State<CameraWorkoutScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  final MediaPipePoseService _poseDetector = MediaPipePoseService();
  late RepCounter _repCounter;
  List<Pose> _poses = [];
  bool _isFrontCamera = true;

  int _reps = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _isPaused = false;
  bool _isCountdown = true;
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _repCounter = RepCounter(widget.exercise);
    _initializeCamera();
    _startCountdown();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      // Use front camera if available
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );

      try {
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
            _isFrontCamera = frontCamera.lensDirection == CameraLensDirection.front;
          });
          
          _controller!.startImageStream((CameraImage image) async {
            if (_isPaused || _isCountdown) return;

            final poses = await _poseDetector.processCameraImage(
              image,
              _controller!.description.sensorOrientation,
              _controller!.description.lensDirection,
            );

            // If poses is null, the detector was busy running on a previous frame.
            if (poses == null) return;

            if (mounted) {
              setState(() {
                _poses = poses;
              });

              // Process each pose for rep counting (usually we just track the main person, index 0)
              if (poses.isNotEmpty) {
                if (_repCounter.countRep(poses.first)) {
                  setState(() {
                    _reps++;
                  });
                }
              }
            }
          });
        }
      } catch (e) {
        debugPrint('Camera initialization error: $e');
      }
    }
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _isCountdown = false;
          timer.cancel();
          _startWorkout();
        }
      });
    });
  }

  void _startWorkout() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (!_isPaused) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _stopWorkout() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          exercise: widget.exercise,
          reps: _reps,
          durationSeconds: _seconds,
        ),
      ),
    );
  }

  String _formatTime() {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.stopImageStream();
    _controller?.dispose();
    _poseDetector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Mocking camera background
      body: Stack(
        children: [
          // CAMERA PREVIEW
          if (_isCameraInitialized && _controller != null)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_controller!),
                    if (!_isCountdown)
                      CustomPaint(
                        painter: PosePainter(
                          poses: _poses,
                          // Render logic uses physical camera dimensions to map to screen
                          imageSize: Size(_controller?.value.previewSize?.height ?? 640, _controller?.value.previewSize?.width ?? 480),
                          isFrontCamera: _isFrontCamera,
                        ),
                      ),
                  ],
                ),
              ),
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TOP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassContainer(
                        child: Text(
                          widget.exercise.name,
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildGlassContainer(
                        child: Row(
                          children: [
                            const Icon(Icons.timer, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _formatTime(),
                              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // CENTER REP COUNTER & COUNTDOWN
                if (_isCountdown)
                  Center(
                    child: Text(
                      _countdown.toString(),
                      style: const TextStyle(fontSize: 120, color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  _buildGlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Text(
                      _reps.toString(),
                      style: const TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 20, color: AppColors.primary)],
                      ),
                    ),
                  ),

                // BOTTOM CONTROLS & FEEDBACK
                Column(
                  children: [
                    if (!_isCountdown)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Good form! Keep going.',
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: 'pause_btn',
                            backgroundColor: Colors.white24,
                            elevation: 0,
                            onPressed: _togglePause,
                            child: Icon(_isPaused ? Icons.play_arrow : Icons.pause, color: Colors.white),
                          ),
                          const SizedBox(width: 32),
                          FloatingActionButton(
                            heroTag: 'stop_btn',
                            backgroundColor: AppColors.error,
                            onPressed: _stopWorkout,
                            child: const Icon(Icons.stop, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGlassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
