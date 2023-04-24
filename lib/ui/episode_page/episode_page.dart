import 'package:flutter/material.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/mini_player/mini_player.dart';
import 'package:malango_pod/ui/widgets/episode_page/episode_page_player.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/episode_page/episode_page_background_blur_image.dart';
import 'package:malango_pod/ui/widgets/episode_page/episode_page_decription.dart';
import 'package:malango_pod/ui/widgets/episode_page/episode_page_triple_call_to_action.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// [EpisodePage] contains episode information where you can play, favorite or download it
class EpisodePage extends StatefulWidget {
  final int index;
  final Episode episode;
  final bool isFromArchive;

  const EpisodePage({
    Key key,
    this.episode,
    this.index,
    this.isFromArchive = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EpisodePage();
  }
}

class _EpisodePage extends State<EpisodePage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  EpisodePageBackgroundBlurImage(
                    imageUrl: widget.episode.episodeImageLink,
                  ),
                  Consumer<PodcastProvider>(
                      builder: (context, podcastProvider, child) {
                    var episodeState = podcastProvider.episodes != null &&
                        podcastProvider.episodes.isNotEmpty;
                    return SafeArea(
                        child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ArrowBackIcon(
                              color: white,
                              onTap: () =>
                                  locator<NavigationService>().goBack(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.1334,
                        ),
                        Stroke(
                          height: width * 0.5,
                          width: width * 0.5,
                          borderWidth: 1.7,
                          borderColor: midGreyColor,
                          radius: width * 0.0213,
                          child: ImageAndIconFill(
                            path: widget.episode.episodeImageLink,
                            fit: BoxFit.fill,
                            imageType: ImageType.network,
                            radius: width * 0.0106,
                            clipBehavior: Clip.hardEdge,
                          ),
                        ),
                        SizedBox(
                          height: width * 0.05336,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: TextView(
                            text: widget.episode.episodeTitle,
                            color: green,
                            fontWeight: FontWeight.bold,
                            size: 14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: width * 0.05336,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: width * 0.07114),
                          child: SizedBox(
                            height: width * 0.12,

                            /// we check the index to know that, from where we came to the episode page
                            /// if index != null it means that we came from podcast detail screen and we should
                            /// play the podcastProvider.episodes[widget.index] but if we came from downloaded items
                            /// or favorited items we just use widget.episode to play
                            child: widget.index != null
                                ? episodeState
                                    ? EpisodePagePlayer(
                                        episode: podcastProvider
                                            .episodes[widget.index],
                                      )
                                    : const TextView(
                                        text: unableToPlayThisEpisodeText,
                                        size: 14,
                                        color: primaryErrorColor,
                                        fontWeight: FontWeight.w700,
                                      )
                                : EpisodePagePlayer(episode: widget.episode),
                          ),
                        ),
                        EpisodePageTripleCallToAction(
                          episode: widget.index != null
                              ? podcastProvider.episodes[widget.index]
                              : widget.episode,
                          isFromArchive: widget.isFromArchive,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: width * 0.04,
                            horizontal: width * 0.03,
                          ),
                          child: const Divider(
                            color: midGreyColor,
                            thickness: 1,
                          ),
                        ),
                        EpisodePageDescription(
                          description: widget.episode.episodeDescription,
                        )
                      ],
                    ));
                  }),
                ],
              ),
            ],
          ),
        ),
        const MiniPlayer(),
      ],
    ));
  }
}
