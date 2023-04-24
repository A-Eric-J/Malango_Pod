import 'package:flutter/material.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// [NowPlayerPositionController] is for changing position of the episode
class NowPlayerPositionController extends StatelessWidget {
  const NowPlayerPositionController({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer<PlayerProvider>(builder: (context, soundProvider, child) {
      var duration = soundProvider.nowPlaying == null
          ? 0
          : soundProvider.nowPlaying.episodeDuration;
      var playerLengthInSeconds = const Duration(seconds: 1).inSeconds;
      var playerPosition = const Duration(seconds: 1);
      var playerPositionInSeconds = playerPosition.inSeconds;

      if (soundProvider.playPosition != null) {
        playerLengthInSeconds = soundProvider.playPosition.length.inSeconds;
        playerPosition = soundProvider.playPosition.position;
        playerPositionInSeconds = playerPosition.inSeconds;
      }

      var timeLeft = duration - playerPositionInSeconds;

      if (timeLeft.isNegative) {
        timeLeft = 0;
      }
      if (playerPositionInSeconds.isNegative) {
        playerPositionInSeconds = 0;
      }
      if (playerPositionInSeconds > playerLengthInSeconds) {
        playerPositionInSeconds = playerLengthInSeconds;
      }

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextView(
                  text: timerFormat(playerPosition),
                  size: 12,
                  color: white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                TextView(
                  text: timerFormat(Duration(seconds: timeLeft)),
                  size: 12,
                  color: white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            height: width * 0.04,
            child: soundProvider.playPosition != null
                ? SliderTheme(
                    data: SliderThemeData(
                      disabledActiveTrackColor: brandMainColor,
                      disabledInactiveTrackColor: black,
                      trackHeight: 1.5,
                      thumbShape: RoundSliderThumbShape(
                          elevation: 2,
                          disabledThumbRadius: 0.0,
                          enabledThumbRadius: width * 0.0195),
                    ),
                    child: Slider(
                      onChanged: (value) {
                        soundProvider.setPositionSeek(value);
                      },
                      value: playerPositionInSeconds.toDouble(),
                      min: 0.0,
                      max: playerLengthInSeconds.toDouble(),
                      activeColor: white,
                    ))
                : SliderTheme(
                    data: SliderThemeData(
                      disabledActiveTrackColor: brandMainColor,
                      disabledInactiveTrackColor: black,
                      trackHeight: 1.5,
                      thumbShape: RoundSliderThumbShape(
                          elevation: 2,
                          disabledThumbRadius: 0.0,
                          enabledThumbRadius: width * 0.0195),
                    ),
                    child: const Slider(
                      onChanged: null,
                      value: 0,
                      min: 0.0,
                      max: 1.0,
                      activeColor: white,
                    ),
                  ),
          ),
        ],
      );
    });
  }
}
