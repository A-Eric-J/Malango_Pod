import 'package:flutter/foundation.dart';
import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/providers/ui/archives_provider/archives_pager_provider.dart';
import 'package:malango_pod/providers/ui/home_provider/home_provider.dart';
import 'package:malango_pod/providers/episode_provider/episode_provider.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/providers/player_provider/player_provider.dart';
import 'package:malango_pod/providers/search/search_provider.dart';
import 'package:malango_pod/providers/ui/bottom_navigation_provider.dart';
import 'package:malango_pod/services/cookie_service.dart';
import 'package:malango_pod/services/podcast/podcast_database_service.dart';
import 'package:malango_pod/services/web_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// provider_setup initializes the providers that are using in MalangoPod
List<SingleChildWidget> providers(
        {@required MalangoDatabase malangoDb,
        @required PodcastDatabaseService podcastDatabaseService}) =>
    [
      ...independentServices(malangoDb, podcastDatabaseService),
      ...dependentServices,
    ];

List<SingleChildWidget> independentServices(MalangoDatabase malangoDb,
        PodcastDatabaseService podcastDatabaseService) =>
    [
      Provider.value(value: CookieService()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => ArchivePagerProvider()),
      ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(
          create: (_) => PlayerProvider(malangoDb: malangoDb)),
      ChangeNotifierProvider(
          create: (_) => PodcastProvider(
                podcastDatabaseService: podcastDatabaseService,
              )),
      ChangeNotifierProvider(
          create: (_) => EpisodeProvider(
                podcastDatabaseService: podcastDatabaseService,
              )),
    ];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<CookieService, WebService>(
    update: (context, cookieService, webService) => webService == null
        ? WebService(
            cookieService: cookieService,
          )
        : webService.setDependencies(cookieService),
    create: (context) => WebService(),
  ),
];
