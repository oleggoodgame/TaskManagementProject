import 'package:flutter/material.dart';

class MoreCard extends StatelessWidget {
  final Icon icon;
  final String title;

  const MoreCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 110, 110, 110),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.navigate_next_outlined,
                color: Color.fromARGB(255, 110, 110, 110),
              ),
            ],
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: double.infinity,
            child: const Divider(
              height: 5,
              thickness: 1,
              color: Color.fromARGB(255, 110, 110, 110),
            ),
          ),
        ],
      ),
    );
  }
}
