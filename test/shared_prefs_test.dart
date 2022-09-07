import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/utils/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('shared prefs unit test', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await sharedPrefs.init();
    });

    test("get value", () async {
      expect(sharedPrefs.getUserName(), isNull);
      expect(sharedPrefs.getAccount(), isNull);
      expect(sharedPrefs.getIsLogin(), null);
    });

    test("set value", () async {
      var userName = 'Chien';
      var account = 'Chien@gmail.com';
      await sharedPrefs.setUserName(userName);
      await sharedPrefs.setAccount(account);
      await sharedPrefs.setIsLogin(true);

      expect(sharedPrefs.getUserName(), userName);
      expect(sharedPrefs.getAccount(), account);
      expect(sharedPrefs.getIsLogin(), true);
    });

    test("clear value", () async {
      await sharedPrefs.clear();

      expect(sharedPrefs.getUserName(), isNull);
      expect(sharedPrefs.getAccount(), isNull);
      expect(sharedPrefs.getIsLogin(), isNull);
    });
  });
}
