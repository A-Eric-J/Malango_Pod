import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/services/download/download_manager.dart';
import 'package:malango_pod/models/download_progressing_model.dart';
import 'package:flutter/foundation.dart';
import 'package:mp3_info/mp3_info.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';
import 'package:rxdart/rxdart.dart';

class DownloadService {
  final MalangoDatabase malangoDb;
  final DownloadManager downloadManager;

  static BehaviorSubject<DownloadProgressingModel> downloadProgress =
      BehaviorSubject<DownloadProgressingModel>();

  DownloadService({@required this.malangoDb, @required this.downloadManager}) {
    downloadManager.downloadProgress.pipe(downloadProgress);
    downloadProgress.listen((progress) async {
      var episode = await malangoDb.findEpisodeByDownloadId(progress.id);

      if (episode != null) {
        if (episode.episodeDownloadPercentageProgress !=
                progress.progressPercentage ||
            episode.episodeDownloadState != progress.downloadState) {
          episode.episodeDownloadPercentageProgress =
              progress.progressPercentage;
          episode.episodeDownloadState = progress.downloadState;

          if (progress.progressPercentage == 100) {
            if (await storagePermission()) {
              final filename = await getPath(episode);

              /// if the episode does not have duration we can create for it by MP3Processor
              if (episode.episodeDuration == 0) {
                var mp3Info = MP3Processor.fromFile(File(filename));

                episode.episodeDuration = mp3Info.duration.inSeconds;
              }
            }
          }

          await malangoDb.saveEpisode(episode);
        }
      }
    });
  }

  Future<Episode> findEpisodeByDownloadId(String downloadId) {
    return malangoDb.findEpisodeByDownloadId(downloadId);
  }

  Future<bool> downloadEpisode(Episode episode) async {
    final podcastSeason =
        episode.podcastSeason > 0 ? episode.podcastSeason.toString() : '';
    final seasonEpisodeNumber = episode.seasonEpisodeNumber > 0
        ? episode.seasonEpisodeNumber.toString()
        : '';

    /// for downloading or tasks that has interaction with storage
    /// we must have permission
    if (await storagePermission()) {
      final savedEpisode = await malangoDb.findEpisodeByGuid(episode.guId);

      if (savedEpisode != null) {
        episode = savedEpisode;
      }

      final episodeDownloadPath =
          await getDirectory(episode: episode, isFull: true);
      final episodePath = await getDirectory(episode: episode);
      var episodeLink = Uri.parse(episode.episodeLink);

      /// we wanna be sure that the download directory exists
      await makingDownloadDirectory(episode);

      /// FileName should be last segment of URI.
      var fileName = fileRegExpChecker(episodeLink.pathSegments.lastWhere(
          (e) => e.toLowerCase().endsWith('.mp3'),
          orElse: () => null));

      fileName ??= fileRegExpChecker(episodeLink.pathSegments.lastWhere(
          (e) => e.toLowerCase().endsWith('.m4a'),
          orElse: () => null));

      if (fileName != null) {
        /// The last segment could also be a full URL.
        if (fileName.contains('/')) {
          try {
            episodeLink = Uri.parse(fileName);
            fileName = episodeLink.pathSegments.last;
          } on FormatException {
            log('It wasn\'t a URL...');
          }
        }

        /// In certain podcasts, identical file names are used for every episode.
        /// However, if we have a season and/or episode number given by iTunes,
        /// we can make use of that information.
        /// Additionally, if the publication date is available, we will add it to the file name.
        var episodePublicationDate = '';

        if (episode.episodePublicationDate != null) {
          episodePublicationDate =
              '${episode.episodePublicationDate.millisecondsSinceEpoch ~/ 1000}-';
        }

        fileName =
            '$podcastSeason$seasonEpisodeNumber$episodePublicationDate$fileName';

        log('Downloading episode (${episode?.episodeTitle}) $fileName to $episodeDownloadPath/$fileName');

        final taskId = await FlutterDownloader.enqueue(
          url: episode.episodeLink,
          savedDir: episodeDownloadPath,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: false,
          headers: {userAgent: ''},
        );

        /// Updating the episode with the data of download
        episode.episodeDownloadId = taskId;
        episode.episodeFileName = fileName;
        episode.episodeFilePath = episodePath;
        episode.episodeDownloadState = DownloadState.downloading;
        episode.episodeDownloadPercentageProgress = 0;

        await malangoDb.saveEpisode(episode);

        return Future.value(true);
      } else {
        log('The file is unsupported format!');
      }
    }

    return Future.value(false);
  }

  void dispose() {
    downloadManager.dispose();
  }
}
