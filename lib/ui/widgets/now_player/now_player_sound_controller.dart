import 'package:flutter/material.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/enums/player_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/episode_play_controller.dart';
import 'package:provider/provider.dart';

/// [NowPlayerSoundController] is for play, pause, rewind or fastForwarding
class NowPlayerSoundController extends StatelessWidget {
  final Episode episode;

  const NowPlayerSoundController({Key key, this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.17,
      ),
      child: Consumer<PlayerProvider>(builder: (context, soundProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RewindIcon(
              color: white,
              onTap: () =>
                  soundProvider.setPlayerPlayingState(PlayerState.rewind),
            ),
            EpisodePlayController(
              episode: episode,
              isFromNowPlaying: true,
            ),
            FastForwardIcon(
              color: white,
              onTap: () =>
                  soundProvider.setPlayerPlayingState(PlayerState.fastForward),
            )
          ],
        );
      }),
    );
  }
}
