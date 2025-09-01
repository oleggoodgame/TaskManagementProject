import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/database/database.dart';
import 'package:project_management/provider/profile_provider.dart';
import 'package:project_management/widgets/task_widget.dart';

class TasksWidget extends ConsumerStatefulWidget {
  final String date;

  const TasksWidget({super.key, required this.date});

  @override
  ConsumerState<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends ConsumerState<TasksWidget> {
  final DatabaseService _dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final textgr = ref.read(profileProvider);

    return StreamBuilder<QuerySnapshot>(
      stream: _dbService.getTasks(textgr.asData?.value?.idCompany, widget.date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Expanded(child: const Center(child: Text("No tasks yet")));
        }

        final tasks = snapshot.data!.docs;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            final title = taskData['name'] ?? 'Untitled';
            final description = taskData['description'] ?? '';
            final color = taskData['color'] ?? 0xFFFFFFFF;
            final profile = taskData['profile'];
            return TaskWidget(
              title,
              description,
              Color(color),
              profile,
              tasks[index].id,
            );
          },
        );
      },
    );
  }
}
