import 'package:attendance_app/src/screens/views/prof/views/prof_home_screen.dart';
import 'package:attendance_app/src/screens/views/settings_screen.dart';
import 'package:flutter/material.dart';

class ProfControl extends StatefulWidget {
  const ProfControl({super.key});

  @override
  State<ProfControl> createState() => _ProfControlState();
}

class _ProfControlState extends State<ProfControl> {
  int aindex = 1;
  List<Widget> screens = const [
    ProfHome(),
    SettingsScreen(), 
  ];
  
  
  @override
  Widget build(BuildContext context) { //Here the navigation bar is created, given logos, and names
    return Scaffold(
      body: Center(child: screens[aindex]),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        height: 60,
        selectedIndex: aindex, //where navbar is first selected (in this case it will be home)
        onDestinationSelected: (index) => setState(() => aindex = index),//(index) => setState(() => aindex = index), <- ignore for now
        destinations:const [ //Here are the three current destinations in the navigation bar.
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