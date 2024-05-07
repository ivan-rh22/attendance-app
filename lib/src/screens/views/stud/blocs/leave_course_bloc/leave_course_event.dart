part of 'leave_course_bloc.dart';

sealed class LeaveCourseEvent extends Equatable {
  const LeaveCourseEvent();

  @override
  List<Object> get props => [];
}

class LeaveCourseRequest extends LeaveCourseEvent {
  final String courseId;
  final String userId;

  const LeaveCourseRequest({required this.courseId, required this.userId});

  @override
  List<Object> get props => [courseId, userId];
}