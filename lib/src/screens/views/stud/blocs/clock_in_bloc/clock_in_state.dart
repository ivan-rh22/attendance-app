part of 'clock_in_bloc.dart';

sealed class ClockInState extends Equatable {
  const ClockInState();
  
  @override
  List<Object> get props => [];
}

final class ClockInInitial extends ClockInState {}
final class ClockInProgress extends ClockInState {}
final class ClockInSuccess extends ClockInState {}
final class ClockInFailure extends ClockInState {
  final String error;

  const ClockInFailure({required this.error});

  @override 
  List<Object> get props => [error];
}