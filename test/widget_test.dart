// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:login/main.dart';
import 'package:login/page/launch/launch_page.dart';
import 'package:login/page/login/view/login_page.dart';
import 'package:login/page/welcome/welcome_page.dart';
import 'package:login/tool/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Widget createWidgetForTesting(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await sharedPrefs.init();
  });

  group('Widget test', () {
    testWidgets('test: login', (WidgetTester tester) async {
      await tester.pumpWidget(
          ProviderScope(child: createWidgetForTesting(const LoginPage())));

      var loginButton = find.byIcon(Icons.arrow_forward);
      var accountTextField = find.byType(TextField).first;
      var passwordTextField = find.byType(TextField).at(1);

      expect(find.text("Welcome\nBack"), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text("Please enter account"), findsOneWidget);
      expect(find.text("Please enter password"), findsOneWidget);

      await tester.enterText(accountTextField, 'Chien@gmail.com');
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text("Please enter account"), findsNothing);
      expect(find.text("Please enter password"), findsOneWidget);

      await tester.enterText(accountTextField, '');
      await tester.enterText(passwordTextField, '123456');
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text("Please enter account"), findsOneWidget);
      expect(find.text("Please enter password"), findsNothing);
    });

    testWidgets('test: welcome', (WidgetTester tester) async {
      var userName = 'Chien';
      await sharedPrefs.setUserName(userName);

      await tester.pumpWidget(
          ProviderScope(child: createWidgetForTesting(const WelcomePage())));

      expect(find.text(userName), findsOneWidget);
    });
  });
}
