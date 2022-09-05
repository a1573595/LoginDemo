import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login/utils/edge_util.dart';
import 'package:login/utils/helper.dart';

import '../../generated/l10n.dart';
import '../../logger/log_console_on_shake.dart';
import '../../logger/logger.dart';
import '../../model/login_res.dart';
import '../../repository/login_repository.dart';
import '../../router/app_page.dart';
import '../../utils/images.dart';
import '../../utils/shared_prefs.dart';

part 'login_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogConsoleOnShake(Container(
      padding: edgeUtil.screenHorizontalPadding,
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

  final FocusNode _passwordFocusNode = FocusNode();

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
              _AccountAutoComplete(_accountController, _passwordFocusNode),
              const SizedBox(
                height: 32,
              ),
              _PasswordTextField(_passwordController, _passwordFocusNode),
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

class _AccountAutoComplete extends ConsumerWidget {
  _AccountAutoComplete(this._controller, this._passwordFocusNode, {Key? key})
      : super(key: key);

  final TextEditingController _controller;
  final FocusNode _passwordFocusNode;

  final FocusNode _focusNode = FocusNode();

  final List<String> emailSuffix = const [
    '@gmail.com',
    '@outlook.com',
    '@hotmail.com',
    '@yahoo.com',
  ];

  final List<String> autoCompleteResult = [
    '@gmail.com',
    '@outlook.com',
    '@hotmail.com',
    '@yahoo.com',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RawAutocomplete<String>(
        textEditingController: _controller,
        focusNode: _focusNode,

        /// 選項
        optionsBuilder: (textField) {
          /// TODO('如何將這裡的邏輯放到ViewModel？')
          var text = textField.text;

          if (text.isEmpty) {
            return const [];
          } else {
            for (var i = 0; i < emailSuffix.length; i++) {
              autoCompleteResult[i] = text.split('@')[0] + emailSuffix[i];
            }
            return autoCompleteResult;
          }
        },

        /// 選項Widget
        optionsViewBuilder: (context, onAutoCompleteSelect, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.white,
              elevation: 2,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemCount: options.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(options.elementAt(index)),
                        onTap: () {
                          _controller.text = options.elementAt(index);
                          _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controller.text.length));

                          /// 這裡用nextFocus會失效
                          _passwordFocusNode.requestFocus();
                        },
                      );
                    },
                  )),
            )),

        /// 輸入框Widget
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
            _AccountTextFormField(controller, focusNode));
  }
}

class _AccountTextFormField extends ConsumerWidget {
  const _AccountTextFormField(this._controller, this._focusNode, {Key? key})
      : super(key: key);

  final TextEditingController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,

      /// 輸入文字類型
      keyboardType: TextInputType.emailAddress,

      /// 鍵盤下一步類型
      textInputAction: TextInputAction.next,

      /// 輸入格式過濾
      inputFormatters: [
        LengthLimitingTextInputFormatter(32),
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@._]"))
      ],

      /// 下一步按鍵的callback
      onFieldSubmitted: (value) {
        /// 前往下一個焦點
        FocusScope.of(context).nextFocus();
      },

      /// 當輸入框異動時
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
  const _PasswordTextField(this._controller, this._passwordFocusNode,
      {Key? key})
      : super(key: key);

  final TextEditingController _controller;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: _controller,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
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
