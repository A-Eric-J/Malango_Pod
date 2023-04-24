import 'package:flutter/material.dart';

/// [BottomNavigationProvider] is a provider for changing MainView screens(Home,Archives)
/// and updating UI
class BottomNavigationProvider extends ChangeNotifier {
  /// HomeScreen => 0
  /// ArchivesScreen => 1

  ///  [_bottomNavigationPage] = 0 means that the default screen is HomeScreen
  int _bottomNavigationPage = 0;

  int get bottomNavigationPage => _bottomNavigationPage;

  void changeBottomNavigationPage(int newPage){
    _bottomNavigationPage = newPage;
    notifyListeners();
  }

}
