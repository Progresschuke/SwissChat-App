//created to control user model

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api.dart';
import '../models/chat_user.dart';

class UserModelNotifier extends StateNotifier<ChatUser> {
  UserModelNotifier() : super(APIs.me);

  void getUserModel(ChatUser userModel) {
    state = userModel;
  }
}

final userModelProvider =
    StateNotifierProvider<UserModelNotifier, ChatUser>((ref) {
  return UserModelNotifier();
});

class ChatUserModelNotifier extends StateNotifier<ChatUser> {
  ChatUserModelNotifier() : super(APIs.me);

  void getChatUserModel(ChatUser userModel) {
    state = userModel;
  }
}

final chatUserModelProvider =
    StateNotifierProvider<ChatUserModelNotifier, ChatUser>((ref) {
  return ChatUserModelNotifier();
});
