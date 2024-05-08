part of 'clock_in_bloc.dart';

sealed class ClockInEvent extends Equatable {
  const ClockInEvent();

  @override
  List<Object> get props => [];
}

class ClockInRequest extends ClockInEvent {
  final String courseId;
  final DateTime date;
  final String userId;
  final bool present;


  const ClockInRequest({required this.courseId, required this.date, required this.userId, required this.present});

  @override 
  List<Object> get props => [courseId, date, userId, present];
}

class ClockOutRequest extends ClockInEvent {
  final String courseId;
  final DateTime date;
  final String userId;
  final bool present;

  const ClockOutRequest({required this.courseId, required this.date, required this.userId, required this.present});

  @override 
  List<Object> get props => [courseId, date, userId, present];
}