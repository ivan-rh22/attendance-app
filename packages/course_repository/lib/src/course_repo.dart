import 'models/models.dart';


abstract class CourseRepository {
  Stream<List<Course>> courses(String userId);

  Future<Course> createCourse(Course course, String userId);

  Future<void> setCourseData(Course course);

  Future<void> deleteCourse(String courseId);

  Future<void> updateCourse(Course course);

  Future<void> joinCourse(String accessKey, String userId);

  Future<void> leaveCourse(String courseId);
}