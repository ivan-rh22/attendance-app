import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:attendance_app/src/blocs/get_courses_bloc/get_courses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'join_course_screen.dart';


class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  late final MyUser currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = context.read<AuthenticationBloc>().state.user!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        elevation: 1,
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),

      body: currentUser.courses.isEmpty
        ? const Center(
          child: Text('You have not joined any courses yet'),
        )
        : BlocBuilder<GetCoursesBloc, GetCoursesState> (
          builder:(context, state) {
            if (state is GetCoursesSuccess){
              return Center(
                child: Text('Courses found ${state.courses.length}'),
              );
            } else if (state is GetCoursesInProgress){
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else{
              return const Center(
                child: Text('Failed to get courses'),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // call the join course screen as a dialog
            showDialog(
              context: context,
              builder: (context) {
                return JoinCourseScreen();
              }
            );
          },
          tooltip: 'Join Course',
          child: const Icon(Icons.add),
        )
    );
  }
}