import 'package:flutter/services.dart';
import 'package:malango_pod/base/provider_setup.dart';
import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/services/podcast/podcast_database_service.dart';
import 'package:malango_pod/ui/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:malango_pod/base/router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  MalangoDatabase malangoDb;
  PodcastDatabaseService podcastDatabaseService;

  @override
  void initState() {
    super.initState();
    malangoDb = MalangoDatabase.db;
    podcastDatabaseService = PodcastDatabaseService(
      malangoDb: malangoDb,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: providers(
          malangoDb: malangoDb, podcastDatabaseService: podcastDatabaseService),
      child: MaterialApp(
        onGenerateRoute: router.Router.generateRoute,
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigationService>().navigatorKey,
        home: const MainView(),
      ),
    );
  }
}
