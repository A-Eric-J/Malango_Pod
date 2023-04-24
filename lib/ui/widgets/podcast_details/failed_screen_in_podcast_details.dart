import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/button.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// When response of podcast rss feed is returned failed [FailedScreenInPodcastDetails] is shown
class FailedScreenInPodcastDetails extends StatelessWidget {
  final Function onRefresh;

  const FailedScreenInPodcastDetails({Key key, @required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02, vertical: width * 0.03),
              child: ArrowBackIcon(
                color: brandMainColor,
                size: width * 0.06,
                onTap: () => locator<NavigationService>().goBack(),
              ),
            ),
            Center(
              child: Column(
                children: [
                  ImageAndIconFill(
                    path: Assets.networkProblem,
                    width: width * 0.32,
                    height: width * 0.8,
                  ),
                  SizedBox(
                    height: width * 0.04,
                  ),
                  const TextView(
                    text: failedToLoadText,
                    color: brandMainColor,
                    fontWeight: FontWeight.bold,
                    size: 15,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: width * 0.04,
                  ),
                  TryAgainButton(
                    onTap: onRefresh,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
