import 'package:attendance_app/src/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/join_course_bloc/join_course_bloc.dart';

class JoinCourseScreen extends StatefulWidget {
  const JoinCourseScreen({super.key});

  @override
  State<JoinCourseScreen> createState() => _JoinCourseScreenState();
}

class _JoinCourseScreenState extends State<JoinCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final courseCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return pop up dialog
    return BlocListener<JoinCourseBloc, JoinCourseState>(
      listener: (context, state) {
        if (state is JoinCourseSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Course joined successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is JoinCourseFailure) {
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(state.error),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is AlreadyJoined) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text(state.message),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: AlertDialog(
          title: const Text('Join Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Enter the course code to join a course'),
              MyTextField(
                obscureText: false,
                keyboardType: TextInputType.text,
                controller: courseCodeController,
                hintText: 'Course Code',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a course code';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    context.read<JoinCourseBloc>().add(
                        JoinCourseRequest(
                          accessKey: courseCodeController.text,
                          userId: context.read<AuthenticationBloc>().state.user!.userId,
                        ),
                      );
                  });
                }
              },
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
