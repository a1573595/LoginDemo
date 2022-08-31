import 'package:dio/dio.dart';
import 'package:login/model/login_req.dart';

import 'package:retrofit/retrofit.dart';

import '../model/login_res.dart';
import 'base_dio.dart';

part 'api_client.g.dart';

// @RestApi(baseUrl: "https://run.mocky.io/v3/")
// abstract class ApiClient {
//   factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;
//
//   // const factory ApiClient({Dio dio , String baseUrl}) = _ApiClient;
//
//   // const factory ApiClient({Dio dio = BaseDio().getDio(), String baseUrl}) = _ApiClient;
//
//   // factory ApiClient({Dio? dio, String? baseUrl}) {
//   //   dio ??= BaseDio().getDio();
//   //   return _ApiClient(dio, baseUrl: baseUrl);
//   // }
//
//   @POST("/2c9fcbc6-440b-425e-8b96-e470e42962cf")
//   Future<LoginRes> login(LoginReq req);
// }

@RestApi(baseUrl: "https://run.mocky.io/v3/")
abstract class ApiClient {
  // factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  factory ApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  @POST("/2c9fcbc6-440b-425e-8b96-e470e42962cf")
  Future<LoginRes> login(LoginReq req);
}