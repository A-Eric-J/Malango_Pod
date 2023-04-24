import 'package:flutter/material.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/episode_download_controller.dart';
import '../button/button.dart';

/// We have three call to actions(favorite,download and share) in [EpisodePageTripleCallToAction] widget in EpisodePage
class EpisodePageTripleCallToAction extends StatelessWidget {
  final Episode episode;
  final bool isFromArchive;

  const EpisodePageTripleCallToAction({
    Key key,
    this.episode,
    this.isFromArchive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.only(
            bottom: width * 0.03557,
            right: width * 0.0213,
            left: width * 0.0213),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: FavoriteButton(episode: episode, width: width * 0.08),
            ),
            Expanded(
              child: EpisodeDownloadController(
                episode: episode,
                isFromArchive: isFromArchive,
              ),
            ),
            Expanded(
              child: ShareIcon(
                  color: green,
                  size: width * 0.08,
                  onTap: () => onShare(
                        context,
                        shareEpisodeText(
                            episode.podcastName, episode.episodeTitle),
                      )),
            )
          ],
        ));
  }
}
