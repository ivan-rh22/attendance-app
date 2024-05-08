import 'package:bloc/bloc.dart';
import 'package:course_repository/course_repository.dart';
import 'package:equatable/equatable.dart';

part 'clock_in_event.dart';
part 'clock_in_state.dart';

class ClockInBloc extends Bloc<ClockInEvent, ClockInState> {
  final CourseRepository _courseRepository;

  ClockInBloc(this._courseRepository) : super(ClockInInitial()) {
    on<ClockInEvent>((event, emit) async {
      emit(ClockInProgress());
      try {
        if(event is ClockInRequest) {
          await _courseRepository.setAttendance(event.courseId, event.date, event.userId, event.present);
          emit(ClockInSuccess());
        } 
      } catch (e) {
        String error = e.toString();
        if (error.contains('Course not found')) {
          emit(const ClockInFailure(error: 'Course not found'));
        }
      }
    });
  }
}
