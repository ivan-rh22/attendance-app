import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:attendance_app/src/blocs/get_courses_bloc/get_courses_bloc.dart';
import 'package:attendance_app/src/screens/views/stud/views/course_details_screen.dart';
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
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.09),
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
              return ListView.builder(
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  final course = state.courses[index];
                  return CourseInfo(
                    courseId: course.courseId,
                    courseName: course.courseName,
                    roomNumber: course.roomNumber,
                    startTime: course.startTime,
                    endTime: course.endTime,
                    daysOfWeek: course.daysOfWeek,
                  );
                },
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
            showDialog(
              context: context,
              builder: (context) {
                return const JoinCourseScreen();
              }
            );
          },
          tooltip: 'Join Course',
          child: const Icon(Icons.add),
        )
    );
  }
}

class CourseInfo extends StatelessWidget {
  final String courseId;
  final String courseName;
  final String roomNumber;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<int> daysOfWeek;

  const CourseInfo({super.key, 
    required this.courseId,
    required this.courseName,
    required this.roomNumber,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek
  });

  // function to check if the current day is in the list of days of the week and if the current time is between the start and end time
  bool _isCourseHappening() {
    final int now = DateTime.now().weekday;
    final DateTime currentTime = DateTime.now();

    if (daysOfWeek.contains(now-1)) {
      DateTime startTime = DateTime.now();
      DateTime endTime = DateTime.now();
      startTime = DateTime(startTime.year, startTime.month, startTime.day, this.startTime.hour, this.startTime.minute);
      endTime = DateTime(endTime.year, endTime.month, endTime.day, this.endTime.hour, this.endTime.minute);

      return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => StudCourseDetailsScreen(courseId: courseId))
        );
      },
      child: Card(
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
                  fontSize: 24,
                )
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.location_on, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  const SizedBox(width: 5,),
                  Text(roomNumber,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _isCourseHappening() ? [
                  const Icon(Icons.access_time, color: Colors.red),
                  const Text('Course in Progress',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    )
                  ),
                ] : [
                  Text('${startTime.format(context)} - ${endTime.format(context)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 14,
                    )
                  ),
                  Text(daysOfWeek.map((day) {
                    switch (day) {
                      case 0:
                        return 'Mon';
                      case 1:
                        return 'Tue';
                      case 2:
                        return 'Wed';
                      case 3:
                        return 'Thu';
                      case 4:
                        return 'Fri';
                      case 5:
                        return 'Sat';
                      case 6:
                        return 'Sun';
                      default:
                        return '';
                    }
                  }).join(', '),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 14,
                    )
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