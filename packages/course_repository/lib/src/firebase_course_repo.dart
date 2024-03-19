import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:course_repository/course_repository.dart';
import 'package:user_repository/user_repository.dart';


class FirebaseCourseRepo implements CourseRepository {
  final coursesCollection = FirebaseFirestore.instance.collection('courses');
  final FirebaseUserRepo _userRepo;

  FirebaseCourseRepo(this._userRepo);

  @override
  Stream<Course?> get course => _userRepo.user.flatMap((user) {
    if(user != null){
      return Stream.fromIterable(user.courses)
        .asyncMap((courseID) => getCourse(courseID));
    } else {
      return Stream.value(null);
    }
  });

  @override
  Future<Course> createCourse(Course course, String userId) async {
    try {
      MyUser? user = await _userRepo.user.first;
      if(user != null && user.isTeacher){
        await coursesCollection.add(course.toEntity().toJson());
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
      return _userRepo.user.first.then((user) async {
        if(user != null){
          await coursesCollection.doc(courseId).update({
            'students': FieldValue.arrayUnion([user.userId])
          });
        } else {
          throw Exception('User not found');
        }
      });
    } catch(e) {
      log('Error joining course: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> leaveCourse(String courseId) {
    try{
      return _userRepo.user.first.then((user) async {
        if(user != null){
          await coursesCollection.doc(courseId).update({
            'students': FieldValue.arrayRemove([user.userId])
          });
        } else {
          throw Exception('User not found');
        }
      });
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