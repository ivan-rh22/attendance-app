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
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('Student Home',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          centerTitle: true),
      body: const Center(
        child: Text('Student Home Screen'),
      ),
    );
  }
}
