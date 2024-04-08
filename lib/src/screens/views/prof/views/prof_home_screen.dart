import 'package:attendance_app/src/screens/views/prof/views/temp_map_screen.dart';
import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'create_course_screen.dart';

class ProfHome extends StatefulWidget {
  const ProfHome({super.key});

  @override
  State<ProfHome> createState() => _ProfHomeState();
}

class _ProfHomeState extends State<ProfHome> {
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Courses',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          centerTitle: true,
      ),
      body: currentUser.courses.isEmpty
        ? const Center(
          child: Text('You have no courses yet.')
        )
        : const Center(
          child: Text('You have courses.')
        ),
        // TODO: Implement the following ListView.builder
        
        // : ListView.builder(
        //   itemCount: currentUser.courses.length,
        //   itemBuilder: (context, index) {
        //     final course = currentUser.courses[index];
        //     return CourseInfo(
        //       courseName: course.courseName,
        //       courseInstructor: course.instructor,
        //       startTime: course.startTime,
        //       endTime: course.endTime,
        //       daysOfWeek: course.daysOfWeek,
        //     );
        //   },
        // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCourseScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CourseInfo extends StatelessWidget {
  final String courseName;
  final String courseInstructor;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<int> daysOfWeek;

  const CourseInfo({super.key, 
    required this.courseName,
    required this.courseInstructor,
    this.startTime = const TimeOfDay(hour: 10, minute: 20),
    this.endTime = const TimeOfDay(hour: 11, minute: 0),
    this.daysOfWeek = const [1, 3, 5]
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          ListTile(
            title: Text(courseName, 
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )
            ),
            subtitle: Text(courseInstructor, 
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 16,
              )
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${startTime.format(context)} - ${endTime.format(context)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )
                ),
                Text(daysOfWeek.map((day) {
                  switch (day) {
                    case 1:
                      return 'Mon';
                    case 2:
                      return 'Tue';
                    case 3:
                      return 'Wed';
                    case 4:
                      return 'Thu';
                    case 5:
                      return 'Fri';
                    case 6:
                      return 'Sat';
                    case 7:
                      return 'Sun';
                    default:
                      return '';
                  }
                }).join(', '),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}