// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:ai_sleepapp/Login Page/login_page.dart';

// void main() {
//   testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
//     // Build LoginPage
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: LoginPage(),
//       ),
//     );

//     // Verify that essential widgets exist
//     expect(find.text('Welcome to Sleep App'), findsOneWidget);
//     expect(find.byType(TextFormField), findsNWidgets(2)); // email & password
//     expect(find.text('Login'), findsOneWidget);
//     expect(find.text('Create Account'), findsOneWidget);
//   });

//   testWidgets('Show error when login fields are empty', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: LoginPage(),
//       ),
//     );

//     // Tap login button without entering anything
//     await tester.tap(find.text('Login'));
//     await tester.pump();

//     // Expect error message
//     expect(find.text('Please enter email and password'), findsOneWidget);
//   });
// }
