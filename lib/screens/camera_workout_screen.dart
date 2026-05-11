import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pose_tracker/models/exercise.dart';
import 'package:pose_tracker/core/theme/app_colors.dart';
import 'package:pose_tracker/screens/result_screen.dart';

class CameraWorkoutScreen extends StatefulWidget {
  final Exercise exercise;

  const CameraWorkoutScreen({super.key, required this.exercise});

  @override
  State<CameraWorkoutScreen> createState() => _CameraWorkoutScreenState();
}

class _CameraWorkoutScreenState extends State<CameraWorkoutScreen> {
  int _reps = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _isPaused = false;
  bool _isCountdown = true;
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
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
          // Simulate rep increment every 4 seconds
          if (_seconds % 4 == 0) {
            _reps++;
          }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Mocking camera background
      body: Stack(
        children: [
          // MOCK CAMERA VIEW OR SKELETON
          Center(
            child: Icon(
              Icons.accessibility_new,
              size: 250,
              color: Colors.white.withOpacity(0.2), // Skeleton mock
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.exercise.name,
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _formatTime(),
                              style: const TextStyle(fontSize: 18, color: Colors.white),
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
                  Text(
                    _reps.toString(),
                    style: const TextStyle(
                      fontSize: 140,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 20, color: AppColors.primary)],
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
}
