part of 'login_page.dart';

var _isPasswordVisible = StateProvider.autoDispose((ref) => false);

var _isAccountRemoveable = StateProvider.autoDispose((ref) {
  var account = sharedPrefs.getAccount();
  return account != null && account.isNotEmpty;
});
var _isPasswordRemoveable = StateProvider.autoDispose((ref) => false);

var _isAccountError = StateProvider.autoDispose((ref) => false);
var _isPasswordError = StateProvider.autoDispose((ref) => false);

class LoginViewModel extends StateNotifier<AsyncValue<LoginRes>> {
  LoginViewModel(this.ref) : super(const AsyncValue.loading());

  final Ref ref;

  final passwordRegex = RegExp(r'^[a-zA-Z0-9]+$');

  bool _checkAccount(String account) {
    return account.isEmpty;
  }

  bool _checkPassword(String password) {
    return password.isEmpty || !passwordRegex.hasMatch(password);
  }

  void login(String account, String password) async {
    logger.i('Event: Click login');
    var isAccountError = _checkAccount(account);
    var isPasswordError = _checkPassword(password);

    ref
        .read(_isAccountError.state)
        .state = isAccountError;
    ref
        .read(_isPasswordError.state)
        .state = isPasswordError;

    if (!isAccountError && !isPasswordError) {
      logger.i('Event: Login');
      try {
        state = const AsyncValue.loading();
        final data = await ref.read(loginRepository).login(account, password);
        state = AsyncValue.data(data);
      } catch (e) {
        state = AsyncValue.error(e);
      }
    }
  }

  @override
  bool updateShouldNotify(AsyncValue<LoginRes> old, AsyncValue<LoginRes> current) {
    return true;
  }
}

final _loginViewModel = StateNotifierProvider.autoDispose<LoginViewModel, AsyncValue<LoginRes>>((ref) =>
    LoginViewModel(ref));