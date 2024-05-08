import 'package:course_repository/course_repository.dart';
import 'package:flutter/material.dart';

class AttendanceReportScreen extends StatefulWidget {
  final Course course;
  const AttendanceReportScreen({super.key, required this.course});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {

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
                        return StudentReport(
                          studentName: studentName,
                          studentRef: widget.course.students[index],
                          daysOfWeek: widget.course.daysOfWeek,
                          attendance: widget.course.attendance,
                        );
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

class StudentReport extends StatelessWidget {
  final String studentName;
  final dynamic studentRef;
  final List<int> daysOfWeek;
  final Map<String, Map<DateTime, bool>> attendance;

  const StudentReport({
    super.key,
    required this.studentName,
    required this.studentRef,
    required this.daysOfWeek,
    required this.attendance,
  });

  // get attendance for the current week
  Map<DateTime, bool> getAttendanceForWeek() {
    final now = DateTime.now();
    final daysOfWeekSet = daysOfWeek.toSet();
    final days = daysOfWeekSet.map((day) {
      final date = now.subtract(Duration(days: now.weekday - (day+1)));
      return DateTime(date.year, date.month, date.day);
    }).toList();
    return {
      for (var day in days)
        if (attendance[studentRef.path]?.containsKey(day) == true)
          day: attendance[studentRef.path]![day]!
        else
          day: false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final weekAttendance = getAttendanceForWeek();

    return ListTile(
      // TODO: Replace with student profile picture
      leading: const Icon(Icons.person),
      title: Text(studentName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
            children: weekAttendance.keys.toList().map((day) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: weekAttendance[day] == true
                    ? Colors.green
                    : weekAttendance[day] == false && DateTime.now().isAfter(day)
                      ? Colors.red
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    ({
                      0: 'M',
                      1: 'T',
                      2: 'W',
                      3: 'Th',
                      4: 'F',
                      5: 'Sa',
                      6: 'Su',
                    })[day.weekday - 1] ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              );
            }).toList(),
          ),
    );
  }
}