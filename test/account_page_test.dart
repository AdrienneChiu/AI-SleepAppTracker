// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:ai_sleepapp/account_page.dart';
// import 'package:ai_sleepapp/login_page/login_page.dart'; // updated path

// void main() {
//   group('AccountPage Tests', () {
//     testWidgets('Logout button navigates to LoginPage', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: AccountPage(
//             userData: {
//               'name': 'Test User',
//               'email': 'test@example.com',
//               'age': '25',
//               'height': '170',
//               'weight': '65',
//             },
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();

//       final logoutButtonFinder = find.byType(ElevatedButton);

//       expect(logoutButtonFinder, findsOneWidget);

//       await tester.tap(logoutButtonFinder);
//       await tester.pumpAndSettle();

//       expect(find.byType(LoginPage), findsOneWidget);
//     });
//   });
// }
