import 'package:flutter_riverpod/flutter_riverpod.dart';

//created to control user's searchlist

class EmojiStateNotifier extends StateNotifier<bool> {
  EmojiStateNotifier() : super(false);

  void showEmojiTrue() {
    state = true;
  }

  void showEmojiFalse() {
    state = false;
  }

  void resetEmoji() {
    state = !state;
  }
}

final emojiStateProvider =
    StateNotifierProvider<EmojiStateNotifier, bool>((ref) {
  return EmojiStateNotifier();
});
