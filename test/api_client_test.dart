import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/api/api_client.dart';
import 'package:login/model/login_req.dart';
import 'package:login/model/login_res.dart';
import 'package:mock_web_server/mock_web_server.dart';

late MockWebServer _server;
late ApiClient _client;
final _headers = {"Content-Type": "application/json"};

void main() {
  /// 測試開始前執行
  setUp(() async {
    _server = MockWebServer();
    // _server.dispatcher = (HttpRequest request) async {
    //   var res = dispatcherMap[request.uri.path];
    //   if (res != null) {
    //     return res;
    //   }
    //   return new MockResponse()..httpCode = 404;
    // };
    await _server.start();

    _client = ApiClient(dio: Dio(),baseUrl: _server.url);
  });

  /// 測試結束後執行
  tearDown(() {
    _server.shutdown();
  });

  final loginRes = LoginRes(true, 'A001', 'Evan');
  final loginResJson = jsonEncode(loginRes);

  test("login request", () async {
    _server.enqueue(headers: _headers, body: loginResJson);
    final res = await _client.login(LoginReq('', ''));
    expect(res, isNotNull);
    expect(res.isLoginSuccess, loginRes.isLoginSuccess);
    expect(res.memberId, loginRes.memberId);
    expect(res.memberName, loginRes.memberName);
  });
}
