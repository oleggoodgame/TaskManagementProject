import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/models/Week.dart';
import 'package:project_management/provider/week_provider.dart';
import 'package:project_management/widgets/card_week_widget.dart';

class WeekWidget extends ConsumerWidget {
  const WeekWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekList = ref.watch(weekProvider);
    final weekNotifier = ref.watch(weekProvider.notifier);
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: weekNotifier.removeWeek,
              icon: Icon(Icons.arrow_left_sharp),
              iconSize: 40,
            ),
            Spacer(),
            Center(
              child: Text(
                weekNotifier.mounth,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: weekNotifier.addWeek,
              icon: Icon(Icons.arrow_right_sharp),
              iconSize: 40,
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            itemCount: weekList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final week = weekList[index];
              final selectedWeek = ref.watch(chooseWeekProvider);

              return GestureDetector(
                onTap: () {
                  print(week.day.toString());

                  print(selectedWeek.day.toString());
                  ref.read(chooseWeekProvider.notifier).state = Week(
                    name: week.name,
                    day: week.day,
                    color: Colors.tealAccent,
                  );
                },
                child: CardWeekWidget(
                  week.name,
                  week.day,
                  selectedWeek.day == week.day ? Colors.tealAccent : week.color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
