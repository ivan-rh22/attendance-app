import 'package:bloc/bloc.dart';
import 'package:course_repository/course_repository.dart';
import 'package:equatable/equatable.dart';

part 'leave_course_event.dart';
part 'leave_course_state.dart';

class LeaveCourseBloc extends Bloc<LeaveCourseEvent, LeaveCourseState> {
  final CourseRepository _courseRepository;

  LeaveCourseBloc(this._courseRepository) : super(LeaveCourseInitial()) {
    on<LeaveCourseEvent>((event, emit) async {
      emit(LeaveCourseInProgress());
      try {
        if (event is LeaveCourseRequest) {
          await _courseRepository.leaveCourse(event.courseId, event.userId);
          emit(LeaveCourseSuccess());
        }
      } catch (e) {
        String error = e.toString();
        if (error.contains('Course not found')) {
          emit(const LeaveCourseFailure(error: 'Course not found'));
        } else {
          emit(LeaveCourseFailure(error: e.toString()));
        }
      }
    });
  }
}
