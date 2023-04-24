import 'package:flutter/material.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// PodcastDetailScreen has a SelectionButton for switching between episodes page and description page named [PodcastDetailsSelectionPart]
class PodcastDetailsSelectionPart extends StatelessWidget {
  const PodcastDetailsSelectionPart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stroke(
      height: (height * 9.15178) / 100,
      width: (width * 78.9855) / 100,
      backgroundColor: white,
      radius: width * 0.0213,
      child:
          Consumer<PodcastProvider>(builder: (context, podcastProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              splashColor: transparent,
              highlightColor: transparent,
              onTap: () {
                podcastProvider.changePage(true);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EpisodeIcon(
                    color: podcastProvider.isEpisodePage ? green : midGreyColor,
                    size: width * 0.0853,
                  ),
                  TextView(
                    text: episodesText,
                    color: podcastProvider.isEpisodePage ? green : midGreyColor,
                    size: 10,
                  ),
                ],
              ),
            ),
            InkWell(
              splashColor: transparent,
              highlightColor: transparent,
              onTap: () {
                podcastProvider.changePage(false);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoIcon(
                    color:
                        !podcastProvider.isEpisodePage ? green : midGreyColor,
                    size: width * 0.0853,
                  ),
                  TextView(
                    text: informationText,
                    color:
                        !podcastProvider.isEpisodePage ? green : midGreyColor,
                    size: 10,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
