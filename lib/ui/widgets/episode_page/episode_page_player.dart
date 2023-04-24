import 'package:flutter/material.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/enums/sound_state.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/enums/player_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/button/button.dart';

import 'package:provider/provider.dart';

/// You should start to play an episode from [EpisodePagePlayer] in EpisodePage
class EpisodePagePlayer extends StatelessWidget {
  final Episode episode;

  const EpisodePagePlayer({
    Key key,
    @required this.episode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, soundProvider, child) {
      if (soundProvider.playingState != null &&
          soundProvider.nowPlaying != null) {
        final soundState = soundProvider.playingState;
        final nowPlaying = soundProvider.nowPlaying;

        if (episode.episodeDownloadState == DownloadState.downloading) {
          /// in this state the episode is downloading and the play button
          /// will be disable until the download ends
          return const Opacity(
            opacity: 0.15,
            child: EpisodePagePlayerButton(
              text: downloadingText,
            ),
          );
        }

        /// in this state we are not downloading the episode and
        /// it is ready to play
        else {
          /// if the episode is the episode that we are playing we just handle
          /// the playing states
          if (nowPlaying.guId == episode.guId) {
            if (soundState == SoundState.playing) {
              return InkWell(
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () =>
                    soundProvider.setPlayerPlayingState(PlayerState.pause),
                child: const EpisodePagePlayerButton(
                  text: pauseText,
                ),
              );
            } else if (soundState == SoundState.waiting) {
              return const EpisodePagePlayerButton(
                text: waitingText,
              );
            } else if (soundState == SoundState.pausing) {
              return InkWell(
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () =>
                    soundProvider.setPlayerPlayingState(PlayerState.play),
                child: const EpisodePagePlayerButton(
                  text: playText,
                ),
              );
            } else {
              return InkWell(
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () => soundProvider.setPlayEpisode(episode),
                child: const EpisodePagePlayerButton(
                  text: playText,
                ),
              );
            }
          } else {
            /// If it is not the episode that we are playing, we can just start to play
            return InkWell(
              splashColor: transparent,
              highlightColor: transparent,
              onTap: () => soundProvider.setPlayEpisode(episode),
              child: const EpisodePagePlayerButton(
                text: playText,
              ),
            );
          }
        }
      } else {
        /// this means that we have not gotten the episode response yet
        /// and we can press Play button until the response comes and after that
        /// it plays the episode
        if (episode.episodeDownloadState != DownloadState.downloading) {
          return InkWell(
            splashColor: transparent,
            highlightColor: transparent,
            onTap: () => soundProvider.setPlayEpisode(episode),
            child: const EpisodePagePlayerButton(
              text: playText,
            ),
          );
        } else {
          return const Opacity(
            opacity: 0.15,
            child: EpisodePagePlayerButton(
              text: playText,
            ),
          );
        }
      }
    });
  }
}
