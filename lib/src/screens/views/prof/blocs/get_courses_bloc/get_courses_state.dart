part of 'get_courses_bloc.dart';

sealed class GetCoursesState extends Equatable {
  const GetCoursesState();
  
  @override
  List<Object> get props => [];
}

class GetCoursesInitial extends GetCoursesState {}

class GetCoursesInProgress extends GetCoursesState {}
class GetCoursesFailure extends GetCoursesState {
  final String error;

  const GetCoursesFailure(this.error);

  @override
  List<Object> get props => [error];
}
class GetCoursesSuccess extends GetCoursesState {
  final List<Course> courses;

  const GetCoursesSuccess(this.courses);

  @override
  List<Object> get props => [courses];
}