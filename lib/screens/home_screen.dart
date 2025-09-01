import 'package:flutter/material.dart';
import 'package:project_management/screens/profile_screen.dart';
import 'package:project_management/screens/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    TasksScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          _buildNavItem(Icons.task_alt, "Tasks", 0,),
          _buildNavItem(Icons.person, "Profile", 1),
        ],
      ),
    );
  }
  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: isSelected ? 1.5 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: Icon(icon, color: Colors.black,),
      ),
      label: label,
    );
  }
}

