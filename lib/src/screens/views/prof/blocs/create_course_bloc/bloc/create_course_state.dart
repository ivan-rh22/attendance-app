part of 'create_course_bloc.dart';

sealed class CreateCourseState extends Equatable {
  const CreateCourseState();
  
  @override
  List<Object> get props => [];
}

final class CreateCourseInitial extends CreateCourseState {}
final class CreateCourseLoading extends CreateCourseState {}
final class CreateCourseFailure extends CreateCourseState {
  final String error;

  const CreateCourseFailure({required this.error});

  @override
  List<Object> get props => [error];
}
final class CreateCourseSuccess extends CreateCourseState {}
