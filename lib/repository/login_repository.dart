import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/model/login_req.dart';

import '../api/api_client.dart';
import '../model/login_res.dart';
import '../tool/shared_prefs.dart';

final loginRepository = Provider((ref) => LoginRepository(ref));

class LoginRepository {
  LoginRepository(this.ref);

  final Ref ref;

  Future<LoginRes> login(String account, String password) async {
    LoginRes res = await ApiClient().login(LoginReq(account, password));

    if (res.isLoginSuccess) {
      await sharedPrefs.setAccount(account);
      await sharedPrefs.setUserName(res.memberName);
      await sharedPrefs.setIsLogin(true);
    }

    return res;
  }

  Future<List<bool>> logout() async {
    /// 整合多個Future事件
    return await Future.wait([
      sharedPrefs.setUserName(''),
      sharedPrefs.setIsLogin(false),
    ]);
  }
}
