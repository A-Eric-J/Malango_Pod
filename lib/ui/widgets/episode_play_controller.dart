import 'package:malango_pod/enums/sound_state.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/enums/player_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:flutter/material.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/button/button.dart';
import 'package:provider/provider.dart';

class EpisodePlayController extends StatelessWidget {
  final Episode episode;
  final bool isFromNowPlaying;

  const EpisodePlayController({
    Key key,
    @required this.episode,
    this.isFromNowPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, soundProvider, child) {
      if (soundProvider.playingState != null &&
          soundProvider.nowPlaying != null) {
        final soundState = soundProvider.playingState;
        final nowPlaying = soundProvider.nowPlaying;

        /// in this situation the player is related to the episode that is playing
        /// and the user can play or pause it
        if (nowPlaying?.guId == episode.guId) {
          if (soundState == SoundState.playing) {
            return InkWell(
              splashColor: transparent,
              highlightColor: transparent,
              onTap: () =>
                  soundProvider.setPlayerPlayingState(PlayerState.pause),
              child: PlayPauseButton(
                playerState: PlayerState.pause,
                isFromNowPlaying: isFromNowPlaying,
              ),
            );

            /// maybe because the internet connection the player waits
            /// for streaming completely
          } else if (soundState == SoundState.waiting) {
            return PlayPauseBusyButton(
              playerState: PlayerState.pause,
              isFromNowPlaying: isFromNowPlaying,
            );
          } else if (soundState == SoundState.pausing) {
            return InkWell(
              splashColor: transparent,
              highlightColor: transparent,
              onTap: () =>
                  soundProvider.setPlayerPlayingState(PlayerState.play),
              child: PlayPauseButton(
                playerState: PlayerState.play,
                isFromNowPlaying: isFromNowPlaying,
              ),
            );
          }
        }

        /// in this situation the player is not related to the episode that we want to play
        /// and the user just starts to play

        return InkWell(
          splashColor: transparent,
          highlightColor: transparent,
          onTap: () => soundProvider.setPlayEpisode(episode),
          child: PlayPauseButton(
            playerState: PlayerState.play,
            isFromNowPlaying: isFromNowPlaying,
          ),
        );
        // }
      } else {
        /// this means that we have not gotten the episode response yet
        /// and we can press Play button until the response comes and after that
        /// it plays the episode
        return InkWell(
          onTap: () => soundProvider.setPlayEpisode(episode),
          child: PlayPauseButton(
            playerState: PlayerState.play,
            isFromNowPlaying: isFromNowPlaying,
          ),
        );
      }
    });
  }
}
