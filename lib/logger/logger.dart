import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final logger = _Logger();

class _Logger {
  static late Logger _logger;

  init({Logger? logger}) async {
    /// for test
    if (logger != null) {
      _logger = logger;
      return;
    }

    /// log檔輸出位置
    Directory? directory;

    /// Web不支援_operatingSystem會跳出提示
    try {
      /// Android需要註冊WRITE_EXTERNAL_STORAGE才能寫入
      /// iOS需要註冊LSSupportsOpeningDocumentsInPlace、UIFileSharingEnabled才能共享
      directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    } catch (_) {}

    /// 配置輸出在File與Console
    _logger = Logger(
        printer: PrettyPrinter(
          printTime: true,
        ),
        output: MultiOutput([
          /// web不支援path_provider沒有輸出檔案
          if (directory != null)
            FileOutput(
              file: File('${directory.path}/log.txt'),
              overrideExisting: true,
            ),
          ConsoleOutput()
        ]));

    /// 將未處理Exception轉到logger紀錄
    FlutterError.onError = (FlutterErrorDetails details) {
      _logger.e('Unhandled exception:', error: details.exception, stackTrace: details.stack);
    };
  }

  d(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  i(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  w(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
