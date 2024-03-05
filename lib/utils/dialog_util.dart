import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:login/generated/l10n.dart';

class DialogUtil {
  /// BotToast的取消Callback
  static CancelFunc? _loaderCancel;

  static CancelFunc showToast(String text) {
    return BotToast.showText(text: text);
  }

  static CancelFunc showLoading({bool cancelable = false}) {
    return _loaderCancel = BotToast.showEnhancedWidget(
        /// 只能有一個實體
        /// 依照groupKey識別
        onlyOne: true,
        groupKey: 'Loader',

        /// 換頁自動關閉
        crossPage: true,

        /// 針對彈出鍵盤額外給予Dialog補償
        /// 實測效果不佳
        enableKeyboardSafeArea: false,

        /// 防止被Back取消
        backButtonBehavior:
            cancelable ? BackButtonBehavior.close : BackButtonBehavior.ignore,
        toastBuilder: (textCancel) =>

            /// 給定背景防止觸發其他UI
            Material(
              color: Colors.black54,

              /// 點擊外圍是否可以取消
              child: InkWell(
                /// 關閉Ripple效果
                splashFactory: NoSplash.splashFactory,

                /// 隱藏點擊效果
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  if (cancelable) {
                    _loaderCancel?.call();
                  }
                },
                child: AlertDialog(
                  content: Row(
                    children: [
                      const CircularProgressIndicator(),
                      Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Text(S.current.loading)),
                    ],
                  ),
                ),
              ),
            ));
  }

  static void cancelLoading() {
    _loaderCancel?.call();
  }
}
