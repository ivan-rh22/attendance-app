import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_repository/course_repository.dart';
import 'package:random_x/random_x.dart';


class FirebaseCourseRepo implements CourseRepository {
  final coursesCollection = FirebaseFirestore.instance.collection('courses');

  FirebaseCourseRepo();

  @override
  Stream<List<Course>> courses(String userID) async* {
    try{
      // return the courses where the course id is in the user's courses list
      // user's courses list is a list of course ids (start by getting this)
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userID).get();
      final userData = userSnapshot.data();
      if(userData != null){
        final List<dynamic> courses = userData['courses'] ?? [];
        if(courses.isNotEmpty){
          final courseSnapshots = await coursesCollection.where(FieldPath.documentId, whereIn: courses).get();
          yield courseSnapshots.docs.map((doc) => Course.fromEntity(CourseEntity.fromJson(doc.data()))).toList();
        } else {
          yield [];
        }
      }
      else {
        throw Exception('User not found');
      }
    } catch(e) {
      log('Error getting courses: ${e.toString()}');
      rethrow;
    }
  }

  Stream<Course> courseStream(String courseId) {
    try {
      return coursesCollection.doc(courseId).snapshots().map((snapshot) {
        if(snapshot.exists){
          return Course.fromEntity(CourseEntity.fromJson(snapshot.data()!));
        }
        else {
          throw Exception('Course not found');
        }
      });
    } catch (e) {
      log('Error getting course stream: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Course> createCourse(Course course, String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userSnapshot = await userRef.get();
      final userData = userSnapshot.data();

      if(userData != null && userData['isTeacher'] == true){
        // add instructor reference to course
        course.instructorReference = userSnapshot.reference;
        // generate access token
        course.accessToken = RndX.randomString(type: RandomCharStringType.alphaNumerical, length: 10).toUpperCase();

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
  Future<void> joinCourse(String accessKey, String userId) async {
    try{
      // get the course with the access key
      final courseSnapshot = await coursesCollection.where('accessToken', isEqualTo: accessKey).get();
      if(courseSnapshot.docs.isNotEmpty){
        // add the user to the course's students list
        final course = courseSnapshot.docs.first;
        final courseData = course.data();
        final courseId = course.id;
        final List<dynamic> students = courseData['students'] ?? [];
        // get the attendance map
        final Map<dynamic, dynamic> attendance = courseData['attendance'] ?? {};
        // get user reference based on user id
        final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
        if(students.contains(userRef)){
          throw Exception('User already joined course');
        }

        String path = userRef.path; // convert user reference to path string for attendance map

        students.add(userRef);
        attendance[path] = {};

        // add the course to the user's courses list
        final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final userData = userSnapshot.data();
        final List<dynamic> courses = userData?['courses'] ?? [];
        courses.add(courseId);
        await FirebaseFirestore.instance.collection('users').doc(userId).update({'courses': courses});
        
        return coursesCollection.doc(courseId).update({'students': students, 'attendance': attendance});
      }
      else {
        throw Exception('Course not found');
      }
    } catch(e) {
      log('Error joining course: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> leaveCourse(String courseId, String userId) async {
    try{
      // get the course with the id
      final courseSnapshot = await coursesCollection.doc(courseId).get();
      if(courseSnapshot.exists){
        final courseData = courseSnapshot.data();
        final List<dynamic> students = courseData?['students'] ?? [];
        final Map<dynamic, dynamic> attendance = courseData?['attendance'] ?? {};

        // get user reference based on user id
        final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
        if(!students.contains(userRef)){
          throw Exception('User not in course');
        }

        // remove the user from the course's students list and attendance map
        String path = userRef.path; // convert user reference to path string for attendance map

        students.remove(userRef);
        attendance.remove(path);

        // remove the course from the user's courses list
        final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final userData = userSnapshot.data();
        final List<dynamic> courses = userData?['courses'] ?? [];
        courses.remove(courseId);
        await FirebaseFirestore.instance.collection('users').doc(userId).update({'courses': courses});

        return coursesCollection.doc(courseId).update({'students': students});
      } else {
        throw Exception('Course not found');
      }

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

  @override 
  Future<void> setAttendance(String courseId, DateTime date, String userId, bool present) async {
    try{
      final courseSnapshot = await coursesCollection.doc(courseId).get();
      if(courseSnapshot.exists) {
        final courseData = courseSnapshot.data();
        // convert courseData to Course object
        final course = Course.fromEntity(CourseEntity.fromJson(courseData!));
        final today = DateTime(date.year, date.month, date.day);
        // get user reference based on user id
        final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
        course.attendance[userRef.path]![today] = present;        
        // convert back to json
        final courseJson = course.toEntity().toJson();
        return coursesCollection.doc(courseId).update({'attendance': courseJson['attendance']});
      } else {
        throw Exception('Course not found');
      }

      
    } catch(e) {
      log('Error setting Attendance: ${e.toString()}');
      rethrow;
    }
  }

}