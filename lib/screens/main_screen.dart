import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import '../controllers/theme_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ThemeController themeController = Get.find<ThemeController>(); // ✅ Ensure ThemeController is found

  final List<Widget> _screens = [
    HomeScreen(),  // Daily Transactions
    StatsScreen(), // Graph & Stats
    SettingsScreen(), // Settings Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list), label: "Transactions"),
                BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.pinkAccent,
              onTap: _onItemTapped,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Open Add Transaction Screen
            },
            backgroundColor: Colors.pinkAccent,
            child: const Icon(Icons.add, size: 28),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ));
  }
}
