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

    // try {
    //   BaseModel data = await ApiClient().login(LoginReq(id: account, password: password)); // 使用非常简单一句代码即可
    //   if (data.message == 'success') {
    //     updatePostById(postId, index);
    //   }
    // } catch (e) {
    //   state = state.copyWith(
    //       pageState: PageState.errorState,
    //       error: BaseDio.getInstance().getDioError(e));
    // }
  }
}
