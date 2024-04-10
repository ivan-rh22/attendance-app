import 'package:attendance_app/src/components/my_text_field.dart';
import 'package:attendance_app/src/screens/views/prof/views/select_coord_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final courseNameController = TextEditingController();
  List<int> daysOfWeekSelected = [];
  late TimeOfDay startTimeSelected;
  late TimeOfDay endTimeSelected;
  late LatLng classroomCoordinatesSelected;

  @override
  void initState() {
    super.initState();
    startTimeSelected = const TimeOfDay(hour: 0, minute: 0);
    endTimeSelected = const TimeOfDay(hour: 0, minute: 0);
    classroomCoordinatesSelected = const LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Course'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                    errorMsg: null,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Field for days of the week
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (index) {
                    final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];
                    final isSelected = daysOfWeekSelected.contains(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (daysOfWeekSelected.contains(index)) {
                            daysOfWeekSelected.remove(index);
                          } else {
                            daysOfWeekSelected.add(index);
                          }
                          daysOfWeekSelected.sort();
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.09 + 10,
                        height: MediaQuery.of(context).size.width * 0.09 + 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade700, width: isSelected ? 2 : 1),
                        ),
                        child: Center(child: Text(day))
                      )
                    );
                  })
                ),
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
                          const Text('Start Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Divider(indent: 20, endIndent: 20, color: Colors.grey[700]),
                          Text(startTimeSelected.format(context),
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                            ),
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: startTimeSelected,
                              ).then((value) {
                                if (value != null) {
                                  setState (() {
                                    startTimeSelected = value;
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

                    SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
                    
                    // End Time
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Column(
                        children: [
                          const Text('End Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Divider(indent: 20, endIndent: 20, color: Colors.grey[700]),
                          Text(endTimeSelected.format(context),
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                            ),
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: endTimeSelected,
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    endTimeSelected = value;
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
                      const Text('Classroom Coordinates',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Divider(indent: 20, endIndent: 20, color: Colors.grey[700]),
                      Text('Latitude: ${classroomCoordinatesSelected.latitude}',
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text('Longitude: ${classroomCoordinatesSelected.longitude}',
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfMap(),
                            ),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                classroomCoordinatesSelected = value;
                              });
                            }
                          });
                        },
                        child: const Center(
                          child: Text('Select Coordinates'),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            // TODO: Add course creation logic
          },
          label: Text('Create Course',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}