// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_TW locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_TW';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("帳號"),
        "forgot_password": MessageLookupByLibrary.simpleMessage("忘記密碼"),
        "hi": MessageLookupByLibrary.simpleMessage("嗨"),
        "http_error_401": MessageLookupByLibrary.simpleMessage("請先登入"),
        "http_error_403": MessageLookupByLibrary.simpleMessage("無效的Token"),
        "http_error_405": MessageLookupByLibrary.simpleMessage("用戶名稱不可為空"),
        "http_error_406": MessageLookupByLibrary.simpleMessage("用戶密碼不可為空"),
        "http_error_408": MessageLookupByLibrary.simpleMessage("用戶不存在"),
        "http_error_409": MessageLookupByLibrary.simpleMessage("用戶密碼不正確"),
        "loading": MessageLookupByLibrary.simpleMessage("載入中..."),
        "log_out": MessageLookupByLibrary.simpleMessage("登出"),
        "nothing": MessageLookupByLibrary.simpleMessage("什麼都沒有"),
        "password": MessageLookupByLibrary.simpleMessage("密碼"),
        "please_enter_account": MessageLookupByLibrary.simpleMessage("請輸入帳號"),
        "please_enter_password": MessageLookupByLibrary.simpleMessage("請輸入密碼"),
        "sign_in": MessageLookupByLibrary.simpleMessage("登入"),
        "sign_up": MessageLookupByLibrary.simpleMessage("註冊"),
        "welcome_back": MessageLookupByLibrary.simpleMessage("歡迎\n回來")
      };
}
