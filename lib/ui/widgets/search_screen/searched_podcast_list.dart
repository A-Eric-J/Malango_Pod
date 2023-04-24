import 'package:malango_pod/models/podcast_response.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/search_screen/podcast_search_response_item.dart';
import 'package:flutter/material.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [SearchedPodcastList] is list of searched podcasts
class SearchedPodcastList extends StatelessWidget {
  final PodcastResponse results;

  const SearchedPodcastList({
    Key key,
    @required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    if (results.itunesItems.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemCount: results.itunesItems.length,
        itemBuilder: (BuildContext context, int index) {
          return PodcastSearchResponseItem(
              podcast:
                  Podcast.fromSearchResponseItem(results.itunesItems[index]));
        },
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(width * 0.08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SearchNotFoundIcon(),
            SizedBox(
              width: width * 0.01,
            ),
            const TextView(
              text: nothingFoundText,
              size: 18,
              color: brandMainColor,
              fontWeight: FontWeight.w700,
            )
          ],
        ),
      );
    }
  }
}
