import 'package:flutter/material.dart';
import '../../../../blocs/get_course_bloc/get_course_bloc.dart';

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
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.courseStream, 
      builder: (context, snapshot){
        if(snapshot.hasData){
          final course = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(course?.courseName ?? 'Course Details'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  // hint: 'Edit course details',
                  tooltip: 'Edit course details',
                  onPressed: () {},
                ),
              ],
            ),
            body: Column (
              children: [
                Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text('Course Details', 
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(indent: 30, endIndent: 30),
                      ListTile(
                        title: const Text('Room Number'),
                        subtitle: Text(course?.roomNumber ?? ''),
                      ),
                      ListTile(
                        title: const Text('Days of the Week'),
                        subtitle: Text(course?.daysOfWeek.join(', ') ?? ''),
                      ),
                      ListTile(
                        title: const Text('Start Time'),
                        subtitle: Text(course?.startTime.format(context) ?? ''),
                      ),
                      ListTile(
                        title: const Text('End Time'),
                        subtitle: Text(course?.endTime.format(context) ?? ''),
                      ),
                      ListTile(
                        title: const Text('Class Code'),
                        subtitle: Text(course?.accessToken ?? ''),
                      )
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  child: StreamBuilder(
                    stream: course?.instructorReference.snapshots(),
                    builder:(context, snapshot) {
                      if(snapshot.hasData){
                        final instructorData = snapshot.data?.data() as Map<String, dynamic>;
                        final instructorName = (instructorData)['name'] ?? 'Instructor Not Found';
                        final instructorEmail = (instructorData)['email'] ?? 'Instructor Not Found'; 
                        return Column(
                          children: [
                            const Text('Instructor Details', 
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(indent: 30, endIndent: 30),
                            ListTile(
                              title: const Text('Name:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(instructorName),
                            ), 
                            ListTile(
                              title: const Text('Email:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(instructorEmail),
                            ),
                          ],
                        );
                      }
                      else if(snapshot.hasError){
                        return const Text('Failed to get instructor details');
                      }
                      else {
                        return const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              Text('Loading instructor details'),
                            ]
                          ),
                        );
                      }
                    },
                  )
                ),
                const Text('Students', 
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: course?.studentIds.length,
                    itemBuilder: (context, index) {
                      final student = course?.studentIds[index];
                      return Student(
                        studentName: student!,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if(snapshot.hasError){
          return const Center(
            child: Text('Failed to get course details'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}

class Student extends StatelessWidget {
  final String studentName;

  const Student({
    super.key,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // TODO: Replace with student profile picture
      leading: const Icon(Icons.person),
      title: Text(studentName),
      onTap: () {
        // TODO: Navigate to student details screen
      },
    );
  }
}