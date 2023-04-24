import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/const_values/route_paths.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [SearchBarLabel] is a widget at the top of HomeScreen for navigating to SearchScreen
class SearchBarLabel extends StatelessWidget {
  const SearchBarLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stroke(
        radius: width * 0.012,
        backgroundColor: searchBarBackgroundColor,
        padding: EdgeInsets.all(width * 0.02),
        innerPadding: EdgeInsets.all(width * 0.04),
        onTap: () => locator<NavigationService>()
            .navigateTo(RoutePaths.searchScreenPath),
        child: Row(
          children: <Widget>[
            const ImageAndIconFill(
              path: Assets.search,
              isSvg: true,
            ),
            SizedBox(
              width: width * 0.02,
            ),
            const TextView(
              text: searchYourLovelyPodcastText,
              size: 12,
              color: midGreyColor,
            ),
          ],
        ));
  }
}
