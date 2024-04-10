part of 'create_course_bloc.dart';

sealed class CreateCourseEvent extends Equatable {
  const CreateCourseEvent();

  @override
  List<Object> get props => [];
}

class CreateCourse extends CreateCourseEvent {
  final Course course;
  final String userId;

  const CreateCourse(this.course, this.userId);

  @override
  List<Object> get props => [course, userId];
}
