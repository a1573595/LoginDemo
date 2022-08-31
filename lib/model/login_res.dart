import 'package:json_annotation/json_annotation.dart';

part 'login_res.g.dart';

@JsonSerializable()
class LoginRes {
  LoginRes(this.isLoginSuccess, this.memberId, this.memberName);

  bool isLoginSuccess;
  String memberId;
  String memberName;

  factory LoginRes.fromJson(Map<String, dynamic> json) =>
      _$LoginResFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResToJson(this);
}
