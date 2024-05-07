import 'package:attendance_app/src/blocs/get_course_bloc/get_course_bloc.dart';
import 'package:flutter/material.dart';

class ProfCourseDetailsController extends StatefulWidget {
  final String courseId;
  const ProfCourseDetailsController({required this.courseId, super.key});

  @override
  State<ProfCourseDetailsController> createState() => _ProfCourseDetailsControllerState();
}

class _ProfCourseDetailsControllerState extends State<ProfCourseDetailsController> with TickerProviderStateMixin {
  final _bloc = GetCourseBloc();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 1,
      length: 3, 
      vsync: this
    );
    super.initState();
    _bloc.add(GetCourse(widget.courseId));
  }

  @override
  void dispose() {
    tabController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Info'),
        centerTitle: true,
        elevation: 1,
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column (
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
              )
            ),
            // Expanded(
            //   child: TabBarView(
            //     controller: tabController,
            //     children: [
            //       //CourseDetailsScreen(courseId: widget.courseId),
            //       Placeholder(),
            //       Placeholder(),
            //       Placeholder(),
            //     ],
            //   )
            // )
          ],
        )
      ),
    );
  }
}