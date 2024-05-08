import 'dart:async';
import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;
  const CourseDetailsScreen({super.key, required this.course});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
          margin: const EdgeInsets.all(15),
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
                      subtitle: Text(widget.course.roomNumber),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Days of the Week:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(widget.course.daysOfWeek.map((day) {
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
                      subtitle: Text(widget.course.startTime.format(context)),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('End Time:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(widget.course.endTime.format(context)),
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
                subtitle: Text(widget.course.accessToken),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.course.accessToken));
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
                          target: widget.course.classroomCoordinates,
                          zoom: 18,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('classroom'),
                            position: widget.course.classroomCoordinates,
                            infoWindow: InfoWindow(
                              title: widget.course.roomNumber,
                              snippet: 'Classroom',
                            ),
                          ),
                        },
                        circles: <Circle>{
                          Circle(
                            circleId: const CircleId('Clock in Radius'),
                            center: widget.course.classroomCoordinates,
                            radius: widget.course.circleRadius,
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
            stream: widget.course.instructorReference.snapshots(),
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
              } else if(snapshot.hasError){
                return const Text('Failed to get instructor details');
              } else {
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
    ));
  }
}