import 'package:attendance_app/src/screens/views/prof/views/temp_map_screen.dart';
import 'package:flutter/material.dart';

class ProfHome extends StatefulWidget {
  const ProfHome({super.key});

  @override
  State<ProfHome> createState() => _ProfHomeState();
}

class _ProfHomeState extends State<ProfHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: () {Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfMap()));} , 
          child: const Text('goto temporary map screen'))
      ]),)
    );
  }
}