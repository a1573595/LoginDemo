part of 'login_page.dart';

class LoginNotifier extends StateNotifier<AsyncValue<LoginRes>> {
  LoginNotifier(this.ref) : super(const AsyncValue.loading());

  final Ref ref;

  void login() async {
    logger.i('Event: Login');
    var account = ref.read(_account.state).state;
    var password = ref.read(_password.state).state;

    try {
      state = const AsyncValue.loading();
      final data = await ref.read(loginRepository).login(account!, password!);
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  /// 是否更新狀態
  @override
  bool updateShouldNotify(
      AsyncValue<LoginRes> old, AsyncValue<LoginRes> current) {
    return super.updateShouldNotify(old, current);
  }
}

final _loginRes =
    StateNotifierProvider.autoDispose<LoginNotifier, AsyncValue<LoginRes>>(
        (ref) => LoginNotifier(ref));

var _account = StateProvider.autoDispose<String?>((ref) => null);
var _password = StateProvider.autoDispose<String?>((ref) => null);

var _isAccountError = Provider.autoDispose((ref) {
  var account = ref.watch(_account);
  return account != null && account.isEmpty;
});
var _isPasswordError = Provider.autoDispose((ref) {
  var password = ref.watch(_password);
  return password != null && password.isEmpty;
});

var _isPasswordVisible = StateProvider.autoDispose((ref) => false);

var _isAccountRemoveable = StateProvider.autoDispose((ref) {
  var account = sharedPrefs.getAccount();
  return account != null && account.isNotEmpty;
});
var _isPasswordRemoveable = StateProvider.autoDispose((ref) => false);

var _gotoNext = Provider.autoDispose<String>((ref) {
  var account = ref.watch(_account);
  var password = ref.watch(_password);
  var isAccountError = ref.watch(_isAccountError);
  var isPasswordError = ref.watch(_isPasswordError);

  if (account != null &&
      password != null &&
      !isAccountError &&
      !isPasswordError) {
    return account;
  } else {
    return '';
  }
});

// class LoginViewModel {
//   final UserRepository repository = UserRepository();
//
//   final passwordRegex = RegExp(r'^[a-zA-Z0-9]+$');
//
//   bool _checkAccount(String account) {
//     return account.isNotEmpty;
//   }
//
//   bool _checkPassword(String password) {
//     return password.isNotEmpty && passwordRegex.hasMatch(password);
//   }
//
//   Future<bool> login(String account, String password) {
//     if (_checkAccount(account)) {
//       return Future.value(false);
//     } else if (_checkPassword(password)) {
//       return Future.value(false);
//     } else {
//       return repository.login(account, password);
//     }
//   }
// }
