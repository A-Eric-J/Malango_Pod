import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:malango_pod/enums/gradient_type.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/custom_gradient.dart';

/// [EpisodePageBackgroundBlurImage] is a custom widget that is use at the top background of EpisodePage
class EpisodePageBackgroundBlurImage extends StatelessWidget {
  final String imageUrl;

  const EpisodePageBackgroundBlurImage({Key key, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      width: width,
      child: ClipPath(
        clipper: EpisodePageDiagonalClipper(),
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: const BoxDecoration(),
          child: Stack(fit: StackFit.expand, children: <Widget>[
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: ImageAndIconFill(
                path: imageUrl,
                height: width * 0.1333,
                width: width * 0.1333,
                fit: BoxFit.fill,
                imageType: ImageType.network,
              ),
            ),
            const CustomGradient(gradientType: GradientType.episodePage)
          ]),
        ),
      ),
    );
  }
}
