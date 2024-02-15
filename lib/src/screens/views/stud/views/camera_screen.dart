import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 201, 64, 0),
        title: const Text('Camera', style: TextStyle(color: Colors.white)), centerTitle: true
      ),
      body: const Center(
        child: Text('Face Scan/Picture'),
      ),
    );
  }
}