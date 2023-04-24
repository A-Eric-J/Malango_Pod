import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';
import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'dart:io';

import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';

class PodcastDatabaseService {
  final MalangoDatabase malangoDb;

  PodcastDatabaseService({@required this.malangoDb});

  Stream<Episode> get episodeNotifier => malangoDb.episodeNotifier;

  /// Subscriptions

  Future<List<Podcast>> subscriptions() {
    return malangoDb.subscriptions();
  }

  Future<Podcast> subscribe(Podcast podcast) async {
    /// We may already have episodes downloaded or favorited in this podcast before
    var savedEpisodes = await malangoDb.findEpisodesByPodcastGuid(podcast.guId);

    if (podcast.episodes != null) {
      for (var episode in podcast.episodes) {
        episode = savedEpisodes?.firstWhere((ep) => ep.guId == episode.guId,
            orElse: () => episode);

        episode.podcastGuId = podcast.guId;
      }
    }

    return malangoDb.subscribePodcast(podcast);
  }

  Future<void> unsubscribe(Podcast podcast) async {
    if (await storagePermission()) {
      final filename = join(
          await getStorageDirectory(), fileRegExpChecker(podcast.podcastTitle));

      final directory = Directory.fromUri(Uri.file(filename));

      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }

    return malangoDb.unSubscribePodcast(podcast);
  }

  /// Downloads

  Future<List<Episode>> loadDownloads() async {
    return malangoDb.findDownloads();
  }

  Future<void> deleteDownload(Episode episode) async {
    /// Note that if this episode is currently downloading,cancel the download first.
    if (episode.episodeDownloadPercentageProgress < 100) {
      await FlutterDownloader.cancel(taskId: episode.episodeDownloadId);
    }

    episode.episodeDownloadId = null;
    episode.episodeDownloadPercentageProgress = 0;
    episode.episodePosition = 0;
    episode.episodeDownloadState = DownloadState.none;

    await malangoDb.deleteDownloadedEpisode(episode);

    /// even we delete its file
    if (await storagePermission()) {
      final file = File.fromUri(Uri.file(await getPath(episode)));

      if (await file.exists()) {
        return file.delete();
      }
    }

    return;
  }

  /// Favorites

  Future<List<Episode>> findFavorites() {
    return malangoDb.findFavorites();
  }

  Future<Episode> favoriteEpisode(Episode newEpisode) {
    return malangoDb.favoriteEpisode(newEpisode);
  }

  Future<int> unFavoriteEpisode(Episode newEpisode) {
    return malangoDb.unFavoriteEpisode(newEpisode);
  }
}
