import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/tool/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await sharedPrefs.init();
  });

  test("test get", () async {
    expect(sharedPrefs.getUserName(), isNull);
    expect(sharedPrefs.getAccount(), isNull);
    expect(sharedPrefs.getIsLogin(), isNull);
  });

  test("test set", () async {
    var userName = 'Chien';
    var account = 'Chien@gmail.com';
    await sharedPrefs.setUserName(userName);
    await sharedPrefs.setAccount(account);
    await sharedPrefs.setIsLogin(true);

    expect(sharedPrefs.getUserName(), userName);
    expect(sharedPrefs.getAccount(), account);
    expect(sharedPrefs.getIsLogin(), true);
  });

  test("test clear", () async {
    await sharedPrefs.clear();

    expect(sharedPrefs.getUserName(), isNull);
    expect(sharedPrefs.getAccount(), isNull);
    expect(sharedPrefs.getIsLogin(), isNull);
  });
}
