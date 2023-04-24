import 'package:flutter/material.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/button/button.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/episode_page/episode_page_decription.dart';

/// NowPlayerScreen has 3 call to actions => favoriteButton, shareButton and InfoButton for showing episode information in a modal
class NowPlayerTripleCallToAction extends StatelessWidget {
  final Episode episode;
  final bool isSmall;

  const NowPlayerTripleCallToAction(
      {Key key, @required this.episode, this.isSmall = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FavoriteButton(
            episode: episode, width: isSmall ? width * 0.065 : width * 0.07),
        ShareIcon(
          size: isSmall ? width * 0.065 : width * 0.07,
          color: white,
          onTap: () => onShare(
            context,
            shareEpisodeText(episode.podcastName, episode.episodeTitle),
          ),
        ),
        InfoIcon(
          size: isSmall ? width * 0.065 : width * 0.07,
          color: white,
          onTap: () => aboutThisEpisodeModal(context, width),
        ),
      ],
    );
  }

  void aboutThisEpisodeModal(BuildContext context, double width) {
    locator<NavigationService>().showModal(
      context,
      Padding(
        padding: EdgeInsets.only(top: isSmall ? width * 0.05 : width * 0.0533),
        child: SingleChildScrollView(
            child: EpisodePageDescription(
          description: episode.episodeDescription,
        )),
      ),
      shouldScroll: true,
      // shouldScroll: true,
    );
  }
}
