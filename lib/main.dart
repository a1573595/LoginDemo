import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login/page/launch/launch_page.dart';
import 'package:login/page/login/view/login_page.dart';
import 'package:login/page/welcome/welcome_page.dart';
import 'package:login/tool/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(const ProviderScope(child: MyApp()));
}

const pageLogin = '/login';
const pageWelcome = '/welcome';

CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

final GoRouter _router = GoRouter(
    // initialLocation: sharedPrefs.getIsLogin() != true ? pageLogin : pageWelcome,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LaunchPage(),
        // pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        //   context: context,
        //   state: state,
        //   child: const LaunchPage(),
        // ),
      ),
      GoRoute(
        path: pageLogin,
        builder: (context, state) => const LoginPage(),
        // pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        //   context: context,
        //   state: state,
        //   child: const LoginPage(),
        // ),
      ),
      GoRoute(
        path: pageWelcome,
        builder: (context, state) => const WelcomePage(),
        // pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        //   context: context,
        //   state: state,
        //   child: const WelcomePage(),
        // ),
      ),
    ]);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Login Example',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //       appBarTheme: const AppBarTheme(
  //           color: Colors.white,
  //           iconTheme: IconThemeData(color: Colors.black),
  //           titleTextStyle: TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 20)),
  //     ),
  //     home: const LaunchPage(),
  //   );
  // }

  @override
  Widget build(BuildContext context) =>
      MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,

        title: 'Login Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
      );
}

// class LoginViewModel {
//   final UserRepository repository = UserRepository();
//
//   final passwordRegex = RegExp(r'^[a-zA-Z0-9]+$');
//
//   bool _checkAccount(String account) {
//     return account.isNotEmpty;
//   }
//
//   bool _checkPassword(String password) {
//     return password.isNotEmpty && passwordRegex.hasMatch(password);
//   }
//
//   Future<bool> login(String account, String password) {
//     if (_checkAccount(account)) {
//       return Future.value(false);
//     } else if (_checkPassword(password)) {
//       return Future.value(false);
//     } else {
//       return repository.login(account, password);
//     }
//   }
// }
