import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login/tool/shared_prefs.dart';

import '../../generated/l10n.dart';
import '../../router/app_page.dart';
import '../../tool/images.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Images.welcome), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 64),
                child: Text(
                  S.current.hi,
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
              Expanded(
                  child: Center(
                      child: Text('${sharedPrefs.getUserName()}',
                          style: const TextStyle(
                              fontSize: 48, color: Colors.white)))),
              const Align(
                alignment: Alignment.bottomRight,
                child: LogoutText(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutText extends StatefulWidget {
  const LogoutText({Key? key}) : super(key: key);

  @override
  State<LogoutText> createState() => _LogoutTextState();
}

class _LogoutTextState extends State<LogoutText> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => logout(context),
      child: Text(S.current.log_out,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            color: Color(0xff4c505b),
          )),
    );
  }

  void logout(BuildContext context) async {
    final result = await Future.wait([
      sharedPrefs.setUserName(''),
      sharedPrefs.setIsLogin(false),
    ]);

    if (!mounted) return;
    if (result.isNotEmpty && !result.any((element) => false)) {
      context.go(AppPage.login.fullPath);
    }
  }
}
