import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:login/api/api_client.dart';
import 'package:login/api/base_dio.dart';
import 'package:login/model/login_req.dart';
import 'package:login/model/login_res.dart';
import 'package:mock_web_server/mock_web_server.dart';

late MockWebServer _server;
late ApiClient _client;
final _headers = {"Content-Type": "application/json"};
// final dispatcherMap = <String, MockResponse>{};

void main() {
  setUp(() async {
    _server = MockWebServer();
    // // _server.dispatcher = (HttpRequest request) async {
    // //   var res = dispatcherMap[request.uri.path];
    // //   if (res != null) {
    // //     return res;
    // //   }
    // //   return new MockResponse()..httpCode = 404;
    // // };
    await _server.start();
    // final dio = BaseDio().getDio();
    // dio.interceptors.add(LogInterceptor(responseBody: true));
    // dio.interceptors.add(DateTimeInterceptor());
    _client = ApiClient();
  });

  tearDown(() {
    _server.shutdown();
  });

  final loginRes = LoginRes(true, 'A001', 'Evan');
  final loginResJson = jsonEncode(loginRes);

  test("test login", () async {
    _server.enqueue(headers: _headers, body: loginResJson);
    final res = await _client.login(LoginReq('', ''));
    expect(res, isNotNull);
    expect(res.isLoginSuccess, loginRes.isLoginSuccess);
    expect(res.memberId, loginRes.memberId);
    expect(res.memberName, loginRes.memberName);
  });
}
