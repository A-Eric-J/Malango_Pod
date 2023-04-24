import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:malango_pod/const_values/route_paths.dart';
import 'package:malango_pod/enums/gradient_type.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/models/itunes_item.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/custom_gradient.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// We have [PodcastSlider] at the top of HomeScreen that shows important podcasts
class PodcastSlider extends StatelessWidget {
  final List<ItunesItem> itunesItems;

  const PodcastSlider({
    Key key,
    @required this.itunesItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: width * 0.01,
      ),
      child: SizedBox(
        height: width * 0.45,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            final podcast = Podcast.fromSearchResponseItem(itunesItems[index]);
            return InkWell(
              splashColor: transparent,
              highlightColor: transparent,
              onTap: () => locator<NavigationService>()
                  .navigateTo(RoutePaths.podcastDetailPath, arguments: podcast),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ImageAndIconFill(
                          path: podcast.podcastImageLink,
                          fit: BoxFit.cover,
                          width: width * 0.5,
                          height: width * 0.3961,
                          imageType: ImageType.network,
                        ),
                      ),
                      const CustomGradient(
                        gradientType: GradientType.slider,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SizedBox(
                      height: width * 0.29,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stroke(
                            radius: width * 0.0106,
                            child: ImageAndIconFill(
                              path: podcast.podcastImageLink,
                              imageType: ImageType.network,
                              fit: BoxFit.fill,
                              width: width * 0.27,
                              height: width * 0.27,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: width,
                              child: Padding(
                                padding: EdgeInsets.only(left: width * 0.042),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextView(
                                      text: '${podcast.podcastTitle}  ',
                                      size: 14,
                                      color: white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      height: width * 0.03,
                                    ),
                                    TextView(
                                      text: '${podcast.podcastOwner}  ',
                                      size: 10,
                                      color: white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          autoplay: true,
          itemCount: itunesItems.length,
          pagination: SwiperPagination(
              margin: EdgeInsets.zero,
              builder: SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                return ConstrainedBox(
                  constraints: BoxConstraints.expand(height: width * 0.0533),
                  child: Align(
                    alignment: Alignment.center,
                    child: DotSwiperPaginationBuilder(
                      color: midGreyColor,
                      activeColor: white,
                      size: MediaQuery.of(context).size.width * 0.015,
                    ).build(context, config),
                  ),
                );
              })),
          control: const SwiperControl(size: 0),
        ),
      ),
    );
  }
}
