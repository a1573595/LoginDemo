import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login/tool/helper.dart';

import '../../generated/l10n.dart';
import '../../logger/log_console_on_shake.dart';
import '../../logger/logger.dart';
import '../../model/login_res.dart';
import '../../repository/login_repository.dart';
import '../../router/app_page.dart';
import '../../tool/images.dart';
import '../../tool/shared_prefs.dart';

part 'login_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogConsoleOnShake(Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        image:
            DecorationImage(image: AssetImage(Images.login), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _LoginBody(),
      ),
    ));
  }
}

class _LoginBody extends ConsumerWidget {
  _LoginBody({Key? key}) : super(key: key);

  bool _isOpen = false;

  final TextEditingController _accountController =
      TextEditingController(text: sharedPrefs.getAccount());
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(_loginViewModel, (previous, next) {
      if (_isOpen) {
        Navigator.of(context).pop();
      }

      if (next is AsyncValue<LoginRes>) {
        next.when(
          data: (data) {
            if (data.isLoginSuccess) {
              context.go(AppPage.welcome.fullPath);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.current.login_failed)));
            }
          },
          loading: () => showLoaderDialog(context),
          error: (e, _) => Text(e.toString()),
        );
      }
    });

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: Text(
                  S.current.welcome_back,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              _AccountTextField(_accountController),
              const SizedBox(
                height: 32,
              ),
              _PasswordTextField(_passwordController),
              const SizedBox(
                height: 48,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.sign_in,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xff4c505b),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () => ref.read(_loginViewModel.notifier).login(
                          _accountController.text, _passwordController.text),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                  onPressed: () {
                    showSnackBar(context, S.current.nothing);
                  },
                  child: Text(
                    S.current.sign_up,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                      color: Color(0xff4c505b),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showSnackBar(context, S.current.nothing);
                  },
                  child: Text(
                    S.current.forgot_password,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                      color: Color(0xff4c505b),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  void showLoaderDialog(BuildContext context) {
    _isOpen = true;

    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(S.current.loading)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) => _isOpen = false);
  }
}

class _AccountTextField extends ConsumerWidget {
  const _AccountTextField(this._controller, {Key? key}) : super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        ref.read(_isAccountRemoveable.state).state = value.isNotEmpty;
      },
      decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: S.current.account,
          errorText: ref.watch(_isAccountError)
              ? S.current.please_enter_account
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Consumer(builder: (context, ref, child) {
                return ref.watch(_isAccountRemoveable.state).state
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          ref.read(_isAccountRemoveable.state).state = false;
                        },
                        icon: const Icon(Icons.cancel),
                      )
                    : const SizedBox();
              }),
            ),
          )),
    );
  }
}

class _PasswordTextField extends ConsumerWidget {
  const _PasswordTextField(this._controller, {Key? key}) : super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        ref.read(_isPasswordRemoveable.state).state = value.isNotEmpty;
      },
      obscureText: !ref.watch(_isPasswordVisible.state).state,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: S.current.password,
          errorText: ref.watch(_isPasswordError)
              ? S.current.please_enter_password
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(onPressed: () {
                    ref
                        .read(_isPasswordVisible.state)
                        .update((state) => !state);
                  }, icon: Consumer(builder: (context, ref, child) {
                    return Icon(!ref.watch(_isPasswordVisible.state).state
                        ? Icons.visibility
                        : Icons.visibility_off);
                  })),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Consumer(builder: (context, ref, child) {
                    return ref.watch(_isPasswordRemoveable.state).state
                        ? IconButton(
                            onPressed: () {
                              _controller.clear();
                              ref.read(_isPasswordRemoveable.state).state =
                                  false;
                            },
                            icon: const Icon(Icons.cancel),
                          )
                        : const SizedBox();
                  }),
                ),
              )
            ],
          )),
    );
  }
}
