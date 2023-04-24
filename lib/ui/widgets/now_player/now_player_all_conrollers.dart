import 'package:flutter/material.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/ui/widgets/now_player/now_player_position_controller.dart';
import 'package:malango_pod/ui/widgets/now_player/now_player_sound_controller.dart';

/// [NowPlayerAllControllers] in NowPlayerScreen has [NowPlayerPositionController] for changing position and
/// [NowPlayerSoundController] for play, pause, rewind or fastForwarding
class NowPlayerAllControllers extends StatelessWidget {
  final Episode episode;
  final bool isSmall;

  const NowPlayerAllControllers(
      {Key key, @required this.episode, this.isSmall = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        const NowPlayerPositionController(),
        SizedBox(
          height: isSmall ? width * 0.055 : width * 0.065,
        ),
        NowPlayerSoundController(
          episode: episode,
        ),
      ],
    );
  }
}
