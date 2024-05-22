import 'dart:async';

import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:attendance_app/src/screens/views/stud/views/clock_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final Location locationController = Location();
  LatLng? _currentPos;
  StreamSubscription<LocationData>? _locationSubscription;

  late dynamic currCourse;
  late String userRef;

  @override
  void initState() {
    super.initState();
    _getCourseBloc.add(GetCourse(widget.courseId));
    getLocation();

    // get user doc reference
    userRef = 'users/${context.read<AuthenticationBloc>().state.user!.userId}';
  }

  @override
  void dispose() {
    _getCourseBloc.close();
    _locationSubscription?.cancel();
    super.dispose();
  }

  bool _isCourseHappening(
      List<int> daysOfWeek, TimeOfDay dbstartTime, TimeOfDay dbendTime) {
    final int now = DateTime.now().weekday;
    final DateTime currentTime = DateTime.now();

    if (daysOfWeek.contains(now - 1)) {
      DateTime startTime = DateTime.now();
      DateTime endTime = DateTime.now();
      startTime = DateTime(startTime.year, startTime.month, startTime.day,
          dbstartTime.hour, dbstartTime.minute);
      endTime = DateTime(endTime.year, endTime.month, endTime.day,
          dbendTime.hour, dbendTime.minute);

      return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
    }
    return false;
  }

  bool _isClockedIn(
      Map<String, Map<DateTime, bool>> attendance, String userRef) {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    return attendance[userRef]![now] ?? false;
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
              currCourse = course;
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
                                    context.read<LeaveCourseBloc>().add(
                                        LeaveCourseRequest(
                                            courseId: course!.courseId,
                                            userId: context
                                                .read<AuthenticationBloc>()
                                                .state
                                                .user!
                                                .userId));
                                  },
                                  child: const Text('Leave',
                                      style: TextStyle(
                                        color: Colors.red,
                                      )),
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
                    Card(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(children: [
                              const Text(
                                'Location:',
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: GoogleMap(
                                      zoomControlsEnabled: false,
                                      zoomGesturesEnabled: false,
                                      tiltGesturesEnabled: false,
                                      rotateGesturesEnabled: false,
                                      scrollGesturesEnabled: false,
                                      myLocationButtonEnabled: false,
                                      myLocationEnabled: true,
                                      mapType: MapType.normal,
                                      onMapCreated:
                                          ((GoogleMapController controller) =>
                                              _mapController
                                                  .complete(controller)),
                                      initialCameraPosition: CameraPosition(
                                        target: _currentPos ??
                                            course.classroomCoordinates,
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
                                    )),
                              )
                            ]),
                          )),
                    ),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: _isCourseHappening(course.daysOfWeek,
                            course.startTime, course.endTime) &&
                        !_isClockedIn(course.attendance, userRef)
                    ? FloatingActionButton.extended(
                        label: const Text('Clock In'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  // TODO: Add attendance status
                                  builder: (context) => ClockInScreen(
                                        coordinates:course.classroomCoordinates,
                                        radius: course.circleRadius,
                                        courseId: course.courseId,
                                        attendanceStatus: false,
                                        currentPos: _currentPos,
                                      )));
                        },
                        tooltip: 'Clock In',
                      )
                    : _isCourseHappening(course.daysOfWeek, course.startTime,
                                course.endTime) &&
                            _isClockedIn(course.attendance, userRef)
                        ? FloatingActionButton.extended(
                            backgroundColor: Colors.red,
                            label: const Text('Clock Out',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ClockInScreen(
                                            coordinates:
                                                course.classroomCoordinates,
                                            radius: course.circleRadius,
                                            courseId: course.courseId,
                                            attendanceStatus: true,
                                            currentPos: _currentPos,
                                          )));
                            },
                            tooltip: 'Clock Out',
                          )
                        : const SizedBox(),
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

  Future<void> _camToPos(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 18,
    );
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return Future.error("Location services disabled.");
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error("Location services disabled.");
      }
    }
    await locationController.enableBackgroundMode(enable: true);
    _locationSubscription = locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPos =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _camToPos(_currentPos!);
        });
      }
    });
  }
}
