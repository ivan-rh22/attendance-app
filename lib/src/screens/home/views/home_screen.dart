
import 'package:attendance_app/src/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Auto Attendance'),
            ElevatedButton(
              onPressed: () {
                context.read<SignInBloc>().add(SignOutRequired());
              },
              child: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}