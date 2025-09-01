import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/models/task.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, Task>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<Task> {
  TaskNotifier() : super(const Task("", "", Colors.redAccent));

  void updateColor(Color color) {
    state = state.copyWith(color: color);
  }
}
