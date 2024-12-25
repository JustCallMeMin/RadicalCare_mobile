import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_notifier.g.dart';

@riverpod
class ApplicationNotifier extends _$ApplicationNotifier {
  bool _isBottomBarVisible = true;

  @override
  bool build() => _isBottomBarVisible;

  void hideBottomBar() {
    _isBottomBarVisible = false;
    state = _isBottomBarVisible;
  }

  void showBottomBar() {
    _isBottomBarVisible = true;
    state = _isBottomBarVisible;
  }

  void resetStateOnPop(bool result) {
    if (result) {
      _isBottomBarVisible = true;
      state = _isBottomBarVisible;
    }
  }
}

@riverpod
class CurrentIndexNotifier extends _$CurrentIndexNotifier {
  int _currentIndex = 0;

  @override
  int build() => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    state = _currentIndex;
  }

  void resetIndex() {
    _currentIndex = 0;
    state = _currentIndex;
  }
}
