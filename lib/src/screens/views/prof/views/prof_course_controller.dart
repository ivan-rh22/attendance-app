import 'package:attendance_app/src/blocs/get_course_bloc/get_course_bloc.dart';
import 'package:attendance_app/src/screens/views/prof/views/course_details/attendance_screen.dart';
import 'package:attendance_app/src/screens/views/prof/views/course_details/course_info_screen.dart';
import 'package:attendance_app/src/screens/views/prof/views/course_details/student_list_screen.dart';
import 'package:flutter/material.dart';

class ProfCourseDetailsController extends StatefulWidget {
  final String courseId;
  const ProfCourseDetailsController({required this.courseId, super.key});

  @override
  State<ProfCourseDetailsController> createState() =>
      _ProfCourseDetailsControllerState();
}

class _ProfCourseDetailsControllerState extends State<ProfCourseDetailsController> with TickerProviderStateMixin {
  final _courseStreamBloc = GetCourseBloc();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);
    super.initState();
    _courseStreamBloc.add(GetCourse(widget.courseId));
  }

  @override
  void dispose() {
    tabController.dispose();
    _courseStreamBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _courseStreamBloc.courseStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final course = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text(course?.courseName ?? 'Course Info'),
                centerTitle: true,
                elevation: 1,
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TabBar(
                            controller: tabController,
                            tabs: const [
                              Tab(text: 'Students'),
                              Tab(text: 'Details'),
                              Tab(text: 'Attendance'),
                            ],
                          )),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            StudentListScreen(course: course!),
                            CourseDetailsScreen(course: course),
                            AttendanceReportScreen(course: course),
                          ],
                        )
                      )
                    ],
                  )
                ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Course Info'),
                centerTitle: true,
                elevation: 1,
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Course Info'),
                centerTitle: true,
                elevation: 1,
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
    );  
  }
}
