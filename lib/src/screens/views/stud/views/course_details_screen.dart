import 'package:attendance_app/src/screens/views/stud/views/clock_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../blocs/get_course_bloc/get_course_bloc.dart';

class StudCourseDetailsScreen extends StatefulWidget {
  final String courseId;
  const StudCourseDetailsScreen({super.key, required this.courseId});

  @override
  State<StudCourseDetailsScreen> createState() => _StudCourseDetailsScreenState();
}

class _StudCourseDetailsScreenState extends State<StudCourseDetailsScreen> {
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
                      const Text('Course Details:', 
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(indent: 30, endIndent: 30),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Room Number:', 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(course?.roomNumber ?? ''),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Days of the Week:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(course?.daysOfWeek.join(', ') ?? ''),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Start Time:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(course?.startTime.format(context) ?? ''),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('End Time:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(course?.endTime.format(context) ?? ''),
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        title: const Text('Class Code'),
                        subtitle: Text(course?.accessToken ?? ''),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: course!.accessToken));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Class code copied to clipboard'),
                            ),
                          );
                        },
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
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: const Text('Name:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(instructorName),
                                  ),
                                ), 
                                Expanded(
                                  child: ListTile(
                                    title: const Text('Email:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(instructorEmail),
                                  ),
                                ),
                              ],
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
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: const Text('Clock In'),
              onPressed: () {
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => ClockInScreen())
                );
              },
              tooltip: 'Clock In',
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