import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import '../blocs/get_course_bloc/get_course_bloc.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final _bloc = GetCourseBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(GetCourse(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
      ),
      body: StreamBuilder<Course>(
        stream: _bloc.courseStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final course = snapshot.data;
            return Column(
              children: [
                Text('Course Name: ${course?.courseName}'),
                Text('Instructor: ${course?.instructorId}'),
                Text('Start Time: ${course?.startTime}'),
                Text('End Time: ${course?.endTime}'),
                Text('Days of the Week: ${course?.daysOfWeek}'),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to get course details'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}