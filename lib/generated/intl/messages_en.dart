// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "hi": MessageLookupByLibrary.simpleMessage("Hi"),
        "http_error_401":
            MessageLookupByLibrary.simpleMessage("Please login first"),
        "http_error_403": MessageLookupByLibrary.simpleMessage("Invalid token"),
        "http_error_405":
            MessageLookupByLibrary.simpleMessage("User name cannot be empty"),
        "http_error_406": MessageLookupByLibrary.simpleMessage(
            "User password cannot be empty"),
        "http_error_408":
            MessageLookupByLibrary.simpleMessage("User does not exist"),
        "http_error_409":
            MessageLookupByLibrary.simpleMessage("User password is incorrect"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "log_out": MessageLookupByLibrary.simpleMessage("Log Out"),
        "nothing": MessageLookupByLibrary.simpleMessage("Nothing"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "please_enter_account":
            MessageLookupByLibrary.simpleMessage("Please enter account"),
        "please_enter_password":
            MessageLookupByLibrary.simpleMessage("Please enter password"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Sign In"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "welcome_back": MessageLookupByLibrary.simpleMessage("Welcome\nBack")
      };
}
