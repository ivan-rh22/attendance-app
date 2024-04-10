import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entities/entities.dart';

class Course {
  String courseId;
  String courseName;
  String instructorId;
  List<int> daysOfWeek;
  TimeOfDay startTime;
  TimeOfDay endTime;
  LatLng? classroomCoordinates;
  List<String> studentIds;

  Course({
    required this.courseId,
    required this.courseName,
    required this.instructorId,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
    required this.classroomCoordinates,
    List<String>? studentIds,
  }) : studentIds = studentIds ?? [];

  static final empty = Course(
    courseId: '',
    courseName: '',
    instructorId: '',
    daysOfWeek: [],
    startTime: const TimeOfDay(hour: 00, minute: 00),
    endTime: const TimeOfDay(hour: 00, minute: 00),
    classroomCoordinates: null,
  );

  CourseEntity toEntity() {
    return CourseEntity(
      courseId: courseId,
      courseName: courseName,
      instructorId: instructorId,
      daysOfWeek: daysOfWeek,
      startTime: startTime,
      endTime: endTime,
      classroomCoordinates: classroomCoordinates,
      studentIds: studentIds,
    );
  }

  static Course fromEntity(CourseEntity entity) {
    return Course(
      courseId: entity.courseId,
      courseName: entity.courseName,
      instructorId: entity.instructorId,
      daysOfWeek: entity.daysOfWeek,
      startTime: entity.startTime,
      endTime: entity.endTime,
      classroomCoordinates: entity.classroomCoordinates,
      studentIds: entity.studentIds,
    );
  }

  @override
  String toString() {
    return 'Course: $courseId, $courseName, $instructorId, $daysOfWeek, $startTime, $endTime, $classroomCoordinates, $studentIds';
  }
}