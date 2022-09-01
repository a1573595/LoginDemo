import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/model/login_req.dart';

import '../api/api_client.dart';
import '../model/login_res.dart';

final loginRepository = Provider((ref) => LoginRepository(ref));

class LoginRepository {
  LoginRepository(this.ref);

  final Ref ref;

  Future<LoginRes> login(String account, String password) async {
    LoginRes res =
        await ApiClient().login(LoginReq(account, password));
    return res;
  }
}
