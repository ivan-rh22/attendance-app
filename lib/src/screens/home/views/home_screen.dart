//Home screen or Post-Login welcome screen
import 'package:attendance_app/src/screens/home/views/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int aindex = 1;
  List<Widget> screens = const [
    Text('hello for now!'),
    Text('Home screen'),
    SettingsScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: screens[aindex]),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: aindex,
        onDestinationSelected: (index) => setState(() => aindex = index),//(index) => setState(() => aindex = index),
        destinations:const [
          NavigationDestination(icon: Icon(Icons.map_outlined), 
          selectedIcon: Icon(Icons.map), 
          label: 'CAMERA', 
          ),
          NavigationDestination(icon: Icon(Icons.home_outlined), 
          selectedIcon: Icon(Icons.home_filled), 
          label: 'HOME',
          ),
          NavigationDestination(icon: Icon(Icons.settings_outlined), 
          selectedIcon: Icon(Icons.settings), 
          label: 'SETTINGS',
          ),
        ],
      ),
    );
  }
}