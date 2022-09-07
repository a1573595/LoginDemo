import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:login/utils/prefs_box.dart';

import 'directory.dart';

void main() {
  group('shared prefs unit test', () {
    setUp(() async {
      /// Unittest為Dart VM
      /// 不要使用Hive.initFlutter()
      var dir = await getTempDir();
      Hive.init(dir.path);
      await prefsBox.init();
    });

    tearDown(() async {
      /// 清除緩存
      await Hive.deleteFromDisk();
    });

    test("get value", () async {
      expect(prefsBox.getUserName(), isNull);
      expect(prefsBox.getAccount(), isNull);
      expect(prefsBox.getIsLogin(), false);
    });

    test("set value", () async {
      var userName = 'Chien';
      var account = 'Chien@gmail.com';

      await prefsBox.setUserName(userName);
      await prefsBox.setAccount(account);
      await prefsBox.setIsLogin(true);

      expect(prefsBox.getUserName(), userName);
      expect(prefsBox.getAccount(), account);
      expect(prefsBox.getIsLogin(), true);
    });

    test("clear value", () async {
      await prefsBox.clear();

      expect(prefsBox.getUserName(), isNull);
      expect(prefsBox.getAccount(), isNull);
      expect(prefsBox.getIsLogin(), false);
    });
  });
}
