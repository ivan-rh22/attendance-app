part of 'join_course_bloc.dart';

sealed class JoinCourseEvent extends Equatable {
  const JoinCourseEvent();

  @override
  List<Object> get props => [];
}

class JoinCourseRequest extends JoinCourseEvent {
  final String accessKey;
  final String userId;

  const JoinCourseRequest({required this.accessKey, required this.userId});

  @override
  List<Object> get props => [accessKey, userId];
}