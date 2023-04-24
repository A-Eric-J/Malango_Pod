import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:malango_pod/enums/download_modal_state.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/enums/player_state.dart';
import 'package:malango_pod/enums/podcast_behaviour.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/providers/episode_provider/episode_provider.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// [RectAngleButton] is a custom button that we are using in this app
class RectAngleButton extends StatelessWidget {
  final String nameOfButton;
  final Color color;
  final Color borderColor;
  final Color shadowColor;
  final double height;
  final double width;
  final double radius;
  final VoidCallback onTap;
  final ViewState state;
  final Color textColor;
  final double textSize;
  final EdgeInsetsGeometry insidePadding;

  const RectAngleButton({
    Key key,
    @required this.nameOfButton,
    this.color,
    this.height,
    this.width,
    @required this.onTap,
    @required this.state,
    this.radius,
    this.borderColor,
    this.shadowColor,
    this.textColor,
    this.textSize,
    this.insidePadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
          height: height,
          width: this.width,
          decoration: BoxDecoration(
            color: color ?? brandMainColor,
            borderRadius: BorderRadius.circular(radius ?? width * 0.032),
            border: Border.all(color: borderColor ?? Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? Colors.transparent,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: insidePadding ?? EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextView(
                  text: nameOfButton,
                  color: textColor ?? white,
                  size: textSize ?? 15,
                ),
                if (state == ViewState.busy)
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.03),
                    child: SizedBox(
                      height: width * 0.05,
                      width: width * 0.05,
                      child: const CircularProgressIndicator(
                        color: white,
                      ),
                    ),
                  )
              ],
            ),
          )),
    );
  }
}

/// When we had problem in fetching data of podcast based on any reasons, when PodcastDetail
/// is opening, we show [TryAgainButton] for requesting again
class TryAgainButton extends StatelessWidget {
  final VoidCallback onTap;

  const TryAgainButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(width * 0.0213),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextView(
                text: tryAgainText,
                size: 12,
                color: primaryDark,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                width: width * 0.0186,
              ),
              const ReplayIcon(
                isFill: false,
                color: brandMainColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EpisodePagePlayerButton extends StatelessWidget {
  final String text;

  const EpisodePagePlayerButton({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Stroke(
        width: width * 0.6087,
        borderWidth: 2,
        borderColor: text == playText ? brandMainColor : midGreyColor,
        radius: width * 0.02,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextView(
              text: text,
              color: text == playText ? brandMainColor : midGreyColor,
              fontWeight: FontWeight.bold,
              size: 13,
            ),
          ],
        ));
  }
}

/// [PlayPauseButton] for episodes
class PlayPauseButton extends StatelessWidget {
  final PlayerState playerState;
  final bool isFromNowPlaying;

  const PlayPauseButton({
    Key key,
    @required this.playerState,
    this.isFromNowPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stroke(
      radius: width * 0.0746,
      borderWidth: width * 0.0053,
      borderColor: white,
      innerPadding: EdgeInsets.all(width * 0.0106),
      child: playerState == PlayerState.play
          ? PlayIcon(
              size: isFromNowPlaying ? width * 0.064 : width * 0.0586,
              color: white,
            )
          : PauseIcon(
              size: isFromNowPlaying ? width * 0.064 : width * 0.0586,
              color: white,
            ),
    );
  }
}

/// [PlayPauseBusyButton] for episodes when the episode is in busy state
class PlayPauseBusyButton extends StatelessWidget {
  final PlayerState playerState;
  final bool isFromNowPlaying;

  const PlayPauseBusyButton({
    Key key,
    @required this.playerState,
    this.isFromNowPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: isFromNowPlaying ? width * 0.1173 : width * 0.1066,
      width: isFromNowPlaying ? width * 0.112 : width * 0.1013,
      child: Stack(
        children: <Widget>[
          SpinKitDoubleBounce(
            color: white.withOpacity(0.2),
          ),
          Center(
            child: playerState == PlayerState.play
                ? PlayIcon(
                    size: isFromNowPlaying ? width * 0.064 : width * 0.0586,
                    color: white,
                  )
                : PauseIcon(
                    size: isFromNowPlaying ? width * 0.064 : width * 0.0586,
                    color: white,
                  ),
          ),
        ],
      ),
    );
  }
}

/// [SubscriptionButton] for podcasts
class SubscriptionButton extends StatelessWidget {
  final Podcast podcast;

  const SubscriptionButton({Key key, this.podcast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer<PodcastProvider>(
        builder: (context, podcastProvider, child) {
      if (podcastProvider.podcast != null) {
        log('SubscriptionButton: ${podcastProvider.podcast.podcastSubscribed}');
        return (podcastProvider.podcast.podcastSubscribed != null &&
                podcastProvider.podcast.podcastSubscribed)
            ? InkWell(
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () {
                  podcastProvider
                      .setPodcastBehaviour(PodcastBehaviour.unsubscribe);
                },
                child: Stroke(
                    width: width * 0.3623,
                    borderColor: midGreyColor,
                    backgroundColor: midGreyColor,
                    radius: width * 0.02,
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const TextView(
                            text: unSubscribeText,
                            color: white,
                            size: 12,
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          SubscriptionIcon(
                            isFill: true,
                            color: white,
                            size: width * 0.04,
                          )
                        ],
                      ),
                    )),
              )
            : InkWell(
                splashColor: transparent,
                highlightColor: transparent,
                onTap: () {
                  podcastProvider
                      .setPodcastBehaviour(PodcastBehaviour.subscribe);
                },
                child: Stroke(
                    width: width * 0.3623,
                    borderColor: white,
                    radius: width * 0.02,
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const TextView(
                            text: subscribeText,
                            color: white,
                            size: 12,
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          SubscriptionIcon(
                            isFill: false,
                            color: white,
                            size: width * 0.04,
                          )
                        ],
                      ),
                    )),
              );
      }
      return Container();
    });
  }
}

/// [DownloadButton] for episodes
class DownloadButton extends StatelessWidget {
  final DownloadState downloadState;
  final EpisodeProvider episodeProvider;
  final Episode episode;
  final VoidCallback onTap;
  final bool onTapEnable;
  final bool isFromArchive;

  const DownloadButton({
    Key key,
    @required this.downloadState,
    @required this.episodeProvider,
    @required this.episode,
    this.onTap,
    this.onTapEnable = true,
    this.isFromArchive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var progressPercent = episode.episodeDownloadPercentageProgress != null &&
            episode.episodeDownloadPercentageProgress != 0
        ? episode.episodeDownloadPercentageProgress
        : 0;

    if (downloadState == DownloadState.none ||
        downloadState == DownloadState.canceled ||
        downloadState == DownloadState.failed) {
      return DownloadIcon(
        size: width * 0.08,
        color: brandMainColor,
        onTap: onTapEnable ? onTap : null,
      );
    } else if (downloadState == DownloadState.downloading ||
        downloadState == DownloadState.queued) {
      return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: () => _showCancelOrDeleteModal(context, width,
            DownloadModalState.cancel, episodeProvider, episode),
        child: Column(
          children: [
            TextView(
              text: '$progressPercent%',
              size: 12,
              color: brandMainColor,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(
              height: width * 0.01,
            ),
            LinearProgressIndicator(
              value: progressPercent.toDouble() / 100,
              backgroundColor: midGreyColor, // the color of the background
              valueColor: const AlwaysStoppedAnimation<Color>(brandMainColor),
            ),
          ],
        ),
      );
    } else if (downloadState == DownloadState.downloaded) {
      return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: () => onTapEnable
            ? _showCancelOrDeleteModal(context, width,
                DownloadModalState.delete, episodeProvider, episode)
            : null,
        child: Column(
          children: [
            DeleteIcon(
              size: width * 0.08,
              color: lightBlue,
            ),
            SizedBox(
              height: width * 0.01,
            ),
            const TextView(
              text: downloadedText,
              size: 12,
              color: brandMainColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      );
    } else {
      return DownloadIcon(
        size: width * 0.08,
        color: brandMainColor,
        onTap: onTapEnable ? onTap : null,
      );
    }
  }

  Future<void> _showCancelOrDeleteModal(
      BuildContext context,
      double width,
      DownloadModalState downloadModalState,
      EpisodeProvider episodeProvider,
      Episode episode) async {
    var title = '';
    switch (downloadModalState) {
      case DownloadModalState.cancel:
        title = cancelDownloadAlertText;
        break;
      case DownloadModalState.delete:
        title = deleteDownloadAlertText;
        break;
    }
    locator<NavigationService>().showModal(
        context,
        Padding(
          padding: EdgeInsets.all(width * 0.1333),
          child: Column(
            children: [
              TextView(
                text: title,
                color: primaryDark,
                size: 14,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: width * 0.08,
              ),
              Row(
                children: [
                  Expanded(
                    child: RectAngleButton(
                      nameOfButton: yesText,
                      onTap: () {
                        episodeProvider.deleteDownload(
                          episode,
                        );
                        locator<NavigationService>().goBack();
                        if (isFromArchive &&
                            downloadModalState == DownloadModalState.delete) {
                          locator<NavigationService>().goBack();
                        }
                      },
                      state: ViewState.ready,
                      radius: width * 0.02,
                      color: brandMainColor,
                      textColor: white,
                      insidePadding: EdgeInsets.all(width * 0.0213),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Expanded(
                    child: RectAngleButton(
                      nameOfButton: noText,
                      onTap: () => locator<NavigationService>().goBack(),
                      state: ViewState.ready,
                      radius: width * 0.02,
                      color: customRed,
                      textColor: white,
                      insidePadding: EdgeInsets.all(width * 0.0213),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

/// [FavoriteButton] for episodes
class FavoriteButton extends StatefulWidget {
  final Episode episode;
  final double width;

  const FavoriteButton({Key key, this.episode, this.width}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FavoriteButton();
  }
}

class _FavoriteButton extends State<FavoriteButton> {
  var isFavorited = false;

  @override
  void initState() {
    super.initState();

    isFavorited = (widget.episode.episodeFavorited != null &&
            widget.episode.episodeFavorited)
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastProvider>(
        builder: (context, podcastProvider, child) {
      return FavoriteIcon(
        onTap: () async {
          if (await storagePermission()) {
            if (isFavorited) {
              widget.episode.episodeFavorited = false;
              podcastProvider.setFavoriteOrUnFavoriteEpisode(widget.episode);
              setState(() {
                isFavorited = false;
              });
            } else {
              widget.episode.episodeFavorited = true;
              podcastProvider.setFavoriteOrUnFavoriteEpisode(widget.episode);
              setState(() {
                isFavorited = true;
              });
            }
          }
        },
        color: customRed,
        isFill: isFavorited ? true : false,
        size: widget.width,
      );
    });
  }
}
