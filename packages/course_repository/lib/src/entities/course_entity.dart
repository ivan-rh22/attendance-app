import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CourseEntity {
  String courseId;
  String accessToken;
  String courseName;
  String roomNumber;
  DocumentReference instructorReference;
  List<int> daysOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  LatLng classroomCoordinates;
  double circleRadius;
  List<DocumentReference> students;

  CourseEntity({
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
    List<DocumentReference>? students,
  }) : students = students ?? [];

  Map<String, Object?> toJson() {
    return {
      'courseId': courseId,
      'accessToken': accessToken,
      'courseName': courseName,
      'roomNumber': roomNumber,
      'instructorReference': instructorReference,
      'daysOfWeek': daysOfWeek,
      'startTime': _timeOfDayToTimeStamp(startTime),
      'endTime': _timeOfDayToTimeStamp(endTime),
      'classroomCoordinates': [classroomCoordinates.latitude, classroomCoordinates.longitude],
      'circleRadius': circleRadius,
      'students': students,
    };
  }

  static CourseEntity fromJson(Map<String, dynamic> json) {
    return CourseEntity(
      courseId: json['courseId'],
      accessToken: json['accessToken'],
      courseName: json['courseName'],
      roomNumber: json['roomNumber'],
      instructorReference: json['instructorReference'],
      daysOfWeek: List<int>.from(json['daysOfWeek']),
      startTime: _timeStampToTimeOfDay(json['startTime']),
      endTime: _timeStampToTimeOfDay(json['endTime']),
      classroomCoordinates: _coordinatesCalc(json['classroomCoordinates']),
      circleRadius: json['circleRadius'],
      students: List<DocumentReference>.from(json['students']),
    );
  }

  // HELPERS
  Timestamp _timeOfDayToTimeStamp(TimeOfDay time) {
    final now = DateTime.now();
    return Timestamp.fromDate(DateTime(now.year, now.month, now.day, time.hour, time.minute));
  }

  static TimeOfDay _timeStampToTimeOfDay(Timestamp timestamp) {
    final date = timestamp.toDate();
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  static LatLng _coordinatesCalc(dynamic data) {
    if(data != null && data is List<dynamic> && data.length >= 2){
      return LatLng(data[0], data[1]);
    } else {
      return const LatLng(0,0);
    }
  }
}