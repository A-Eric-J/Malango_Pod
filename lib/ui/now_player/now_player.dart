import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:malango_pod/enums/gradient_type.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/custom_gradient.dart';
import 'package:malango_pod/ui/widgets/now_player/now_player_all_conrollers.dart';
import 'package:malango_pod/ui/widgets/now_player/now_player_triple_call_to_action.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// When you Tab on MiniPlayer the [NowPlayer] screen opens and
/// you face to information of that episode like
/// its image, player and some buttons for that episode
class NowPlayer extends StatefulWidget {
  final bool isSmall;

  const NowPlayer({
    Key key,
    this.isSmall = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NowPlayerState();
  }
}

class _NowPlayerState extends State<NowPlayer> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(body: Consumer<PlayerProvider>(
      builder: (context, soundProvider, child) {
        if (soundProvider.nowPlaying != null) {
          return Stack(
            children: [
              Stack(fit: StackFit.expand, children: <Widget>[
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ImageAndIconFill(
                    path: soundProvider.nowPlaying.episodeImageLink,
                    fit: BoxFit.cover,
                    imageType: ImageType.network,
                  ),
                ),
                const CustomGradient(
                  gradientType: GradientType.nowPlayer,
                )
              ]),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.0213),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ArrowDownIcon(
                                  color: white,
                                  size: widget.isSmall
                                      ? width * 0.07
                                      : width * 0.088,
                                  onTap: () =>
                                      locator<NavigationService>().goBack(),
                                ),
                              ),
                            ),
                            Stroke(
                              height:
                                  widget.isSmall ? width * 0.5 : width * 0.77,
                              width:
                                  widget.isSmall ? width * 0.5 : width * 0.77,
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.5),
                                  blurRadius: width * 0.0266,
                                ),
                              ],
                              child: ImageAndIconFill(
                                path: soundProvider.nowPlaying.episodeImageLink,
                                fit: BoxFit.fill,
                                imageType: ImageType.network,
                                clipBehavior: Clip.hardEdge,
                                radius: width * 0.0213,
                              ),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: widget.isSmall
                                      ? width * 0.015
                                      : width * 0.04,
                                  horizontal: width * 0.04,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextView(
                                      text:
                                          soundProvider.nowPlaying.episodeTitle,
                                      size: widget.isSmall ? 12 : 14,
                                      fontWeight: FontWeight.bold,
                                      maxLines: 1,
                                      color: white,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: widget.isSmall
                                          ? width * 0.01
                                          : width * 0.02,
                                    ),
                                    TextView(
                                      text: soundProvider.nowPlaying.narrator,
                                      size: widget.isSmall ? 10 : 12,
                                      fontWeight: FontWeight.bold,
                                      maxLines: 1,
                                      color: midGreyColor,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: NowPlayerTripleCallToAction(
                                episode: soundProvider.nowPlaying,
                                isSmall: widget.isSmall,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: NowPlayerAllControllers(
                                episode: soundProvider.nowPlaying,
                                isSmall: widget.isSmall,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}
