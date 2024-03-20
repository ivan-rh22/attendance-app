import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entities/entities.dart';

class Course {
  String courseId;
  String instructorId;
  List<int> daysOfWeek;
  TimeOfDay startTime;
  TimeOfDay endTime;
  LatLng? classroomCoordinates;
  List<String> studentIds;

  Course({
    required this.courseId,
    required this.instructorId,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
    required this.classroomCoordinates,
    List<String>? studentIds,
  }) : studentIds = studentIds ?? [];

  static final empty = Course(
    courseId: '',
    instructorId: '',
    daysOfWeek: [],
    startTime: const TimeOfDay(hour: 0, minute: 0),
    endTime: const TimeOfDay(hour: 0, minute: 0),
    classroomCoordinates: null,
  );

  CourseEntity toEntity() {
    return CourseEntity(
      courseId: courseId,
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
    return 'Course: $courseId, $instructorId, $daysOfWeek, $startTime, $endTime, $classroomCoordinates, $studentIds';
  }
}