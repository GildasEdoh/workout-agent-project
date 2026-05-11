import 'package:flutter/material.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final String difficulty;
  final List<String> instructions;
  final List<String> musclesTargeted;
  final IconData icon;
  final String imageUrl; // For exercise illustration

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.instructions,
    required this.musclesTargeted,
    required this.icon,
    this.imageUrl = '',
  });
}
