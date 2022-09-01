import 'package:dio/dio.dart';

import '../logger/dio_logger.dart';
import 'base_error.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}

class BaseDio {
  //BaseDio._(); // 私有建構函示

  static final BaseDio _instance = BaseDio._internal();

  factory BaseDio() {
    return _instance;
  }

  BaseDio._internal();

  Dio getDio() {
    final Dio dio = Dio();
    dio.options = BaseOptions(receiveTimeout: 15000, connectTimeout: 15000);
    dio.interceptors.add(DioLogger());

    return dio;
  }

  BaseError getDioError(Object obj) {
    // 封裝BaseError類，依據code返回不同錯誤
    switch (obj.runtimeType) {
      case DioError:
        if ((obj as DioError).type == DioErrorType.response) {
          final response = obj.response;

          if (response?.statusCode == 401) {
            return NeedLogin();
          } else if (response?.statusCode == 403) {
            return NeedAuth();
          } else if (response?.statusCode == 408) {
            return UserNotExist();
          } else if (response?.statusCode == 409) {
            return PwdNotMatch();
          } else if (response?.statusCode == 405) {
            return UserNameEmpty();
          } else if (response?.statusCode == 406) {
            return PwdEmpty();
          } else {
            return OtherError(
              statusCode: response?.statusCode ?? -1,
              statusMessage: response?.statusMessage ?? 'Unknown',
            );
          }
        }
    }

    return OtherError(statusCode: -1, statusMessage: 'null');
  }
}
