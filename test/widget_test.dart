// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:login/generated/l10n.dart';
import 'package:login/logger/logger.dart';

import 'package:login/page/login/login_page.dart';
import 'package:login/page/welcome/welcome_page.dart';
import 'package:login/utils/edge_util.dart';
import 'package:login/utils/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Widget createWidgetForTesting(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  /// 載入多語系檔案
  await S.load(const Locale.fromSubtags(languageCode: 'en'));

  setUp(() async {
    await logger.init(logger: Logger(level: Level.error));

    SharedPreferences.setMockInitialValues({});
    await sharedPrefs.init();

    /// 無法取得ScreenUtil要自行賦值
    edgeUtil.screenHorizontal = 32;
    edgeUtil.screenHorizontalPadding =
        EdgeInsets.symmetric(horizontal: edgeUtil.screenHorizontal);
  });

  var account = "Chien@gmail.com";
  var password = "abc12345";

  group('Widget test', () {
    testWidgets('LoginPage', (WidgetTester tester) async {
      /// 載入Widget
      await tester.pumpWidget(
          ProviderScope(child: createWidgetForTesting(const LoginPage())));

      /// 尋找指定元件
      var loginButton = find.byIcon(Icons.arrow_forward);
      var accountTextField = find.byType(TextField).first;
      var passwordTextField = find.byType(TextField).at(1);

      /// 比對元件
      expect(find.text(S.current.welcome_back), findsOneWidget);

      /// 按下指定元件
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text(S.current.please_enter_account), findsOneWidget);
      expect(find.text(S.current.please_enter_password), findsOneWidget);

      /// 輸入內容至指定元件
      await tester.enterText(accountTextField, account);
      await tester.enterText(passwordTextField, '');
      await tester.safeTap(loginButton);
      await tester.pump();

      expect(find.text(S.current.please_enter_account), findsNothing);
      expect(find.text(S.current.please_enter_password), findsOneWidget);

      await tester.enterText(accountTextField, '');
      await tester.enterText(passwordTextField, password);
      await tester.safeTap(loginButton);
      await tester.pump();

      expect(find.text(S.current.please_enter_account), findsOneWidget);
      expect(find.text(S.current.please_enter_password), findsNothing);

      await tester.enterText(accountTextField, account);
      await tester.enterText(passwordTextField, password);
      await tester.safeTap(loginButton);

      /// 讓Provider有時間可以反應到Widget上
      await tester.pumpAndSettle();

      expect(find.text(S.current.please_enter_account), findsNothing);
      expect(find.text(S.current.please_enter_password), findsNothing);
    });

    testWidgets('WelcomePage', (WidgetTester tester) async {
      var userName = 'Chien';
      await sharedPrefs.setUserName(userName);

      await tester.pumpWidget(
          ProviderScope(child: createWidgetForTesting(const WelcomePage())));

      expect(find.text(S.current.hi), findsOneWidget);
      expect(find.text(userName), findsOneWidget);
      expect(find.text(S.current.log_out), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  safeTap(Finder finder) async {
    await ensureVisible(finder);
    await pumpAndSettle();
    await tap(finder);
  }
}
