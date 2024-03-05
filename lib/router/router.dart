import 'package:bot_toast/bot_toast.dart';
import 'package:go_router/go_router.dart';
import 'package:login/page/console/log_console_page.dart';
import 'package:login/page/login/login_page.dart';
import 'package:login/page/splash/splash_page.dart';
import 'package:login/page/welcome/welcome_page.dart';

import 'app_page.dart';

const pageLogin = '/login';
const pageWelcome = '/welcome';

final GoRouter rootRouter = GoRouter(
  observers: [BotToastNavigatorObserver()],

  /// 初始路徑
  // initialLocation: sharedPrefs.getIsLogin() != true ? pageLogin : pageWelcome,
  // initialLocation: prefsBox.getIsLogin() != true ? pageLogin : pageWelcome,
  routes: [
    GoRoute(
      name: AppPage.splash.name,
      path: AppPage.splash.fullPath,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: AppPage.logConsole.name,
      path: AppPage.logConsole.fullPath,
      builder: (context, state) => const LogConsolePage(),
    ),
    GoRoute(
      name: AppPage.login.name,
      path: AppPage.login.fullPath,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: AppPage.welcome.name,
      path: AppPage.welcome.fullPath,
      builder: (context, state) => const WelcomePage(),
    ),
  ],
);
