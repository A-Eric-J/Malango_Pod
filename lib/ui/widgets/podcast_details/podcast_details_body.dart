import 'package:flutter/material.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/ui/widgets/episode_item.dart';
import 'package:malango_pod/ui/widgets/podcast_details/podcast_details_board_informations.dart';
import 'package:malango_pod/ui/widgets/podcast_details/podcast_details_appbar.dart';
import 'package:malango_pod/ui/widgets/podcast_details/podcast_details_description.dart';
import 'package:provider/provider.dart';

/// [PodcastDetailsBody] contains episodes of this podcast and podcast description
class PodcastDetailsBody extends StatefulWidget {
  final Podcast podcast;
  final String description;

  const PodcastDetailsBody({Key key, @required this.podcast, this.description})
      : super(key: key);

  @override
  State<PodcastDetailsBody> createState() => _PodcastDetailsBodyState();
}

class _PodcastDetailsBodyState extends State<PodcastDetailsBody> {
  final ScrollController _sliverScrollController = ScrollController();

  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();

    scrollControllerListener();
  }

  void scrollControllerListener() {
    _sliverScrollController.addListener(() {
      if (!isCollapsed &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset >
              (MediaQuery.of(context).size.height * 0.547 - kToolbarHeight)) {
        setState(() {
          isCollapsed = true;
        });
      } else if (isCollapsed &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset <
              (MediaQuery.of(context).size.height * 0.547 - kToolbarHeight)) {
        setState(() {
          isCollapsed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastProvider>(
        builder: (context, podcastProvider, child) {
      return CustomScrollView(
        controller: _sliverScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          isCollapsed
              ? PodcastDetailsAppbar(
                  isCollapsed: isCollapsed,
                  title: widget.podcast.podcastTitle,
                  parentContext: context,
                )
              : SliverToBoxAdapter(child: Container()),
          SliverToBoxAdapter(
            child: PodcastDetailsBoardInformation(
              podcast: widget.podcast,
            ),
          ),
          if (podcastProvider.episodes != null &&
              podcastProvider.episodes.isNotEmpty)
            podcastProvider.isEpisodePage
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return EpisodeItem(
                        index: index,
                        episode: podcastProvider.episodes[index],
                      );
                    },
                    childCount: podcastProvider.episodes.length,
                    addAutomaticKeepAlives: false,
                  ))
                : SliverToBoxAdapter(
                    child: PodcastDetailsDescription(
                      description: widget.description,
                    ),
                  ),
        ],
      );
    });
  }
}
