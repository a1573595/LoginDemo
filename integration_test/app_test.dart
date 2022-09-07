import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:login/generated/l10n.dart';

import 'package:login/main.dart' as app;
import 'package:login/page/splash/splash_page.dart';
import 'package:login/page/login/login_page.dart';
import 'package:login/page/welcome/welcome_page.dart';

import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('end-to-end test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Login test', (tester) async {
      /// launch App
      app.main();

      /// 這樣launch也可以，但會跳過部分初始化步驟因此不建議
      // await tester.pumpWidget(const ProviderScope(child: MyApp()));

      /// 等待套件初始化後載入Splash
      var lock = true;
      while (lock) {
        if (tester.any(find.byType(SplashPage))) {
          lock = false;
        } else {
          await tester.pumpAndSettle();
        }
      }

      /// 比對頁面
      expect(find.byType(SplashPage), findsOneWidget);

      tester.binding.scheduleWarmUpFrame();
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.pump();

      /// 比對元件
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text(S.current.welcome_back), findsOneWidget);

      /// 尋找指定元件
      var loginButton = find.byIcon(Icons.arrow_forward);
      var accountTextField = find.byType(TextField).first;
      var passwordTextField = find.byType(TextField).at(1);

      /// 按下指定元件
      await safeTap.call(tester, loginButton);
      await tester.pump();

      /// 讓Provider有時間可以反應到Widget上
      await tester.pumpAndSettle();

      expect(find.text(S.current.please_enter_account), findsOneWidget);
      expect(find.text(S.current.please_enter_password), findsOneWidget);

      /// 輸入內容至指定元件
      await tester.enterText(accountTextField, 'Chien@gmail.com');
      await tester.pump();
      await tester.enterText(passwordTextField, 'abc12345');
      await tester.pump();
      await safeTap.call(tester, loginButton);
      await tester.pumpAndSettle();

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
