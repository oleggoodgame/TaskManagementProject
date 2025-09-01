import 'package:flutter/material.dart';

class Task {
  final String name;
  final String description;
  final Color color;

  const Task(this.name, this.description, this.color);

  Task copyWith({
    String? name,
    String? description,
    Color? color,
  }) {
    return Task(
      name ?? this.name,
      description ?? this.description,
      color ?? this.color,
    );
  }
}
