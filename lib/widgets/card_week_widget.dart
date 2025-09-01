import 'package:flutter/material.dart';

class CardWeekWidget extends StatelessWidget {
  const CardWeekWidget(this.name, this.dateTime, this.color, {super.key});

  final Color color;
  final DateTime dateTime;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,  
      height: 80,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.5),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dateTime.day.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
