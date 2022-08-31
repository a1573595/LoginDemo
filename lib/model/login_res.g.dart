// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRes _$LoginResFromJson(Map<String, dynamic> json) => LoginRes(
      json['isLoginSuccess'] as bool,
      json['memberId'] as String,
      json['memberName'] as String,
    );

Map<String, dynamic> _$LoginResToJson(LoginRes instance) => <String, dynamic>{
      'isLoginSuccess': instance.isLoginSuccess,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
    };
