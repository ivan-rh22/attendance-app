import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 201, 64, 0),
        title: const Text('Student Home', style: TextStyle(color: Colors.white)), centerTitle: true
      ),
      body: const Center(
        child: Text('student\'s Home Screen'),
      ),
    );
  }
}