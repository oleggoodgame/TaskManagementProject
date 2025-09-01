import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_management/models/Week.dart';

final weekProvider = StateNotifierProvider<WeekNotifier, List<Week>>((ref) {
  return WeekNotifier();
});

class WeekNotifier extends StateNotifier<List<Week>> {
  int _week = 0;
  String get mounth {
    final now = DateTime.now();

    final week = now
        .subtract(Duration(days: now.weekday - 1))
        .add(Duration(days: _week * 7));
    final monthName = DateFormat.MMMM().format(week);

    return monthName;
  }

  WeekNotifier() : super([]) {
    state = _getWeeks();
  }

  List<Week> _getWeeks() {
    final now = DateTime.now();
    final monday = now
        .subtract(Duration(days: now.weekday - 1))
        .add(Duration(days: _week * 7));

    final List<Week> weeks = [];

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final name = DateFormat('EEEE').format(day);
      final dateOnly = DateTime(day.year, day.month, day.day);

      if (i >= 5) {
        weeks.add(Week(name: name, day: dateOnly, color: Colors.red.shade400));
      } else {
        weeks.add(Week(name: name, day: dateOnly));
      }
    }

    return weeks;
  }

  void addWeek() {
    _week++;
    state = _getWeeks();
  }

  void removeWeek() {
    _week--;
    state = _getWeeks();
  }
}

final chooseWeekProvider = StateProvider<Week>((ref) {
  final now = DateTime.now();
  final dateOnly = DateTime(now.year, now.month, now.day);

  final name = DateFormat('EEEE').format(now);
  return Week(name: name, day: dateOnly, color: Colors.tealAccent);
});
