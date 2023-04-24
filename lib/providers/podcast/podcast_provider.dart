import 'dart:developer';

import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/enums/podcast_behaviour.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/services/download/download_service.dart';
import 'package:malango_pod/services/download/download_manager.dart';
import 'package:malango_pod/services/podcast/podcast_database_service.dart';
import 'package:flutter/material.dart';

/// [PodcastProvider] is a provider for a podcast for giving its episodes and detail and another
/// information and subscribing and etc
class PodcastProvider extends ChangeNotifier {
  final PodcastDatabaseService podcastDatabaseService;
  DownloadService downloadService;

  /// in PodcastDetailScreen we have 2 parts, one is episode page
  /// and another one is podcast information page. with [_isEpisodePage]
  /// we change the page for updating  UI
  bool _isEpisodePage = true;

  /// this ViewState is for requesting for getting episodes
  /// and another information from podcast feed
  ViewState _podcastFeedViewState = ViewState.preparing;

  /// subscribed podcasts list
  List<Podcast> _subscriptions;

  /// list of the podcast episodes or favorited episodes
  var _episodes = <Episode>[];

  /// when we go to PodcastDetailScreen for entry we have an object of podcast
  /// that its episodes and another needed information are not fetched yet
  /// and we sent request to fetch episodes and another information from feed
  /// and [_podcast] is the podcast that we have fetched from feed
  Podcast _podcast;

  PodcastProvider({
    @required this.podcastDatabaseService,
  }) {
    downloadService = DownloadService(
      malangoDb: MalangoDatabase.db,
      downloadManager: DownloadManager(),
    );
    podcastProviderInitialization();
  }

  void podcastProviderInitialization() {
    loadSubscriptions();
    downloadNotifierListener();
    loadFavorites();
    episodeNotifierListener();
  }

  List<Podcast> get subscriptions => _subscriptions;

  void loadSubscriptions() async {
    _subscriptions = await podcastDatabaseService.subscriptions();
    notifyListeners();
  }

  void loadFavorites() async {
    _episodes = await podcastDatabaseService.findFavorites();
    notifyListeners();
  }

   /// As you know every podcasts have some episodes when we are downloading
  /// an episode of a podcast at each progress of downloading the downloading episode
  /// is changing its data like progress of download and download state and we should update
  /// that episode of podcast and this changing comes from database when some changing happens
  void episodeNotifierListener() {
    podcastDatabaseService.episodeNotifier.listen((episode) {
      var episodeIndex = _episodes.indexWhere((episodeItem) =>
          episodeItem.guId == episode.guId && episodeItem.podcastGuId == episode.podcastGuId);

      if (!episodeIndex.isNegative) {
        _episodes[episodeIndex] = episode;
        notifyListeners();
      }
    });
  }

 /// this listener is for listening to downloadProgress of DownloadService and
  /// we check that if the episode that is downloading the episode that is in front of us
  /// then we update that episode by calling notifyListeners
  void downloadNotifierListener() {
    /// Listening to download progress from DownloadService
    DownloadService.downloadProgress.listen((downloadProgress) {
      downloadService
          .findEpisodeByDownloadId(downloadProgress.id)
          .then((downloadableEpisode) {
        if (downloadableEpisode != null) {
          var episode = _episodes.firstWhere(
              (e) => e.episodeDownloadId == downloadProgress.id,
              orElse: () => null);

          /// this condition means that we are in episode page and this episode
          /// is the episode that is downloading and we should update the ui but if it is not
          /// no need to call notifyListeners
          if (episode != null) {
            notifyListeners();
          }
        } else {
          log('Downloadable not found with id ${downloadProgress.id}');
        }
      });
    });
  }

  bool get isEpisodePage => _isEpisodePage;

  void changePage(bool pageState) {
    _isEpisodePage = pageState;
    notifyListeners();
  }

  ViewState get podcastFeedViewState => _podcastFeedViewState;

  void setPodcastFeedViewState(ViewState state) {
    _podcastFeedViewState = state;
    notifyListeners();
  }

  List<Episode> get episodes => _episodes;

  void setEpisodes(List<Episode> newEpisodes) {
    _episodes = newEpisodes;
    notifyListeners();
  }

  void episodeClear() {
    _episodes.clear();
    notifyListeners();
  }

  Podcast get podcast => _podcast;

  void setPodcast(Podcast newPodcast) {
    _podcast = newPodcast;
    notifyListeners();
  }

  /// podcasts have just 3 behaviours: if it is subscribe or unsubscribe it means that
  /// we are going to subscribe that podcast or unsubscribe it. and the last one is
  /// loadSubscriptions for loading subscription list for updating ui or another reasons
  Future<void> setPodcastBehaviour(PodcastBehaviour podcastBehaviour) async {
    switch (podcastBehaviour) {
      case PodcastBehaviour.subscribe:
        _podcast = await podcastDatabaseService.subscribe(_podcast);
        loadSubscriptions();
        break;
      case PodcastBehaviour.unsubscribe:
        await podcastDatabaseService.unsubscribe(_podcast);
        _podcast.podcastSubscribed = false;
        loadSubscriptions();
        break;
      case PodcastBehaviour.loadSubscriptions:
        loadSubscriptions();
        break;
    }
    notifyListeners();
  }

  void setDownloadingEpisode(Episode newDownloadingEpisode) async {
    log('${newDownloadingEpisode.episodeTitle} is going to being downloaded');

    /// To prevent a pause between the user tapping the download icon and
    /// the UI showing some sort of progress, set it to queued now.

    var episode = _episodes.firstWhere(
        (loadedEpisode) => loadedEpisode.guId == newDownloadingEpisode.guId,
        orElse: () => null);

    /// NOTE for your knowledge: episode is essentially an alias for that object.
    /// This means that any changes made to episode will also be reflected in the corresponding
    /// _episodes list element (i.e., the element at the same index as episode).
    /// This is because both episode and _episodes[index] are referring to the same object in memory.
    /// In other words, episode is not a copy of the object in _episodes[index],
    /// but rather a reference to the same object.
    /// Therefore, any changes made to the object through either episode or _episodes[index]
    /// will be visible through both variables.


    /// according to the note at top when episode.episodeDownloadStat is changed to queue it means
    /// that _episodes[index] will be changed to queue too
    episode.episodeDownloadState = DownloadState.queued;

    notifyListeners();

    var result = await downloadService.downloadEpisode(newDownloadingEpisode);


    /// If there was an error downloading the episode, push an error state
    /// and then restore to none.
    if (!result) {
      episode.episodeDownloadState = DownloadState.failed;
      episode.episodeDownloadState = DownloadState.none;
    }

    notifyListeners();
  }

  void setFavoriteOrUnFavoriteEpisode(Episode newEpisode) {
    if (newEpisode.episodeFavorited) {
      podcastDatabaseService.favoriteEpisode(newEpisode);
    } else {
      podcastDatabaseService.unFavoriteEpisode(newEpisode);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    DownloadService.downloadProgress.close();
    downloadService.dispose();
    super.dispose();
  }
}
