import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CourseEntity {
  String courseId;
  String instructorId;
  List<int> daysOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  LatLng? classroomCoordinates;
  List<String> studentIds;

  CourseEntity({
    required this.courseId,
    required this.instructorId,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
    required this.classroomCoordinates,
    List<String>? studentIds,
  }) : studentIds = studentIds ?? [];

  Map<String, Object?> toJson() {
    return {
      'courseId': courseId,
      'instructorId': instructorId,
      'daysOfWeek': daysOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'classroomCoordinates': classroomCoordinates,
      'studentIds': studentIds,
    };
  }

  static CourseEntity fromJson(Map<String, dynamic> json) {
    return CourseEntity(
      courseId: json['courseId'],
      instructorId: json['instructorId'],
      daysOfWeek: json['daysOfWeek'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      classroomCoordinates: json['classroomCoordinates'],
      studentIds: json['studentIds'],
    );
  }
}