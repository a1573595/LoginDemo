import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login/tool/helper.dart';

import '../../main.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        image:
            DecorationImage(image: AssetImage(Images.login), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _LoginBody(),
      ),
    );
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
    ref.listen(_gotoNext, (previous, next) {
      if (next is String && next.isNotEmpty) {
        showLoaderDialog(context);

        sharedPrefs.setAccount(ref.read(_account.state).state!).whenComplete(
            () => sharedPrefs
                .setIsLogin(true)
                .whenComplete(() => ref.read(_loginRes.notifier).login()));
      }
    });

    ref.listen(_loginRes, (previous, next) {
      if (_isOpen) {
        Navigator.of(context).pop();
      }

      if (next is AsyncValue<LoginRes>) {
        next.when(
          data: (data) => sharedPrefs.setUserName(data.memberName).whenComplete(
              () => sharedPrefs
                  .setIsLogin(true)
                  .whenComplete(() => context.go(AppPage.welcome.fullPath))),
          loading: () {},
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
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 64),
                child: Text(
                  "Welcome\nBack",
                  style: TextStyle(color: Colors.white, fontSize: 32),
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
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Color(0xff4c505b),
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xff4c505b),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () => signIn(context, ref),
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
                    showSnackBar(context, 'Nothing');
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
                      color: Color(0xff4c505b),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showSnackBar(context, 'Nothing');
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
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

  void signIn(BuildContext context, WidgetRef ref) {
    var account = _accountController.text;
    var password = _passwordController.text;

    ref.read(_account.state).state = account;
    ref.read(_password.state).state = password;
  }

  void showLoaderDialog(BuildContext context) {
    _isOpen = true;

    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text("Loading...")),
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
          hintText: 'Account',
          errorText: ref.watch(_isAccountError) ? "Please enter account" : null,
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
        // ref.read(_viewModel).isPasswordRemoveable = value.isNotEmpty;
        ref.read(_isPasswordRemoveable.state).state = value.isNotEmpty;
      },
      // obscureText:
      //     !ref.watch(_viewModel.select((value) => value.isPasswordVisible)),
      obscureText: !ref.watch(_isPasswordVisible.state).state,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: 'Password',
          errorText:
              ref.watch(_isPasswordError) ? "Please enter password" : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IconButton(
              //     onPressed: () {
              //       ref.read(_viewModel).isPasswordVisible =
              //           !ref.read(_viewModel).isPasswordVisible;
              //     },
              //     icon: Icon(!ref.watch(
              //             _viewModel.select((value) => value.isPasswordVisible))
              //         ? Icons.visibility
              //         : Icons.visibility_off)),
              // Consumer(builder: (context, ref, child) {
              //   return ref.watch(_viewModel
              //           .select((value) => value.isPasswordRemoveable))
              //       ? IconButton(
              //           onPressed: () {
              //             _controller.clear();
              //             ref.read(_viewModel).isPasswordRemoveable = false;
              //           },
              //           icon: const Icon(Icons.cancel),
              //         )
              //       : const SizedBox();
              // })
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
