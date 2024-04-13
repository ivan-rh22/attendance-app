import 'package:bloc/bloc.dart';
import 'package:course_repository/course_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_courses_event.dart';
part 'get_courses_state.dart';

class GetCoursesBloc extends Bloc<GetCoursesEvent, GetCoursesState> {
  final CourseRepository _courseRepository;
  GetCoursesBloc(this._courseRepository) : super(GetCoursesInitial()) {
    on<GetCourses>((event, emit) async {
      emit(GetCoursesInProgress());
      try {
        final coursesStream = _courseRepository.courses(event.userId);
        await for (final courses in coursesStream) {
          emit(GetCoursesSuccess(courses));
        }
      } catch (e) {
        emit(GetCoursesFailure(e.toString()));
      }
    });
  }
}
