import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/route_paths.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// Subscribe list in Subscription of ArchiveScreen is filled by [SubscribeItem]
class SubscribeItem extends StatelessWidget {
  final Podcast podcast;

  const SubscribeItem({
    Key key,
    @required this.podcast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: () => locator<NavigationService>()
            .navigateTo(RoutePaths.podcastDetailPath, arguments: podcast),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: width * 0.02,
          ),
          child: Stroke(
              radius: width * 0.019,
              backgroundColor: white,
              boxShadow: [
                BoxShadow(
                    color: midGreyColor,
                    blurRadius: width * 0.0213,
                    offset: const Offset(0.2, 0.5)),
              ],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 8,
                      child: ImageAndIconFill(
                        path: podcast.podcastImageLink,
                        fit: BoxFit.fill,
                        imageType: ImageType.network,
                        radius: width * 0.019,
                        clipBehavior: Clip.hardEdge,
                      )),
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(width * 0.01),
                            child: TextView(
                              text: podcast.podcastTitle,
                              size: 11,
                              color: primaryDark,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ))
                ],
              )),
        ));
  }
}
