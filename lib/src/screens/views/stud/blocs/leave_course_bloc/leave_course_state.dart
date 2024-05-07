part of 'leave_course_bloc.dart';

sealed class LeaveCourseState extends Equatable {
  const LeaveCourseState();
  
  @override
  List<Object> get props => [];
}

final class LeaveCourseInitial extends LeaveCourseState {}
final class LeaveCourseInProgress extends LeaveCourseState {}
final class LeaveCourseSuccess extends LeaveCourseState {}
final class LeaveCourseFailure extends LeaveCourseState {
  final String error;

  const LeaveCourseFailure({required this.error});

  @override
  List<Object> get props => [error];
}