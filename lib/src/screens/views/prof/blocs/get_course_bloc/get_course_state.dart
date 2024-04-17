part of 'get_course_bloc.dart';

sealed class GetCourseState extends Equatable {
  const GetCourseState();
  
  @override
  List<Object> get props => [];
}

final class GetCourseInitial extends GetCourseState {}
