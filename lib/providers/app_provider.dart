import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int scoutingTabIndex;

  AppProvider({
    this.scoutingTabIndex = 0,
  });

  void setTabIndex(int value) {
    scoutingTabIndex = value;
    notifyListeners();
  }
}
