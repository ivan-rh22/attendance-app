import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../../../../blocs/get_courses_bloc/get_courses_bloc.dart';

class ReloadCoursesObserver extends NavigatorObserver {
  final BuildContext context;

  ReloadCoursesObserver(this.context);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && previousRoute.settings.name == '/prof_home') {
      // Trigger a reload of courses here
      context.read<GetCoursesBloc>().add(GetCourses(context.read<AuthenticationBloc>().state.user!.userId));
    }
  }
}