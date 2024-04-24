import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:attendance_app/src/screens/views/stud/views/clock_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/get_course_bloc/get_course_bloc.dart';
import '../blocs/leave_course_bloc/leave_course_bloc.dart';

class StudCourseDetailsScreen extends StatefulWidget {
  final String courseId;
  const StudCourseDetailsScreen({super.key, required this.courseId});

  @override
  State<StudCourseDetailsScreen> createState() =>
      _StudCourseDetailsScreenState();
}

class _StudCourseDetailsScreenState extends State<StudCourseDetailsScreen> {
  final _getCourseBloc = GetCourseBloc();

  @override
  void initState() {
    super.initState();
    _getCourseBloc.add(GetCourse(widget.courseId));
  }

  @override
  void dispose() {
    _getCourseBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveCourseBloc, LeaveCourseState>(
      listener: (context, state) {
        if (state is LeaveCourseSuccess) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Course left successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is LeaveCourseFailure) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(state.error),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: StreamBuilder(
          stream: _getCourseBloc.courseStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final course = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  title: Text(course?.courseName ?? 'Course Details'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      tooltip: 'Leave Course',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Leave Course'),
                              content: const Text(
                                  'Are you sure you want to leave this course?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<LeaveCourseBloc>()
                                        .add(LeaveCourseRequest(
                                            courseId: course!.courseId,
                                            userId: context.read<AuthenticationBloc>().state.user!.userId));
                                    // Navigator.of(context).pop();
                                  },
                                  child: const Text('Leave', 
                                    style: TextStyle(
                                      color: Colors.red,
                                    )
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text(
                            'Course Details:',
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
                                  title: const Text(
                                    'Room Number:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(course?.roomNumber ?? ''),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text(
                                    'Days of the Week:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    course!.daysOfWeek.map((day) {
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text(
                                    'Start Time:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(course.startTime.format(context)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text(
                                    'End Time:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle:
                                      Text(course.endTime.format(context)),
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            title: const Text('Class Code'),
                            subtitle: Text(course.accessToken),
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: course.accessToken));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Class code copied to clipboard'),
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
                          stream: course.instructorReference.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final instructorData =
                                  snapshot.data?.data() as Map<String, dynamic>;
                              final instructorName = (instructorData)['name'] ??
                                  'Instructor Not Found';
                              final instructorEmail =
                                  (instructorData)['email'] ??
                                      'Instructor Not Found';
                              return Column(
                                children: [
                                  const Text(
                                    'Instructor Details',
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
                                          title: const Text(
                                            'Name:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(instructorName),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: const Text(
                                            'Email:',
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
                            } else if (snapshot.hasError) {
                              return const Text(
                                  'Failed to get instructor details');
                            } else {
                              return const Center(
                                child: Column(children: [
                                  CircularProgressIndicator(),
                                  Text('Loading instructor details'),
                                ]),
                              );
                            }
                          },
                        )),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton.extended(
                  label: const Text('Clock In'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClockInScreen()));
                  },
                  tooltip: 'Clock In',
                ),
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
          }),
    );
  }
}
