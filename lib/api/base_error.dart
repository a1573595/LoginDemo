import '../generated/l10n.dart';

/// 自定義的Error
abstract class BaseError {
  final int code;
  final String message;

  BaseError({required this.code, required this.message});
}

class NeedLogin implements BaseError {
  @override
  int get code => 401;

  @override
  String get message => S.current.http_error_401;
}

class NeedAuth implements BaseError {
  @override
  int get code => 403;

  @override
  String get message => S.current.http_error_403;
}

class UserNameEmpty implements BaseError {
  @override
  int get code => 405;

  @override
  String get message => S.current.http_error_405;
}

class PwdEmpty implements BaseError {
  @override
  int get code => 406;

  @override
  String get message => S.current.http_error_406;
}

class UserNotExist implements BaseError {
  @override
  int get code => 408;

  @override
  String get message => S.current.http_error_408;
}

class PwdNotMatch implements BaseError {
  @override
  int get code => 409;

  @override
  String get message => S.current.http_error_409;
}

class OtherError implements BaseError {
  final int statusCode;
  final String statusMessage;

  OtherError({required this.statusCode, required this.statusMessage});

  @override
  int get code => statusCode;

  @override
  String get message => statusMessage;
}
