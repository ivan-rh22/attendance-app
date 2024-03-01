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
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('Camera',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          centerTitle: true),
      body: const Center(
        child: Text('Face Scan/Picture'),
      ),
    );
  }
}
