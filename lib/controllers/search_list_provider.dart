import 'package:flutter_riverpod/flutter_riverpod.dart';

//created to control user's searchlist

class SearchListNotifier extends StateNotifier<bool> {
  SearchListNotifier() : super(false);

  void isSearchingTrue() {
    state = true;
  }

  void isSearchingFalse() {
    state = false;
  }

  void onSearch() {
    state = !state;
  }
}

final searchListProvider =
    StateNotifierProvider<SearchListNotifier, bool>((ref) {
  return SearchListNotifier();
});
