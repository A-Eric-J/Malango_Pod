import 'package:malango_pod/providers/search/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:malango_pod/ui/mini_player/mini_player.dart';
import 'package:malango_pod/ui/widgets/search_screen/search_appbar.dart';
import 'package:malango_pod/ui/widgets/search_screen/search_responses.dart';
import 'package:malango_pod/ui/widgets/search_screen/search_text_bar.dart';
import 'package:provider/provider.dart';

/// You can search for any podcasts that are available on iTunes on [SearchScreen]
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchProvider searchProvider;

  @override
  void initState() {
    super.initState();

    searchProvider = Provider.of(context, listen: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// this is for cleaning the list of search when disposing
      /// search screen
      searchProvider.clean();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Consumer<SearchProvider>(builder: (context, searchProvider, child) {
              return Column(
                children: const [
                  SearchAppbar(),
                  SearchTextBar(),
                  Expanded(child: SearchResponses())
                ],
              );
            }),
            const MiniPlayer()
          ],
        ),
      ),
    );
  }
}
