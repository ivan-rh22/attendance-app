import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../blocs/get_course_bloc/get_course_bloc.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final _bloc = GetCourseBloc();
    final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();


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
                              subtitle: Text(course!.daysOfWeek.map((day) {
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
                              }).join(', ')
                              ),
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
                              subtitle: Text(course.startTime.format(context)),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('End Time:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(course.endTime.format(context)),
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        title: const Text('Class Code:', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(course.accessToken),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: course.accessToken));
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
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          const Text('Location:', 
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(indent: 30, endIndent: 30),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: GoogleMap(
                                zoomControlsEnabled: false,
                                zoomGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                rotateGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                myLocationButtonEnabled: false,
                                mapType: MapType.hybrid,
                                onMapCreated: ((GoogleMapController controller) => mapController.complete(controller)),
                                initialCameraPosition: CameraPosition(
                                  target: course.classroomCoordinates,
                                  zoom: 18,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('classroom'),
                                    position: course.classroomCoordinates,
                                    infoWindow: InfoWindow(
                                      title: course.roomNumber,
                                      snippet: 'Classroom',
                                    ),
                                  ),
                                },
                                circles: <Circle>{
                                  Circle(
                                    circleId: const CircleId('Clock in Radius'),
                                    center: course.classroomCoordinates,
                                    radius: course.circleRadius,
                                    fillColor: Colors.yellow.withOpacity(0.5),
                                    strokeColor: Colors.yellow,
                                    strokeWidth: 2,
                                  ),
                                },
                              )
                            ),
                          )
                        ]
                      ),
                    )
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  child: StreamBuilder(
                    stream: course.instructorReference.snapshots(),
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
                const Text('Students', 
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                Expanded(
                  child: course.students.isEmpty
                    ? const Center(
                      child: Text('No students in this course'),
                    )
                    : ListView.builder(
                      itemCount: course.students.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                          stream: course.students[index].snapshots(), 
                          builder: ((context, snapshot) {
                            if(snapshot.hasData){
                              final studentData = snapshot.data?.data() as Map<String, dynamic>;
                              final studentName = (studentData)['name'] ?? 'Student Not Found';
                              return Student(studentName: studentName);
                            }
                            else if(snapshot.hasError){
                              return const Text('Failed to get student details');
                            }
                            else {
                              return const Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    Text('Loading student details'),
                                  ]
                                ),
                              );
                            }
                          }),
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