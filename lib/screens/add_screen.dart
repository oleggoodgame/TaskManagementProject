import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_management/data/const_inputDecoration.dart';
import 'package:project_management/database/database.dart';
import 'package:project_management/provider/profile_provider.dart';
import 'package:project_management/provider/task_provider.dart';
import 'package:project_management/provider/week_provider.dart';
import 'package:project_management/widgets/color_widget.dart';

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({super.key});

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  final _nameController = TextEditingController();
  final _desciptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseService();
  @override
  void dispose() {
    _nameController.dispose();
    _desciptionController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _desciptionController.text;
      final color = ref.read(taskProvider).color.toARGB32();
      final date = ref.read(chooseWeekProvider).day;
      final formattedDate = DateFormat('dd-MM-yyyy').format(date);
      print(formattedDate);
      await db.addTask(
        formattedDate,
        name,
        description,
        ref.read(profileProvider).value!.idCompany,
        color,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Task")),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 14,
          bottom: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _desciptionController,
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Description"),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  "Pick your collor",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                ColorPicker(),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
