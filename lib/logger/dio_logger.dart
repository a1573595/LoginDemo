import 'package:dio/dio.dart';

import 'logger.dart';

class DioLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

    var buffer = StringBuffer();
    buffer.writeln('Request ${options.method}');

    if (options.method != 'GET') {
      buffer.writeln('${options.uri}');
    } else {
      buffer.write('${options.uri}');
    }

    if (options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) {
          buffer.write('Maps: ${data.toString()}');
        } else if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          buffer.write('Form data: ${formDataMap.toString()}');
        } else {
          buffer.write(data.toString());
        }
      }
    }

    logger.i(buffer.toString());
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);

    var buffer = StringBuffer();
    buffer.writeln(
        'Respond ${response.requestOptions.method} ${response.statusCode}:${response.statusMessage}');
    buffer.writeln('${response.requestOptions.uri}');
    buffer.write('Body: ${response.data.toString()}');

    logger.i(buffer.toString());
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    var buffer = StringBuffer();
    if (err.type == DioErrorType.response) {
      buffer.writeln(
          'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}');
      if (err.response != null && err.response?.data != null) {
        buffer.write('${err.response?.data.toString()}');
      }
    } else {
      buffer.write('DioError ║ ${err.type} ${err.message}');
    }

    logger.i(buffer.toString(), err, err.stackTrace);
  }
}
