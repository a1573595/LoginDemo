import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/api/api_client.dart';
import 'package:login/model/login_req.dart';
import 'package:login/model/login_res.dart';
import 'package:login/utils/prefs_box.dart';

final loginRepository = Provider((ref) => LoginRepository());

class LoginRepository {
  LoginRepository({ApiClient? apiClient}) {
    this.apiClient = apiClient ?? ApiClient();
  }

  late ApiClient apiClient;

  Future<LoginRes> login(String account, String password) async {
    LoginRes res = await apiClient.login(LoginReq(account, password));

    if (res.isLoginSuccess) {
      // await sharedPrefs.setAccount(account);
      // await sharedPrefs.setUserName(res.memberName);
      // await sharedPrefs.setIsLogin(true);

      await prefsBox.setAccount(account);
      await prefsBox.setUserName(res.memberName);
      await prefsBox.setIsLogin(true);
    }

    return res;
  }

  Future<List<void>> logout() async {
    /// 整合多個Future事件
    return await Future.wait([
      // sharedPrefs.setUserName(''),
      // sharedPrefs.setIsLogin(false),

      prefsBox.setUserName(null),
      prefsBox.setIsLogin(false),
    ]);
  }
}
