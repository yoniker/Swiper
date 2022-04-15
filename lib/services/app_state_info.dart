import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
//This class does two things:
//1. Trace and notify on changes if the app state (resumed,background etc) changes
//2. Trace the bottom navigator state.
//This is done because pushing two named paths doesn't work at getx (see https://github.com/jonataslaw/getx/issues/2130)
//And the alternative (navigator 2.0) is too complicated to my taste (see https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade)

class AppStateInfo extends ChangeNotifier with WidgetsBindingObserver {
  AppLifecycleState _appState = AppLifecycleState.resumed;
  AppLifecycleState get appState => _appState;
  int latestTabOnMainNavigation = MainNavigationScreen
      .VOILA_PAGE_INDEX; //Yes this is ugly, see comment #2 above

  AppStateInfo._privateConstructor() {
    WidgetsBinding.instance!.addObserver(this);
  }

  static final AppStateInfo instance = AppStateInfo._privateConstructor();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appState = state;
    notifyListeners();
  }
}
