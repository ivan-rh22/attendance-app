// Settings screen (logout button found here)
import 'package:attendance_app/src/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/authentication_bloc/authentication_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final MyUser currentUser;
  final String userProfilePhotoUrl = 'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg';

  @override
  void initState() {
    super.initState();
    currentUser = context.read<AuthenticationBloc>().state.user!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 1.5,
              margin: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(userProfilePhotoUrl),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(currentUser.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                  const Divider(indent: 40, endIndent: 40,),
                  ListTile(
                    leading: const Icon(Icons.perm_identity),
                    title: const Text('UserID:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(currentUser.userId),
                  ),
                  ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Email:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(currentUser.email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.key),
                    title: const Text('Role:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(currentUser.isTeacher ? 'Teacher' : 'Student'),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 1.5,
              margin: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: [
                  //
                  const Text('General Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: const Text('Theme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text('Change the theme'),
                      trailing: DropdownButton<String>(
                        value: 'Default', // Replace with theme value
                        onChanged: (String? newValue) {
                          setState(() {
                            // change theme
                          });
                        },
                        items: <String>['Default', 'Light', 'Dark']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Manage notifications'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Change the language'),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 1.5,
              margin: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: [
                  //
                  const Text('Account Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Change your password'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Text('Delete your account',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  // sign out button
                  ListTile(
                    enableFeedback: true,
                    key: const Key('sign_out_button'),
                    // when pressed, sign out
                    onTap: () {
                      context.read<SignInBloc>().add(SignOutRequired());
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text('Log out of your account'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
