import 'package:attendance_app/src/screens/views/settings_screen.dart';
import 'package:attendance_app/src/screens/views/stud/views/camera_screen.dart';
import 'package:attendance_app/src/screens/views/stud/views/student_home_screen.dart';
import 'package:flutter/material.dart';

class StudControl extends StatefulWidget {
  const StudControl({super.key});

  @override
  State<StudControl> createState() => _StudControlState();
}

class _StudControlState extends State<StudControl> {
  int aindex = 1;
  List<Widget> screens = const [
    Camera(), //This is where the camera screen is being listed
    StudentHome(), // Student homescreen as default.
    SettingsScreen(), //This is hopefully how the two above should look once those screens are set up
  ]; // it essentially leads to another file that populates the screen with the right info.

  @override
  Widget build(BuildContext context) {
    //Here the navigation bar is created, given logos, and names
    return Scaffold(
      body: Center(child: screens[aindex]),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primary,
        height: 60,
        selectedIndex: aindex, //where navbar is first selected (in this case it will be home)
        onDestinationSelected: (index) => setState(() => aindex = index), //(index) => setState(() => aindex = index), <- ignore for now
        destinations: const [
          //Here are the three current destinations in the navigation bar.
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'CAMERA',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_filled),
            label: 'HOME',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            key: Key('settings_page_button'),
            selectedIcon: Icon(Icons.settings),
            label: 'SETTINGS',
          ),
        ],
      ),
    );
  }
}
