import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:malango_pod/enums/gradient_type.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';

import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/button.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/custom_gradient.dart';
import 'package:malango_pod/ui/widgets/podcast_details/podcast_details_selection_part.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [PodcastDetailsBoardInformation] is a custom widget for showing podcast information
/// like its title, image and subscribe button for subscribing
class PodcastDetailsBoardInformation extends StatelessWidget {
  final Podcast podcast;

  const PodcastDetailsBoardInformation({Key key, @required this.podcast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        ClipPath(
          clipper: PodcastDetailsDiagonalClipper(),
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: const BoxDecoration(),
            child: SizedBox(
              height: height * 0.465,
              child: Stack(fit: StackFit.expand, children: <Widget>[
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ImageAndIconFill(
                    path: podcast.podcastImageLink,
                    fit: BoxFit.fill,
                    imageType: ImageType.network,
                  ),
                ),
                const CustomGradient(
                  gradientType: GradientType.podcastDetailBoard,
                ),
                Padding(
                  padding: EdgeInsets.only(top: statusBarHeight),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ArrowBackIcon(
                                  color: white,
                                  onTap: () =>
                                      locator<NavigationService>().goBack(),
                                ),
                                ShareIcon(
                                  color: white,
                                  onTap: () => onShare(context,
                                      sharePodcastText(podcast.podcastTitle)),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 6,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.016),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.06),
                                    child: Stroke(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: shadowColor,
                                          blurRadius: 17.0,
                                        ),
                                      ],
                                      child: ImageAndIconFill(
                                        path: podcast.podcastImageLink,
                                        radius: width * 0.0213,
                                        imageType: ImageType.network,
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextView(
                                          text: podcast.podcastTitle,
                                          size: 12,
                                          color: white,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: width * 0.0266),
                                        SubscriptionButton(podcast: podcast),
                                      ],
                                    )),
                              ],
                            ),
                          )),
                      Expanded(flex: 2, child: Container()),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
        SizedBox(
          height: height * 0.469,
          child: Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(flex: 11, child: Container()),
              const Expanded(
                flex: 3,
                child: PodcastDetailsSelectionPart(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
