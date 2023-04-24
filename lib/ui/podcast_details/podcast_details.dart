import 'package:flutter/material.dart';
import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/services/podcast/podcast_api_service.dart';
import 'package:malango_pod/ui/mini_player/mini_player.dart';
import 'package:malango_pod/ui/widgets/busy_state_screen.dart';
import 'package:malango_pod/ui/widgets/podcast_details/failed_screen_in_podcast_details.dart';
import 'package:malango_pod/ui/widgets/podcast_details/podcast_details_body.dart';
import 'package:provider/provider.dart';

/// When you Tab on every podcast items it is going to get complete information and
/// its episodes from rss feed and show them to you in [PodcastDetails]
class PodcastDetails extends StatefulWidget {
  final Podcast podcast;

  const PodcastDetails({Key key, @required this.podcast}) : super(key: key);

  @override
  State<PodcastDetails> createState() => _PodcastDetailsState();
}

class _PodcastDetailsState extends State<PodcastDetails> {
  PodcastProvider podcastProvider;

  @override
  void initState() {
    super.initState();

    podcastProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      requestToServer();
    });
  }

  void requestToServer() {
    PodcastApiService.getPodcastFeed(
        Provider.of(context, listen: false),
        Provider.of(context, listen: false),
        widget.podcast,
        MalangoDatabase.db);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// this is for returning pager to EpisodePage in dispose
      podcastProvider.changePage(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Consumer<PodcastProvider>(builder: (context, podcastProvider, child) {
          var state = podcastProvider.podcastFeedViewState;
          if (state == ViewState.busy) {
            return const BusyStateScreen();
          } else if (state == ViewState.failed) {
            return Align(
              alignment: Alignment.topCenter,
              child: FailedScreenInPodcastDetails(
                onRefresh: requestToServer,
              ),
            );
          } else if (state == ViewState.ready) {
            var podcast = podcastProvider.podcast;
            return PodcastDetailsBody(
              podcast: widget.podcast,
              description: podcast.podcastDescription,
            );
          } else {
            return Container();
          }
        }),
        const MiniPlayer()
      ],
    ));
  }
}
