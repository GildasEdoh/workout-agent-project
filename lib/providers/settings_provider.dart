import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _soundEnabled = true;
  bool _voiceFeedbackEnabled = true;
  bool _darkMode = true;

  bool get soundEnabled => _soundEnabled;
  bool get voiceFeedbackEnabled => _voiceFeedbackEnabled;
  bool get darkMode => _darkMode;

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  void toggleVoiceFeedback() {
    _voiceFeedbackEnabled = !_voiceFeedbackEnabled;
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
