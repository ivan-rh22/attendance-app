import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:course_repository/course_repository.dart';

part 'create_course_event.dart';
part 'create_course_state.dart';

class CreateCourseBloc extends Bloc<CreateCourseEvent, CreateCourseState> {
  final CourseRepository _courseRepository;

  CreateCourseBloc(this._courseRepository) : super(CreateCourseInitial()) {
    on<CreateCourseEvent>((event, emit) async {
      emit(CreateCourseLoading());
      try{
        if(event is CreateCourse){
          await _courseRepository.createCourse(event.course, event.userId);
          emit(CreateCourseSuccess());
        }
      } catch(e) {
        emit(CreateCourseFailure(error: e.toString()));
      }
    });
  }
}
