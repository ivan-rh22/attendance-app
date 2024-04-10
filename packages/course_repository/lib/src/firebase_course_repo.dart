import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_repository/course_repository.dart';


class FirebaseCourseRepo implements CourseRepository {
  final coursesCollection = FirebaseFirestore.instance.collection('courses');

  FirebaseCourseRepo();

  @override
  // TODO: get all users courses
  Stream<Course?> get course => throw UnimplementedError();

  @override
  Future<Course> createCourse(Course course, String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userData = userSnapshot.data();
      if(userData != null && userData['isTeacher'] == true){
        // add instructorId to course
        course.instructorId = userId;

        final documentReference = await coursesCollection.add(course.toEntity().toJson());

        // Update the course with the auto-generated ID
        course.courseId = documentReference.id;
        await documentReference.update(course.toEntity().toJson());

        final List<dynamic> courses = userData['courses'] ?? [];
        courses.add(course.courseId);
        await FirebaseFirestore.instance.collection('users').doc(userId).update({'courses': courses});

        return course;
      }
      else {
        throw Exception('User is not a teacher');
      }
    } catch(e) {
      log('Error creating course: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteCourse(String courseId) {
    try{
      return coursesCollection.doc(courseId).delete();
    } catch(e) {
      log('Error deleting course: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> joinCourse(String courseId) {
    try{
      // TODO: implement joinCourse
      return Future.value();
    } catch(e) {
      log('Error joining course: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> leaveCourse(String courseId) {
    try{
      // TODO: implement leaveCourse
      return Future.value();
    } catch(e) {
      log('Error leaving course: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> setCourseData(Course course) {
    try{
      return coursesCollection.doc(course.courseId).set(course.toEntity().toJson());
    } catch(e) {
      log('Error setting course data: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateCourse(Course course) {
    try{
      return coursesCollection.doc(course.courseId).update(course.toEntity().toJson());
    } catch(e) {
      log('Error updating course: ${e.toString()}');
      rethrow;
    }
  }
  
  Future<Course> getCourse(String courseID) async {
    try{
      final snapshot = await coursesCollection.doc(courseID).get();
      if(snapshot.exists){
        return Course.fromEntity(CourseEntity.fromJson(snapshot.data()!));
      } else {
        throw Exception('Course not found');
      }
    } catch(e) {
      log('Error getting course: ${e.toString()}');
      rethrow;
    }
  }
  
}