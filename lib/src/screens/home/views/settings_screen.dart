// Settings screen (logout button found here)
import 'package:attendance_app/src/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(//NOTES BELOW
      appBar: AppBar(
        title: const Text('Settings'), centerTitle: true
      ),
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

//Yet to find a way to display the email of the student given that this is a settings page, probably a good idea
//to add a password reset in the future (if we stay 3rd party) and some way to display the user's name
//I have some idea but not quite sure yet.