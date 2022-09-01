import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/router/router.dart';
import 'package:login/tool/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await sharedPrefs.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationProvider: rootRouter.routeInformationProvider,
        routeInformationParser: rootRouter.routeInformationParser,
        routerDelegate: rootRouter.routerDelegate,
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
