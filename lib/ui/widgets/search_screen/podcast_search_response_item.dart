import 'package:malango_pod/const_values/route_paths.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:flutter/material.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [PodcastSearchResponseItem] is a podcast item for showing searched podcast response that contains image, title and owner of this podcast
class PodcastSearchResponseItem extends StatelessWidget {
  final Podcast podcast;

  const PodcastSearchResponseItem({
    Key key,
    @required this.podcast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stroke(
      width: width,
      onTap: () => locator<NavigationService>()
          .navigateTo(RoutePaths.podcastDetailPath, arguments: podcast),
      radius: width * 0.0213,
      backgroundColor: white,
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: width * 0.01),
      innerPadding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: width * 0.03),
      boxShadow: [
        BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(6, 4)),
      ],
      child: Row(
        children: [
          ImageAndIconFill(
            path: podcast.podcastImageLink,
            height: width * 0.16,
            width: width * 0.16,
            radius: width * 0.0213,
            clipBehavior: Clip.hardEdge,
            imageType: ImageType.network,
          ),
          SizedBox(
            width: width * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(
                text: podcast.podcastTitle,
                size: 14,
                color: primaryDark,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: width * 0.01,
              ),
              TextView(
                text: podcast.podcastOwner ?? '',
                size: 12,
                color: midGreyColor,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          )
        ],
      ),
    );
  }
}
