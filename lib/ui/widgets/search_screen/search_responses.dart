import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/providers/search/search_provider.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/search_screen/searched_podcast_list.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// [SearchResponses] in different states of searching
class SearchResponses extends StatelessWidget {
  const SearchResponses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: mainBackgroundColor,
      child:
          Consumer<SearchProvider>(builder: (context, searchProvider, child) {
        final state = searchProvider.podcastResponseViewState;
        if (state == ViewState.busy) {
          return const Center(
              child: CircularProgressIndicator(
            color: brandMainColor,
          ));
        } else if (state == ViewState.ready) {
          return SearchedPodcastList(results: searchProvider.podcastResponse);
        } else if (state == ViewState.failed) {
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

        return Container();
      }),
    );
  }
}
