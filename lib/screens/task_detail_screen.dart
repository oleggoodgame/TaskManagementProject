import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_management/data/const_inputDecoration.dart';
import 'package:project_management/database/database.dart';
import 'package:project_management/provider/profile_provider.dart';
import 'package:project_management/provider/task_provider.dart';
import 'package:project_management/provider/week_provider.dart';
import 'package:project_management/widgets/color_widget.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String description;
  final Color color;

  const TaskDetailScreen(
    this.id,
    this.name,
    this.color,
    this.description, {
    super.key,
  });

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late Color selectedColor;

  final _formKey = GlobalKey<FormState>();
  final db = DatabaseService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    selectedColor = widget.color;
  }

  void _update() async {
    if (_formKey.currentState!.validate()) {
      final date = ref.read(chooseWeekProvider).day;
      final color = ref.read(taskProvider).color.toARGB32();
      final formattedDate = DateFormat('dd-MM-yyyy').format(date);
      ref.read(profileProvider);
      await db.updateTask(
        formattedDate,
        widget.id,
        ref.read(profileProvider).value?.idCompany,
        _nameController.text,
        _descriptionController.text,
        color,
      );
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _delete() async {
    final date = ref.read(chooseWeekProvider).day;
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);
    await db.deleteTask(
      formattedDate,
      widget.id,
      ref.read(profileProvider).value!.idCompany!,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Description"),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Description is required';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  "Pick your color",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                ColorPicker(selectedColor: selectedColor),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _update,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _delete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                    ),
                    child: const Text(
                      "DELETE",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
