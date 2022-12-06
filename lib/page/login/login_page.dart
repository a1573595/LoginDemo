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
import '../../utils/prefs_box.dart';
import '../../utils/dialog_util.dart';
import '../../widget/shake_widget.dart';

part 'login_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LogConsoleOnShake(Container(
      padding: EdgeUtil.screenHorizontalPadding,
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

  // bool _isOpen = false;

  final TextEditingController _accountController =
      // TextEditingController(text: sharedPrefs.getAccount());
      TextEditingController(text: prefsBox.getAccount());
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

  late void Function() accountShakeMethod;

  late void Function() passwordShakeMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(_loginViewModel, (previous, next) {
      next.when(
        data: (data) {
          // if (_isOpen) {
          //   Navigator.of(context).pop();
          // }
          DialogUtil.cancelLoading();

          if (data.isLoginSuccess) {
            context.go(AppPage.welcome.fullPath);
          } else {
            DialogUtil.showToast(S.current.login_failed);
          }
        },
        // loading: () => showLoaderDialog(context),
        loading: () => DialogUtil.showLoading(),
        error: (e, _) {
          DialogUtil.cancelLoading();
          DialogUtil.showToast(e.toString());
        },
      );
    });

    ref.listen(_isAccountError, (previous, next) {
      if (next) {
        accountShakeMethod();
      }
    });

    ref.listen(_isPasswordError, (previous, next) {
      if (next) {
        passwordShakeMethod();
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
              ShakeWidget(
                builder: (void Function() shake) {
                  accountShakeMethod = shake;
                },
                child: _AccountAutoComplete(
                    _accountController, _passwordFocusNode),
              ),
              const SizedBox(
                height: 32,
              ),
              ShakeWidget(
                  builder: (void Function() shake) {
                    passwordShakeMethod = shake;
                  },
                  child: _PasswordTextField(
                      _passwordController, _passwordFocusNode)),
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

                  /// 可拖曳Widget
                  Draggable(
                      feedback: const FloatingActionButton(
                          backgroundColor: Color(0xff4c505b),
                          onPressed: null,
                          child: Icon(Icons.arrow_forward)),
                      childWhenDragging: const SizedBox(
                        height: 56,
                      ),
                      child: FloatingActionButton(
                          backgroundColor: const Color(0xff4c505b),
                          child: const Icon(Icons.arrow_forward),
                          onPressed: () => ref
                              .read(_loginViewModel.notifier)
                              .login(_accountController.text,
                                  _passwordController.text))),
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

  /// Flutter原生Dialog
  /// 需要綁定context，換頁後不會保留
// void showLoaderDialog(BuildContext context) {
//   _isOpen = true;
//
//   /// 防止被Back取消
//   Widget alert = WillPopScope(
//     onWillPop: () async {
//       return false;
//     },
//     child: AlertDialog(
//       content: Row(
//         children: [
//           const CircularProgressIndicator(),
//           Container(
//               margin: const EdgeInsets.only(left: 20),
//               child: Text(S.current.loading)),
//         ],
//       ),
//     ),
//   );
//   showDialog(
//     /// 點擊外圍是否可以取消
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   ).then((value) => _isOpen = false);
// }
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
            _AccountTextFormField(controller, focusNode, _passwordFocusNode));
  }
}

class _AccountTextFormField extends ConsumerWidget {
  const _AccountTextFormField(
      this._controller, this._focusNode, this._passwordFocusNode,
      {Key? key})
      : super(key: key);

  final TextEditingController _controller;
  final FocusNode _focusNode;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: _controller.text.isEmpty,

      /// 輸入文字類型
      keyboardType: TextInputType.emailAddress,

      /// 鍵盤下一步類型
      textInputAction: TextInputAction.next,

      /// 禁止複製貼上等選項
      enableInteractiveSelection: false,

      /// 輸入格式過濾
      inputFormatters: [
        LengthLimitingTextInputFormatter(32),
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@._]"))
      ],

      /// 下一步按鍵的callback
      onFieldSubmitted: (value) {
        /// 前往下一個焦點
        /// 若沒有內容則FocusScope會失效
        /// 要使用FocusNode
        // FocusScope.of(context).nextFocus();
        _passwordFocusNode.requestFocus();
      },

      /// 編輯完成的callback
      // onEditingComplete: () {
      //   FocusScope.of(context).nextFocus();
      // },
      /// 當輸入框異動時
      onChanged: (value) {
        ref.read(_isAccountClearable.notifier).state = value.isNotEmpty;
      },
      decoration: InputDecoration(

          /// 是否使用輸入框背景
          /// 預設透明
          filled: true,

          /// 框入框背景色
          fillColor: Colors.grey.shade100,

          /// 提示文字
          hintText: S.current.account,

          /// 錯誤提示文字
          errorText: ref.watch(_isAccountError)
              ? S.current.please_enter_account
              : null,

          /// 輸入框邊框
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Consumer(builder: (context, ref, child) {
                return ref.watch(_isAccountClearable)
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          ref.read(_isAccountClearable.notifier).state = false;
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
      enableInteractiveSelection: false,
      onChanged: (value) {
        ref.read(_isPasswordClearable.notifier).state = value.isNotEmpty;
      },

      /// 是否模糊文字
      obscureText: !ref.watch(_isPasswordVisible),
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
                        .read(_isPasswordVisible.notifier)
                        .update((state) => !state);
                  }, icon: Consumer(builder: (context, ref, child) {
                    return Icon(!ref.watch(_isPasswordVisible)
                        ? Icons.visibility
                        : Icons.visibility_off);
                  })),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Consumer(builder: (context, ref, child) {
                    return ref.watch(_isPasswordClearable)
                        ? IconButton(
                            onPressed: () {
                              _controller.clear();
                              ref.read(_isPasswordClearable.notifier).state =
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
