import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefs = _SharedPrefs();

const String _keyAccount = "account";
const String _keyUserName = "userName";

const String _keyIsLogin = "isLogin";

class _SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String? getAccount() {
    return _sharedPrefs.getString(_keyAccount);
  }

  Future<bool> setAccount(String text) async {
    return _sharedPrefs.setString(_keyAccount, text);
  }

  String? getUserName() {
    return _sharedPrefs.getString(_keyUserName);
  }

  Future<bool> setUserName(String text) async {
    return _sharedPrefs.setString(_keyUserName, text);
  }

  bool? getIsLogin() {
    return _sharedPrefs.getBool(_keyIsLogin);
  }

  Future<bool> setIsLogin(bool isLogin) async {
    return _sharedPrefs.setBool(_keyIsLogin, isLogin);
  }

  Future<bool> clear() async {
    return _sharedPrefs.clear();
  }
}
