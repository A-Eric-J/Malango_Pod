import 'package:malango_pod/const_values/route_paths.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/ui/episode_page/episode_page.dart';
import 'package:malango_pod/ui/now_player/now_player.dart';
import 'package:malango_pod/ui/podcast_details/podcast_details.dart';
import 'package:malango_pod/ui/search_screen/search_screen.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:flutter/material.dart';

/// All the Routes for navigating are placed here
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.searchScreenPath:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case RoutePaths.podcastDetailPath:
        var podcast = settings.arguments as Podcast;
        return MaterialPageRoute(
            builder: (_) => PodcastDetails(
                  podcast: podcast,
                ));
      case RoutePaths.episodePagePath:
        var arguments = settings.arguments as Map<String, dynamic>;
        var episode = arguments['episode'];
        var index = arguments['index'];
        var isFromArchive = arguments['isFromArchive'];
        return MaterialPageRoute(
            builder: (_) => EpisodePage(
                  episode: episode,
                  index: index,
                isFromArchive : isFromArchive
                ));
      case RoutePaths.nowPlayerScreenPath:
        var isSmall = settings.arguments as bool;
        return MaterialPageRoute(builder: (_) => NowPlayer(isSmall: isSmall));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: TextView(
                      text: 'No route defined for ${settings.name}',
                      size: 16,
                    ),
                  ),
                ));
    }
  }
}
