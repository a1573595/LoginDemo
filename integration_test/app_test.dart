import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:login/main.dart' as app;
import 'package:login/page/launch/launch_page.dart';
import 'package:login/page/login/view/login_page.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mockito/mockito.dart';

late MockWebServer _server;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    _server = MockWebServer();
    await _server.start();
  });

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      app.main();

      await tester.pump();

      expect(find.byType(LaunchPage), findsOneWidget);

      tester.binding.scheduleWarmUpFrame();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text("Welcome\nBack"), findsOneWidget);

      var loginButton = find.byIcon(Icons.arrow_forward);
      var accountTextField = find.byType(TextField).first;
      var passwordTextField = find.byType(TextField).at(1);

      expect(find.text("Welcome\nBack"), findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text("Please enter account"), findsOneWidget);
      expect(find.text("Please enter password"), findsOneWidget);

      await tester.enterText(accountTextField, 'Chien@gmail.com');
      // await tester.ensureVisible(loginButton);
      // await tester.pumpAndSettle();
      // await tester.tap(loginButton);
      await safeTap.call(tester, loginButton);
      await tester.pump();

      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}

var safeTap = (WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
};

extension on WidgetTester {
  Future<List<void>> safeTap(Finder finder) {
    return Future.wait<void>(
        [ensureVisible(finder), pumpAndSettle(), tap(finder)]);
  }
}
