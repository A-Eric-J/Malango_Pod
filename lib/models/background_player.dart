import 'package:flutter/material.dart';
import 'package:malango_pod/enums/episode_playing_state.dart';

/// when you are playing an episode and the UI is not visible it means
/// that it is in the background and when you change the position
/// or changing the state of episode it should be saved to show the user
/// when the UI become visible
class BackgroundPlayer {
  /// episode ID
  int backgroundEpisodeId;

  /// current position of the episode in Sec
  int backgroundPosition;

  /// the state of playing episode
  EpisodePlayingState backgroundPlayingState;

  BackgroundPlayer({
    @required this.backgroundEpisodeId,
    @required this.backgroundPosition,
    @required this.backgroundPlayingState,
  });

  static BackgroundPlayer fromJson(Map<String, dynamic> json) {
    return BackgroundPlayer(
      backgroundEpisodeId: json['episodeId'] as int,
      backgroundPosition: json['position'] as int,
      backgroundPlayingState:
          fromEpisodePlayingStateJson(json['state'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'episodeId': backgroundEpisodeId ?? backgroundEpisodeId.toString(),
      'position': backgroundPosition ?? backgroundPosition.toString(),
      'state': backgroundPlayingState == null
          ? EpisodePlayingState.none.toString()
          : backgroundPlayingState.toString(),
    };
  }

  BackgroundPlayer.backgroundPlayerClear() {
    backgroundEpisodeId = 0;
    backgroundPosition = 0;
    backgroundPlayingState = EpisodePlayingState.none;
  }
}
