import 'package:flutter/material.dart';

class Week {
  final String name;
  final DateTime day;
  final Color color; 

  const Week({
    required this.name,
    required this.day,
    this.color = const Color.fromARGB(255, 255, 255, 255),
  });
}
