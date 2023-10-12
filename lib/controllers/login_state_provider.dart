import 'package:flutter_riverpod/flutter_riverpod.dart';

//created to control user's searchlist

class LoginStateNotifier extends StateNotifier<bool> {
  LoginStateNotifier() : super(false);

  void isLoginTrue() {
    state = true;
  }

  void isLoginFalse() {
    state = false;
  }

  void onLogin() {
    state = !state;
  }
}

final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, bool>((ref) {
  return LoginStateNotifier();
});
