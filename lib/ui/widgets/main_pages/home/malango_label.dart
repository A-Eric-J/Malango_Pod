import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [MalangoLabel] is a widget that is shown at the bottom of HomeScreen and at the top of SearchScreen
class MalangoLabel extends StatelessWidget {
  const MalangoLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: width * 0.14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageAndIconFill(
            path: Assets.smallLogoPng,
            width: width * 0.10,
            height: width * 0.10,
            imageType: ImageType.assets,
          ),
          SizedBox(
            width: width * 0.016,
          ),
          const TextView(
            text: capitalMalangoNameText,
            size: 15,
            color: brandMainColor,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
