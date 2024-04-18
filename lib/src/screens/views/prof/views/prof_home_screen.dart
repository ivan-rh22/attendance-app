import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:attendance_app/src/blocs/get_courses_bloc/get_courses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'course_details_screen.dart';
import 'create_course_screen.dart';

class ProfHome extends StatefulWidget {
  const ProfHome({super.key});

  @override
  State<ProfHome> createState() => _ProfHomeState();
}

class _ProfHomeState extends State<ProfHome> {
  late final MyUser currentUser;
  final ScrollController _scrollController = ScrollController();
  // TODO: Implement reload (pull to refresh)
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    currentUser = context.read<AuthenticationBloc>().state.user!;
    context.read<GetCoursesBloc>().add(GetCourses(currentUser.userId));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200.0 &&
        !_scrollController.position.outOfRange) {
      setState(() {
        // _isLoading = true;
      });
      
      context.read<GetCoursesBloc>().add(GetCourses(currentUser.userId));
    }
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
          child: Text('You have no courses yet.')
        )
        : BlocBuilder<GetCoursesBloc, GetCoursesState> (
          builder: (context, state) {
            if(state is GetCoursesSuccess){
              // _isLoading = false;
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
            } else {
              return const Center(
                child: Text('Failed to get courses'),
                
              );
            }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCourseScreen(),
            ),
          );
        },
        tooltip: 'Create Course',
        child: const Icon(Icons.add),
      ),
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
    this.startTime = const TimeOfDay(hour: 10, minute: 20),
    this.endTime = const TimeOfDay(hour: 11, minute: 0),
    this.daysOfWeek = const [1, 3, 5]
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => CourseDetailsScreen(courseId: courseId))
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
                children: [
                  Text('${startTime.format(context)} - ${endTime.format(context)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 14,
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