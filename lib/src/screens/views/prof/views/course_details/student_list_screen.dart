import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  final Course course;
  const StudentListScreen({super.key, required this.course});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {

  @override
  Widget build(BuildContext context){
    return Column(
        children: [
          Expanded(
            child: widget.course.students.isEmpty
              ? const Center(
                  child: Text('No students in this course'),
                )
              : ListView.builder(
                itemCount: widget.course.students.length,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                    stream: widget.course.students[index].snapshots(), 
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
                    }
                  ),
                );
              },
            )
          ),
        ],
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