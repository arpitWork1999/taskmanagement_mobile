import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_tool/profile_screen.dart';
import 'package:task_management_tool/projects_screen.dart';
import 'package:task_management_tool/tasks_screen.dart';
import 'package:task_management_tool/user_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const UserScreen(),
    const ProjectScreen(),
    const TaskScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: _screens[_currentIndex],
       bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
           
        ]
       )
    );
  }
}
