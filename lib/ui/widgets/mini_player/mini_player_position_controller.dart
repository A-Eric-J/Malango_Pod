import 'package:flutter/material.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:provider/provider.dart';

/// PositionController of MiniPlayer
class MiniPlayerPositionController extends StatelessWidget {
  const MiniPlayerPositionController({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer<PlayerProvider>(builder: (context, soundProvider, child) {
      var playerLength = const Duration(seconds: 1).inSeconds;
      var playerPosition = const Duration(seconds: 1).inSeconds;

      if (soundProvider.playPosition != null) {
        playerLength = soundProvider.playPosition.length.inSeconds;
        playerPosition = soundProvider.playPosition.position.inSeconds;
      }
      if (playerPosition.isNegative) {
        playerPosition = 0;
      }
      if (playerPosition > playerLength) {
        playerPosition = playerLength;
      }

      return SizedBox(
        height: width * 0.0133,
        child: Row(
          children: <Widget>[
            /// We used Expanded to fill the slider to the end width of the MiniPlayer
            Expanded(
                child: SliderTheme(
              data: SliderThemeData(
                trackHeight: width * 0.00533,
                thumbShape: const RoundSliderThumbShape(
                    elevation: 2,
                    disabledThumbRadius: 0.0,
                    enabledThumbRadius: 0.0),
              ),
              child: Slider(
                activeColor: brandMainColor,
                inactiveColor: green.withOpacity(0.3),
                value: soundProvider.playPosition != null
                    ? playerPosition.toDouble()
                    : 0.0,
                max: soundProvider.playPosition != null
                    ? playerLength.toDouble()
                    : 1.0,
                min: 0.0,
                onChanged: (value) => soundProvider.playPosition != null
                    ? soundProvider.setPositionSeek(value)
                    : null,
              ),
            )),
          ],
        ),
      );
    });
  }
}
