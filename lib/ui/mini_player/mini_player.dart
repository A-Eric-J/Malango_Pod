import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/route_paths.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/enums/sound_state.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/enums/player_state.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/episode_play_controller.dart';
import 'package:malango_pod/ui/widgets/mini_player/mini_player_position_controller.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// When you start to play an episode [MiniPlayer] appears in all the pages and
/// it is the only way to go to NowPlayer screen
class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key key,
  }) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Consumer<PlayerProvider>(builder: (context, soundProvider, child) {
      /// This means that an episode is playing and we need MiniPlayer
      if (soundProvider.playingState != null &&
          !(soundProvider.playingState == SoundState.stopped ||
              soundProvider.playingState == SoundState.none)) {
        if (soundProvider.nowPlaying != null) {
          return InkWell(
            splashColor: transparent,
            highlightColor: transparent,
            onTap: () => locator<NavigationService>().navigateTo(
                RoutePaths.nowPlayerScreenPath,
                arguments: height < 600 ? true : false),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ImageAndIconFill(
                      path: soundProvider.nowPlaying.episodeImageLink,
                      imageType: ImageType.network,
                      width: width,
                      height: width * 0.15,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: width * 0.155,
                      color: black.withOpacity(0.8),
                    ),
                    SizedBox(
                        height: width * 0.16,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: width * 0.0106,
                                  horizontal: width * 0.0053),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: width * 0.14,
                                      height: width * 0.14,
                                      margin: EdgeInsets.only(
                                          top: width * 0.0133,
                                          bottom: width * 0.008,
                                          right: width * 0.016,
                                          left: width * 0.016),
                                      child: ImageAndIconFill(
                                        path: soundProvider
                                            .nowPlaying.episodeImageLink,
                                        height: width * 0.14,
                                        width: width * 0.14,
                                        clipBehavior: Clip.hardEdge,
                                        radius: width * 0.0106,
                                        fit: BoxFit.fill,
                                        imageType: ImageType.network,
                                      )),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextView(
                                      text:
                                          soundProvider.nowPlaying.episodeTitle,
                                      size: 14,
                                      color: white,
                                      fontWeight: FontWeight.w500,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.0213),
                                    child: EpisodePlayController(
                                      episode: soundProvider.nowPlaying,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const MiniPlayerPositionController(),
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  height: width * 0.18,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: ClearOrCloseIcon(
                        size: width * 0.0533,
                        color: customRed,
                        onTap: () async => await soundProvider
                            .setPlayerPlayingState(PlayerState.stop),
                      )),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    });
  }
}
