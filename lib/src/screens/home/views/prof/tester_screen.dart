import 'package:flutter/material.dart';

class Tester extends StatefulWidget {
  const Tester({super.key});

  @override
  State<Tester> createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 201, 64, 0),
        title: const Text('Tester', style: TextStyle(color: Colors.white)), centerTitle: true
      ),
      body: const Center(
        child: Text('Face Scan/Picture'),
      ),
    );
  }
}