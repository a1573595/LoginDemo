import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/generated/l10n.dart';

import 'package:login/main.dart' as app;
import 'package:login/page/splash/splash_page.dart';
import 'package:login/page/login/login_page.dart';
import 'package:login/page/welcome/welcome_page.dart';

import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Login test', (tester) async {
      /// launch app
      app.main();

      /// 觸發畫面刷新
      await tester.pumpAndSettle();

      /// 比對頁面
      expect(find.byType(SplashPage), findsOneWidget);

      tester.binding.scheduleWarmUpFrame();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      /// 比對元件
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text("Welcome\nBack"), findsOneWidget);

      /// 尋找指定元件
      var loginButton = find.byIcon(Icons.arrow_forward);
      var accountTextField = find.byType(TextField).first;
      var passwordTextField = find.byType(TextField).at(1);

      expect(find.text(S.current.welcome_back), findsOneWidget);

      /// 按下指定元件
      // await tester.tap(loginButton);
      await safeTap.call(tester, loginButton);
      await tester.pump();

      expect(find.text(S.current.please_enter_account), findsOneWidget);
      expect(find.text(S.current.please_enter_password), findsOneWidget);

      /// 輸入內容至指定元件
      await tester.enterText(accountTextField, 'Chien@gmail.com');
      await tester.pump();
      await tester.enterText(passwordTextField, 'abc12345');
      await tester.pump();
      await safeTap.call(tester, loginButton);
      await tester.pump();

      /// 等待API回來
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(WelcomePage), findsOneWidget);

      expect(find.text(S.current.hi), findsOneWidget);
      expect(find.text(S.current.log_out), findsOneWidget);
    });
  });
}

/// 確保元件在可見狀態
var safeTap = (WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
};
