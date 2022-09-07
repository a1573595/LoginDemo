import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_page.dart';
import '../../utils/prefs_box.dart';
import '../../utils/shared_prefs.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        /// 也可以在Splash判斷路徑
        /// 有利於載入複雜的資料
        // var isLogin = sharedPrefs.getIsLogin();
        var isLogin = prefsBox.getIsLogin();
        var page =
            isLogin != true ? AppPage.login.fullPath : AppPage.welcome.fullPath;
        context.go(page);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
