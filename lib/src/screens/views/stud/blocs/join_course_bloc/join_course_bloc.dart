import 'package:bloc/bloc.dart';
import 'package:course_repository/course_repository.dart';
import 'package:equatable/equatable.dart';

part 'join_course_event.dart';
part 'join_course_state.dart';

class JoinCourseBloc extends Bloc<JoinCourseEvent, JoinCourseState> {
  final CourseRepository _courseRepository;

  JoinCourseBloc(this._courseRepository) : super(JoinCourseInitial()) {
    on<JoinCourseEvent>((event, emit) async {
      emit(JoinCourseInProgress());
      try {
        if (event is JoinCourseRequest) {
          await _courseRepository.joinCourse(event.accessKey, event.userId);
          emit(JoinCourseSuccess());
        }
      } catch (e) {
        String error = e.toString();
        if (error.contains('Course not found')) {
          emit(const JoinCourseFailure(error: 'Course not found'));
        } else if (error.contains('User already joined course')) {
          emit(const AlreadyJoined(message: 'User already joined course'));
        } else {

          emit(JoinCourseFailure(error: e.toString()));
        }
      }
    });
  }
}
