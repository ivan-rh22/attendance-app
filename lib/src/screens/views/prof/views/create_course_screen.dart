import 'dart:async';
import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:attendance_app/src/components/my_text_field.dart';
import 'package:attendance_app/src/screens/views/prof/views/select_coord_screen.dart';
import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/create_course_bloc/bloc/create_course_bloc.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final courseNameController = TextEditingController();
  final courseRoomController = TextEditingController();
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();
  Set<Circle> circles = {};
  LatLng? classroomCoordinates;
  double? circleRadius;
  List<int> daysOfWeek = [];
  TimeOfDay startTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 00, minute: 00);


  bool courseCreationInProgress = false;

  void _addCircle (LatLng point, double radius) {
    setState(() {
      circles.add(
        Circle(
          circleId: const CircleId('geofence'),
          center: point,
          radius: radius,
          fillColor: Colors.amber.withOpacity(0.3),
          strokeWidth: 2,
          strokeColor: Colors.amber,
        )
      );
    });
  }

  Future<void> _camToPos (LatLng pos) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos, 
      zoom: 18,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void _resetData() {
  setState(() {
    classroomCoordinates = null;
    daysOfWeek.clear();
    startTime = const TimeOfDay(hour: 00, minute: 00);
    endTime = const TimeOfDay(hour: 00, minute: 00);
  });
}

  @override
  void initState() {
    super.initState();
    _resetData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCourseBloc, CreateCourseState>(
      listener: (context, state) {
        if (state is CreateCourseSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Center(child: Text('Course created successfully')),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.pop(context);
          setState(() {
            courseCreationInProgress = false;
            _resetData();
          });
        } else if (state is CreateCourseFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Center(child: Text(state.error)),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          setState(() {
            courseCreationInProgress = false;
          });
        } else if (state is CreateCourseLoading) {
            setState(() {
              courseCreationInProgress = true;
            });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Course'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MyTextField(
                        controller: courseNameController,
                        hintText: 'Course Name',
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.book),
                        validator: (val){
                          if(val!.isEmpty){
                            return 'Please enter a course name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MyTextField(
                        controller: courseRoomController,
                        hintText: 'Room Number',
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.room),
                        validator: (val){
                          if(val!.isEmpty){
                            return 'Please enter a room';
                          }
                          return null;
                        },
                      ),
                    )
                  ),

                  const SizedBox(height: 20),

                  // Field for days of the week
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          final day = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ][index];
                          final isSelected = daysOfWeek.contains(index);
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (daysOfWeek.contains(index)) {
                                    daysOfWeek.remove(index);
                                  } else {
                                    daysOfWeek.add(index);
                                  }
                                  daysOfWeek.sort();
                                });
                              },
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.09 +
                                          10,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09 +
                                          10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.grey.shade700,
                                        width: isSelected ? 2 : 1),
                                  ),
                                  child: Center(child: Text(day))));
                        })),
                  ),

                  const SizedBox(height: 20),
                  // Field for start and end time
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Start Time
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade700),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Start Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Divider(
                                  indent: 20,
                                  endIndent: 20,
                                  color: Colors.grey[700]),
                              Text(
                                startTime.format(context),
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.onPrimary),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                                ),
                                onPressed: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: startTime,
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        startTime = value;
                                      });
                                    }
                                  });
                                },
                                child: const Center(
                                  child: Text('Select Time'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),

                        // End Time
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade700),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'End Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Divider(
                                  indent: 20,
                                  endIndent: 20,
                                  color: Colors.grey[700]),
                              Text(
                                endTime.format(context),
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.onPrimary),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                                ),
                                onPressed: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: endTime,
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        endTime = value;
                                      });
                                    }
                                  });
                                },
                                child: const Center(
                                  child: Text('Select Time'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Field for classroom coordinates
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            const Text(
                              'Classroom Geofence',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Divider(
                                indent: 20,
                                endIndent: 20,
                                color: Colors.grey[700]),
                            circleRadius == null ? 
                            const Text(
                              "Missing",
                              style: TextStyle(color: Colors.red),
                            ) :
                            SizedBox(
                              height: 170, 
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                mapType: MapType.hybrid,
                                onMapCreated: ((GoogleMapController controller) => mapController.complete(controller)),
                                initialCameraPosition: CameraPosition(
                                  target: classroomCoordinates == null ? const LatLng(0, 0) : classroomCoordinates!,
                                  zoom: 18,
                                ),
                                circles: circles,
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.onPrimary),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfMap(),
                                  ),
                                ).then((dynamic values) {
                                  if (values != null || values.length >= 2) {
                                    setState(() {
                                      classroomCoordinates = values[0];
                                      circleRadius = values[1];
                                      _camToPos(classroomCoordinates!);
                                      _addCircle(classroomCoordinates!, circleRadius!);
                                    });
                                  }
                                });
                              },
                              child: Center(
                                child: Text(circleRadius != null ? "Edit Geofence" : 'Create Geofence'),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: courseCreationInProgress
          ? const CircularProgressIndicator()
          : SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if(_formKey.currentState!.validate() && classroomCoordinates?.latitude != null || classroomCoordinates?.longitude != null){
                  final course = Course.empty;
                  course.courseName = courseNameController.text;
                  course.roomNumber = courseRoomController.text;
                  course.daysOfWeek = daysOfWeek;
                  course.startTime = startTime;
                  course.endTime = endTime;
                  course.classroomCoordinates = classroomCoordinates;
                  course.circleRadius = circleRadius;

                  setState(() {
                    context.read<CreateCourseBloc>().add(CreateCourse(course,context.read<AuthenticationBloc>().state.user!.userId));
                  });
                }
              },
              label: Text(
                'Create Course',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ),
    );
  }
}
