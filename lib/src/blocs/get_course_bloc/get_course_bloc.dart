import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:course_repository/course_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_course_event.dart';
part 'get_course_state.dart';

class GetCourseBloc extends Bloc<GetCourseEvent, GetCourseState> {
  final _courseStreamController = StreamController<Course>();

  Stream<Course> get courseStream => _courseStreamController.stream;
  
  GetCourseBloc() : super(GetCourseInitial()) {
    on<GetCourse>((event, emit) {
      FirebaseCourseRepo().courseStream(event.courseId).listen((course) {
        _courseStreamController.add(course);
      });
    });
  }

  @override
  Future<void> close() {
    _courseStreamController.close();
    return super.close();
  }
}
