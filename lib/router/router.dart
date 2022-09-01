import 'package:go_router/go_router.dart';

import '../page/splash/splash_page.dart';
import '../page/login/login_page.dart';
import '../page/welcome/welcome_page.dart';
import '../tool/shared_prefs.dart';
import 'app_page.dart';

const pageLogin = '/login';
const pageWelcome = '/welcome';

final GoRouter rootRouter = GoRouter(

    /// 初始路徑
    // initialLocation: sharedPrefs.getIsLogin() != true ? pageLogin : pageWelcome,
    routes: [
      GoRoute(
        name: AppPage.splash.name,
        path: AppPage.splash.fullPath,
        builder: (context, state) => const SplashPage(),
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
    ]);
