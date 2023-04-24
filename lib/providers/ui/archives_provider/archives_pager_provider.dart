import 'package:flutter/material.dart';

/// [ArchivePagerProvider] is a provider for changing screens(Subscribes,Downloads,Favorites)
/// and updating UI
class ArchivePagerProvider extends ChangeNotifier {
  /// SubscribesScreen => 0
  /// DownloadsScreen => 1
  /// FavoritesScreen => 2

  ///  [_archivePage] = 0 means that the default screen is SubscribesScreen
  int _archivePage = 0;

  int get archivePage => _archivePage;

  void changeArchivePage(int newPage) {
    _archivePage = newPage;
    notifyListeners();
  }
}
