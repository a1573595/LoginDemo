import 'package:hive_flutter/adapters.dart';

const String _boxPreferences = "preferences";

const String _keyIsLogin = "isLogin";
const String _keyAccount = "account";
const String _keyUserName = "userName";

final prefsBox = _PrefsBox();

class _PrefsBox {
  late Box box;

  init() async {
    box = await Hive.openBox(_boxPreferences);
  }

  bool getIsLogin() => (box.get(_keyIsLogin) as bool?) ?? false;

  Future<void> setIsLogin(bool value) => box.put(_keyIsLogin, value);

  String? getAccount() => box.get(_keyAccount);

  Future<void> setAccount(String? value) {
    if (value == null) {
      return box.delete(_keyAccount);
    } else {
      return box.put(_keyAccount, value);
    }
  }

  String? getUserName() => box.get(_keyUserName);

  Future<void> setUserName(String? value) {
    if (value == null) {
      return box.delete(_keyUserName);
    } else {
      return box.put(_keyUserName, value);
    }
  }

  Future<int> clear() => box.clear();

  Future<void> close() => box.close();
}
