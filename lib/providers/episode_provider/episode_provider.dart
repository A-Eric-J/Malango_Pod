import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/services/podcast/podcast_database_service.dart';

/// [EpisodeProvider] is a provider for episode's behaviour like downloading and etc
class EpisodeProvider extends ChangeNotifier {
  final PodcastDatabaseService podcastDatabaseService;
  /// downloaded episodes that will be shown in Downloads part of Archives
  List<Episode> _downloads;

  EpisodeProvider({
    @required this.podcastDatabaseService,
  }) {
    episodeProviderInitialization();
  }

  void episodeProviderInitialization() async {
    await loadDownloads();
    episodeNotifierListener();
  }


  /// this listener is for when the episode is downloading
  /// and changes are happening in database and notify to
  /// [EpisodeProvider] to update the UI
  void episodeNotifierListener() {
    podcastDatabaseService.episodeNotifier.listen((episode) {
      log('episode: ${episode.episodeDownloadPercentageProgress} ${episode.isEpisodeDownloaded}');
      /// this means that when the download of episode completed loadDownloads
      /// to make the download ui update
      //TODO in the next update of this app we can show the download progress even in Download page in Archives to have a great Ui
      if(episode != null && episode.episodeDownloadPercentageProgress == 100 && episode.isEpisodeDownloaded){
        loadDownloads();
      }
    });
  }

  Future<void> loadDownloads() async {
    _downloads = await podcastDatabaseService.loadDownloads();
    notifyListeners();
  }

  void addDownload(Episode newDownload){
    _downloads.add(newDownload);
    notifyListeners();
  }

  List<Episode> get downloads => _downloads;


  void deleteDownload(Episode deletedEpisode) async {
    await podcastDatabaseService.deleteDownload(deletedEpisode);
    loadDownloads();
    notifyListeners();
  }

}
