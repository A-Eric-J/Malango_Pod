import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/route_paths.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [EpisodeItem] is used for showing episodes in PodcastDetailScreen, Downloads and Favorites screen
class EpisodeItem extends StatelessWidget {
  final int index;
  final Episode episode;
  final bool isFromArchive;

  const EpisodeItem({
    Key key,
    this.index,
    @required this.episode,
    this.isFromArchive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      child: Stroke(
          height: height * 0.125,
          padding: EdgeInsets.only(
              left: width * 0.02,
              right: width * 0.02,
              bottom: width * 0.01,
              top: index == 0 ? width * 0.04 : width * 0.01),
          innerPadding: EdgeInsets.all(width * 0.02),
          shadowColor: shadowColor,
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(0.1),
                blurRadius: 6.0,
                offset: const Offset(6, 4)),
          ],
          radius: width * 0.0213,
          backgroundColor: white,
          child: Row(
            children: [
              ImageAndIconFill(
                path: episode.episodeThumbnailImageLink,
                imageType: ImageType.network,
                fit: BoxFit.fill,
                width: width * 0.2198,
                height: width * 0.2198,
                radius: width * 0.0213,
                clipBehavior: Clip.hardEdge,
              ),
              SizedBox(
                width: width * 0.01,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextView(
                          text: episode.episodeTitle,
                          size: 13,
                          color: primaryDark,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: TextView(
                          text: episode.narrator,
                          size: 11,
                          color: midGreyColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: width * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textAndIcon(
                              printDuration(
                                  Duration(seconds: episode.episodeDuration)),
                              TimeIcon(
                                color: midGreyColor,
                                size: width * 0.03,
                              ),
                              width),

                          /// some of the episodes are not included their size
                          /// in the podcast xml feed
                          if (episode.episodeSize != null &&
                              episode.episodeSize != '0')
                            textAndIcon(
                                '${episode.episodeSize} MB',
                                FileIcon(
                                  color: midGreyColor,
                                  size: width * 0.03,
                                ),
                                width),
                          textAndIcon(
                              printDate(episode.episodePublicationDate),
                              DateIcon(
                                color: midGreyColor,
                                size: width * 0.03,
                              ),
                              width),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
      onTap: () => locator<NavigationService>()
          .navigateTo(RoutePaths.episodePagePath, arguments: {
        'episode': episode,
        'index': index,
        'isFromArchive': isFromArchive
      }),
    );
  }

  Widget textAndIcon(String text, Widget icon, double width) {
    return Row(
      children: [
        icon,
        SizedBox(
          width: width * 0.002,
        ),
        TextView(
          text: text,
          size: 11,
          color: midGreyColor,
        ),
      ],
    );
  }
}
