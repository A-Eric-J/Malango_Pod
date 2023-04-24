import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/route_paths.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// We have 2 parts(popular and sport) in HomeScreen that their lists are filled by [HomePodcastItem]
class HomePodcastItem extends StatefulWidget {
  final Podcast podcast;

  const HomePodcastItem({Key key, this.podcast}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePodcastItem();
  }
}

class _HomePodcastItem extends State<HomePodcastItem> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var widthImage = width * 0.3961;
    return Stroke(
      radius: width * 0.012,
      padding: EdgeInsets.symmetric(horizontal: width * 0.0145),
      backgroundColor: white,
      width: (width / 3) - (width * 0.0255),
      onTap: () => locator<NavigationService>()
          .navigateTo(RoutePaths.podcastDetailPath, arguments: widget.podcast),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ImageAndIconFill(
              path: widget.podcast.podcastImageLink,
              imageType: ImageType.network,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: width * 0.01,
          ),
          Column(
            children: [
              SizedBox(
                width: widthImage,
                child: TextView(
                  text: widget.podcast.podcastTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  size: 12,
                  color: primaryDark,
                ),
              ),
              SizedBox(
                height: width * 0.01,
              ),
              SizedBox(
                width: widthImage,
                child: TextView(
                  text: widget.podcast.podcastOwner,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  size: 8,
                  color: midGreyColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
