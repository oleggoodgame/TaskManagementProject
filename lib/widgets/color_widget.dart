import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_management/provider/task_provider.dart';

class ColorPicker extends ConsumerStatefulWidget {
  final Color? selectedColor;

  const ColorPicker({super.key, this.selectedColor});

  @override
  ConsumerState<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends ConsumerState<ColorPicker> {
  late Color selectedColor;

  final List<Color> brightColors = [
    Colors.redAccent,
    Colors.redAccent.shade100,
    Colors.purpleAccent,
    Colors.pinkAccent.shade100,
    Colors.pinkAccent,
    Colors.indigoAccent.shade200,
    Colors.blueAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.deepPurpleAccent.shade100,
    Colors.purple,
    Colors.cyanAccent,
    Colors.lightGreenAccent,
    Colors.yellowAccent,
    Colors.limeAccent,
    Colors.amberAccent,
    Colors.blueGrey,
    Colors.grey,
    Colors.lightBlue,
  ];

  @override
  void initState() {
    super.initState();
    final task = ref.read(taskProvider);
    selectedColor = widget.selectedColor ?? task.color;
  }

  @override
  Widget build(BuildContext context) {

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(brightColors.length, (index) {
        final color = brightColors[index];
        final isSelected = selectedColor.value == color.value;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = color;
            });
            ref.read(taskProvider.notifier).updateColor(color);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
