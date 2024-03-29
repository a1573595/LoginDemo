import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:login/router/router.dart';
import 'package:login/utils/edge_util.dart';
import 'package:login/utils/extension_util.dart';
import 'package:login/utils/shared_prefs.dart';

import 'utils/prefs_box.dart';
import 'generated/l10n.dart';
import 'logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await logger.init();
  // await sharedPrefs.init();

  await Hive.initFlutter();
  await prefsBox.init();

  logger.i('Start App');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        minTextAdapt: true,
        builder: (context, child) {
          EdgeUtil.initAfterScreenUtil();
          var textTheme = Typography.tall2018.apply(fontSizeFactor: 1.sp);

          String? lastLocation;
          rootRouter.routerDelegate.addListener(() {
            if (lastLocation != rootRouter.currentLocation) {
              lastLocation = rootRouter.currentLocation;
              logger.i('Router change:  $lastLocation');
            }
          });

          return MaterialApp.router(
            builder: BotToastInit(),
            routerConfig: rootRouter,
            title: 'Login Example',
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: AppBarTheme(
                  color: Colors.white,
                  iconTheme: const IconThemeData(
                    color: Colors.black,
                  ),
                  titleTextStyle: textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                  )),
              textTheme: textTheme,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
          );
        },
      );
}
