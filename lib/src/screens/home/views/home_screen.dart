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
    Text('hello for now!'), //This is where the camera screen is being listed
    Text('Home screen'), // This is where the home screen is being listed (currently no widget control)
    SettingsScreen(), //This is hopefully how the two above should look once those screens are set up
  ]; // it essentially leads to another file that populates the screen with the right info.
  
  @override
  Widget build(BuildContext context) { //Here the navigation bar is created, given logos, and names
    return Scaffold(
      body: Center(child: screens[aindex]),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: aindex, //where navbar is first selected (in this case it will be home)
        onDestinationSelected: (index) => setState(() => aindex = index),//(index) => setState(() => aindex = index), <- ignore for now
        destinations:const [ //Here are the three current destinations in the navigation bar.
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