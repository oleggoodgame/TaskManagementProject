import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_management/provider/profile_provider.dart';
import 'package:project_management/provider/week_provider.dart';
import 'package:project_management/screens/add_screen.dart';
import 'package:project_management/widgets/tasks_widget.dart';
import 'package:project_management/widgets/week_widget.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    final date = ref.watch(chooseWeekProvider).day;
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AddScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return const Text("Problem with profile");
          if (profile.employee == false) {
            return const Center(
              child: Text(
                "Please go to profile and join a company",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Column(
              children: [
                WeekWidget(),
                Expanded(child: TasksWidget(date: formattedDate)),
              ],
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
