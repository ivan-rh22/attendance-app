//Home screen or Post-Login welcome screen
import 'package:attendance_app/src/screens/home/views/prof/tester_screen.dart';
import 'package:attendance_app/src/screens/home/views/settings_screen.dart';
import 'package:attendance_app/src/screens/home/views/stud/camera_screen.dart';
import 'package:attendance_app/src/screens/home/views/stud/student_home_screen.dart';
import 'package:flutter/material.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int aindex = 1;
  List<Widget> profscreens = const [ //This is the list that will hold the professor screens
    Tester(),
    SettingsScreen()
  ];
  List<Widget> screens = const [
    Camera(), //This is where the camera screen is being listed
    StudentHome(), // Student homescreen as default.
    SettingsScreen(), //This is hopefully how the two above should look once those screens are set up
  ]; // it essentially leads to another file that populates the screen with the right info.
  
  
  @override
  Widget build(BuildContext context) { //Here the navigation bar is created, given logos, and names
    return Scaffold(
      body: Center(child: screens[aindex]),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.amber,
        backgroundColor: Colors.orange,
        height: 60,
        selectedIndex: aindex, //where navbar is first selected (in this case it will be home)
        onDestinationSelected: (index) => setState(() => aindex = index),//(index) => setState(() => aindex = index), <- ignore for now
        destinations:const [ //Here are the three current destinations in the navigation bar.
          NavigationDestination(icon: Icon(Icons.camera_alt_outlined), 
          selectedIcon: Icon(Icons.camera_alt), 
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