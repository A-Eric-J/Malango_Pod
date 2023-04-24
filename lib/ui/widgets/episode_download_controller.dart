import 'package:flutter/material.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/enums/sound_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/providers/episode_provider/episode_provider.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/ui/widgets/button/button.dart';
import 'package:provider/provider.dart';

class EpisodeDownloadController extends StatelessWidget {
  final Episode episode;
  final bool isFromArchive;

  const EpisodeDownloadController({
    Key key,
    @required this.episode,
    this.isFromArchive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<PlayerProvider, PodcastProvider, EpisodeProvider>(builder:
        (context, soundProvider, podcastProvider, episodeProvider, child) {
      /// it means that an episode is playing and we want to download this episode
      /// or another episode
      if (soundProvider.playingState != null &&
          soundProvider.nowPlaying != null) {
        final nowPlaying = soundProvider.nowPlaying;

        /// it means the episode that is playing or is waiting for play is this episode
        /// and we can not download it. because of this we show an opacity with the download
        /// to show that it is disabled
        if (!(soundProvider.playingState == SoundState.none ||
                soundProvider.playingState == SoundState.stopped ||
                soundProvider.playingState == SoundState.error) &&
            nowPlaying?.guId == episode.guId) {
          return Opacity(
            opacity: 0.1,
            child: DownloadButton(
              downloadState: episode.episodeDownloadState,
              isFromArchive: isFromArchive,
              episodeProvider: episodeProvider,
              episode: episode,
              onTapEnable: false,
            ),
          );
        }
      }
      return DownloadButton(
        downloadState: episode.episodeDownloadState,
        isFromArchive: isFromArchive,
        episodeProvider: episodeProvider,
        episode: episode,
        onTap: episode.episodeDownloadState == DownloadState.none ||
                episode.episodeDownloadState == DownloadState.canceled ||
                episode.episodeDownloadState == DownloadState.failed
            ? () => podcastProvider.setDownloadingEpisode(episode)
            : null,
      );
    });
  }
}
