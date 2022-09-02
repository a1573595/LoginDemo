import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/api/api_client.dart';
import 'package:login/model/login_res.dart';
import 'package:login/repository/login_repository.dart';
import 'package:login/utils/shared_prefs.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockWebServer server;
  late ApiClient client;
  late LoginRepository repository;
  final headers = {"Content-Type": "application/json"};

  /// 每個測試開始前執行
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sharedPrefs.init();

    server = MockWebServer();
    // _server.dispatcher = (HttpRequest request) async {
    //   var res = dispatcherMap[request.uri.path];
    //   if (res != null) {
    //     return res;
    //   }
    //   return new MockResponse()..httpCode = 404;
    // };
    await server.start();

    client = ApiClient(dio: Dio(), baseUrl: server.url);
    repository = LoginRepository(apiClient: client);
  });

  /// 每個測試結束後執行
  tearDown(() {
    server.shutdown();
  });

  test("login success", () async {
    var account = 'Chien@gmail.com';
    var password = 'abc12345';
    final loginRes = LoginRes(true, 'A001', 'Evan');

    server.enqueue(headers: headers, body: jsonEncode(loginRes));
    final res = await repository.login(account, password);

    expect(sharedPrefs.getIsLogin(), res.isLoginSuccess);
    expect(sharedPrefs.getAccount(), account);
    expect(sharedPrefs.getUserName(), res.memberName);
  });

  test("login failed", () async {
    var account = 'Chien@gmail.com';
    var password = 'abc12345';
    final loginRes = LoginRes(false, 'A001', 'Evan');

    server.enqueue(headers: headers, body: jsonEncode(loginRes));
    final res = await repository.login(account, password);

    expect(sharedPrefs.getIsLogin(), null);
    expect(sharedPrefs.getAccount(), null);
    expect(sharedPrefs.getUserName(), null);
  });

  test("logout request", () async {
    var account = 'Chien@gmail.com';

    expect(sharedPrefs.getIsLogin(), null);
    await sharedPrefs.setIsLogin(true);
    await sharedPrefs.setAccount(account);
    await sharedPrefs.setUserName('Chien');

    await repository.logout();

    expect(sharedPrefs.getIsLogin(), false);
    expect(sharedPrefs.getAccount(), account);
    expect(sharedPrefs.getUserName(), '');
  });
}
