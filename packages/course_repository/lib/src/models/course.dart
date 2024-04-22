import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entities/entities.dart';

class Course {
  String courseId;
  String accessToken;
  String courseName;
  String roomNumber;
  DocumentReference instructorReference;
  List<int> daysOfWeek;
  TimeOfDay startTime;
  TimeOfDay endTime;
  LatLng? classroomCoordinates;
  double? circleRadius;
  List<String> studentIds;

  Course({
    required this.courseId,
    required this.accessToken,
    required this.courseName,
    required this.roomNumber,
    required this.instructorReference,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
    required this.classroomCoordinates,
    required this.circleRadius,
    List<String>? studentIds,
  }) : studentIds = studentIds ?? [];

  static final empty = Course(
    courseId: '',
    accessToken: '',
    courseName: '',
    roomNumber: '',
    instructorReference: FirebaseFirestore.instance.doc('users/nonexistent'),
    daysOfWeek: [],
    startTime: const TimeOfDay(hour: 00, minute: 00),
    endTime: const TimeOfDay(hour: 00, minute: 00),
    classroomCoordinates: null,
    circleRadius: null,
  );

  CourseEntity toEntity() {
    return CourseEntity(
      courseId: courseId,
      accessToken: accessToken,
      courseName: courseName,
      roomNumber: roomNumber,
      instructorReference: instructorReference,
      daysOfWeek: daysOfWeek,
      startTime: startTime,
      endTime: endTime,
      classroomCoordinates: classroomCoordinates,
      circleRadius: circleRadius,
      studentIds: studentIds,
    );
  }

  static Course fromEntity(CourseEntity entity) {
    return Course(
      courseId: entity.courseId,
      accessToken: entity.accessToken,
      courseName: entity.courseName,
      roomNumber: entity.roomNumber,
      instructorReference: entity.instructorReference,
      daysOfWeek: entity.daysOfWeek,
      startTime: entity.startTime,
      endTime: entity.endTime,
      classroomCoordinates: entity.classroomCoordinates,
      circleRadius: entity.circleRadius,
      studentIds: entity.studentIds,
    );
  }

  @override
  String toString() {
    return 'Course: $courseId, $courseName, $accessToken, $roomNumber $instructorReference, $daysOfWeek, $startTime, $endTime, $classroomCoordinates, $circleRadius, $studentIds';
  }
}