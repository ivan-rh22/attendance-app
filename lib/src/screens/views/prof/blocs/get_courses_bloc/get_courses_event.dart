part of 'get_courses_bloc.dart';

sealed class GetCoursesEvent extends Equatable {
  const GetCoursesEvent();

  @override
  List<Object> get props => [];
}

class GetCourses extends GetCoursesEvent {
  final String userId;

  const GetCourses(this.userId);

  @override
  List<Object> get props => [userId];
}