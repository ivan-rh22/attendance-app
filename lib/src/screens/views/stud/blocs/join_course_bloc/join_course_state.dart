part of 'join_course_bloc.dart';

sealed class JoinCourseState extends Equatable {
  const JoinCourseState();
  
  @override
  List<Object> get props => [];
}

final class JoinCourseInitial extends JoinCourseState {}
final class JoinCourseInProgress extends JoinCourseState {}
final class JoinCourseSuccess extends JoinCourseState {}
final class JoinCourseFailure extends JoinCourseState {
  final String error;

  const JoinCourseFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// already joined
final class AlreadyJoined extends JoinCourseState {
  final String message;

  const AlreadyJoined({required this.message});

  @override
  List<Object> get props => [message];
}