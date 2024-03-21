import 'package:attendance_app/src/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:attendance_app/src/screens/views/prof/pcontroller.dart';
import 'package:attendance_app/src/screens/views/stud/scontroller.dart';
import 'package:flutter/material.dart';
import 'package:attendance_app/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/auth/views/welcome_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return MaterialApp(
        title: 'Auto Attendance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
        colorScheme: ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Colors.blue,
          onPrimary: Colors.white,
          primaryContainer: Colors.white,
          onPrimaryContainer: Colors.blue.shade200,
        ),
        textTheme: Typography.material2018().black.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      ).copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black), systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.dark(
          background: Colors.black,
          onBackground: Colors.white,
          primary: Colors.blue,
          onPrimary: Colors.white,
          primaryContainer: Colors.grey.shade900,
          onPrimaryContainer: Colors.grey.shade200,
        ),
        textTheme: Typography.material2018().white.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ).copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white), systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => SignInBloc(
                  context.read<AuthenticationBloc>().userRepository,
                ),
                child: state.user!.isTeacher ? const ProfControl() : const StudControl(),
              );
            } else {
              return const WelcomeScreen();
            }
          }),
        ));
  }
}
