import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/enums/gradient_type.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/custom_gradient.dart';

/// BusyLayer is an extension for busy placeholders and we use it
/// for busy state of getting rss feed response and going to PodcastDetail
extension BusyLayer on Widget {
  Widget withBusyOverlay(bool isBusy,
      {bool withOpacity = true, double height = double.maxFinite}) {
    return Stack(
      children: [
        this,
        if (isBusy)
          CustomGradient(
            gradientType: GradientType.busyStateScreen,
            child: Stack(
              children: [
                Center(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: white.withOpacity(withOpacity ? 0.7 : 1.0),
                      ),
                      padding: const EdgeInsets.all(32),
                      child: const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: brandMainColor,
                        ),
                      )),
                ),
                const Center(
                  child: ImageAndIconFill(
                    path: Assets.logo,
                    imageType: ImageType.assets,
                    height: 50,
                    width: 50,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
