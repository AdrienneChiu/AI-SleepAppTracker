import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:ai_sleepapp/login_page/login_page.dart';
import 'package:ai_sleepapp/login_page/signin_page.dart';

void main() {
  // Small wrapper to load widgets in a testable MaterialApp
  Widget _wrap(Widget child) => MaterialApp(home: child);

  testWidgets('Login: shows error when fields are empty', (tester) async {
    await tester.pumpWidget(_wrap(const LoginPage()));
    await tester.pumpAndSettle();

    // Should see the login button and "Create Account" link
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    // Tap Login with empty fields
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Error message should appear
    expect(find.text('Please enter email and password'), findsOneWidget);
  });

  testWidgets('Login -> Signup navigation works', (tester) async {
    await tester.pumpWidget(_wrap(const LoginPage()));
    await tester.pumpAndSettle();

    // Tap "Create Account"
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    // Verify navigation to SignupPage
    expect(find.byType(SignupPage), findsOneWidget);
    expect(find.text('Create Account'), findsWidgets); // AppBar + button text
  });

  testWidgets('Signup: validation errors (bad email, empty password)',
      (tester) async {
    await tester.pumpWidget(_wrap(const SignupPage()));
    await tester.pumpAndSettle();

    // Enter invalid email and leave password empty
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'not-an-email',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      '',
    );

    // Scroll to the "Sign Up" button before tapping (prevents off-screen errors)
    final signUpBtn = find.widgetWithText(ElevatedButton, 'Sign Up');
    await tester.ensureVisible(signUpBtn);
    await tester.pump();
    await tester.tap(signUpBtn);
    await tester.pumpAndSettle();

    // Expect validation messages to appear
    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Please enter Password'), findsOneWidget);

    // Still on SignupPage
    expect(find.byType(SignupPage), findsOneWidget);
  });
}
