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
  String get message => "請先登入";
}

class NeedAuth implements BaseError {
  @override
  int get code => 403;

  @override
  String get message => "非法存取，請使用正確的Token";
}

class UserNotExist implements BaseError {
  @override
  int get code => 408;

  @override
  String get message => "用戶不存在";
}

class UserNameEmpty implements BaseError {
  @override
  int get code => 405;

  @override
  String get message => "用戶名稱不可為空";
}

class PwdNotMatch implements BaseError {
  @override
  int get code => 409;

  @override
  String get message => "用戶密碼不正確";
}

class PwdEmpty implements BaseError {
  @override
  int get code => 406;

  @override
  String get message => "用戶密碼不可為空";
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
