import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_app/main.dart' as app;

Future<void> main() async {
  group('Mutual Test', () {
    testWidgets('User Lands On Welcome Screen', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      // Verify that the user lands on the sign in screen
      expect(find.byKey(const Key('sign_in_tab')), findsOneWidget);
      expect(find.byKey(const Key('sign_up_tab')), findsOneWidget);
   });
   testWidgets('Verify Sign Up Screen Is Complete', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      // Tap the sign up tab
      await widgetTester.tap(find.byKey(const Key('sign_up_tab')));
      await widgetTester.pumpAndSettle();
      
      // Verify that the user lands on the sign up screen
      expect(find.byKey(const Key('sign_up_as_student_button')), findsOneWidget);
      expect(find.byKey(const Key('sign_up_as_teacher_button')), findsOneWidget);
      expect(find.byKey(const Key('sign_up_email_textfield')), findsOneWidget);
      expect(find.byKey(const Key('sign_up_password_textfield')), findsOneWidget);
      expect(find.byKey(const Key('sign_up_name_textfield')), findsOneWidget);
   });
    testWidgets('Verify Sign In Screen Is Complete', (widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();
        // Tap the sign in tab
        await widgetTester.tap(find.byKey(const Key('sign_in_tab')));
        await widgetTester.pumpAndSettle();
        
        // Verify that the user lands on the sign in screen
        expect(find.byKey(const Key('sign_in_email_textfield')), findsOneWidget);
        expect(find.byKey(const Key('sign_in_password_textfield')), findsOneWidget);
    });
  });

  // // FUTURE TODO: Add tests for the student user flow
  // group('Student Tests', () {

  // });

  // // FUTURE TODO: Add tests for the teacher user flow
  // group('Teacher Tests', () { 

  // });
}