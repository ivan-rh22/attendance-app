import 'package:flutter/material.dart';

class CreateCourseScreen extends StatelessWidget {
  const CreateCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Course'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text('create course form here')
            ],
          ),
        ),
      ),
    );
  }
}