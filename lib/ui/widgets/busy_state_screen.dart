import 'package:flutter/material.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/extensions/widget_extension.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';

/// [BusyStateScreen] is a widget contains BusyLayer extension that we use it
/// for busy state of getting rss feed response and going to PodcastDetail
class BusyStateScreen extends StatelessWidget {
  const BusyStateScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          Container().withBusyOverlay(true),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: width * 0.03),
            child: ArrowBackIcon(
              color: white,
              size: width * 0.06,
              onTap: () => locator<NavigationService>().goBack(),
            ),
          ),
        ],
      ),
    );
  }
}
