import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/enums/archives_type.dart';
import 'package:malango_pod/enums/image_type.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// If every parts of Archives(Subscriptions, Downloads and Favorites) are empty [ArchiveEmptyPlaceholder] is shown
class ArchiveEmptyPlaceholder extends StatelessWidget {
  final ArchivesType archivesType;

  const ArchiveEmptyPlaceholder({Key key, @required this.archivesType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: width * 0.8,
        height: width * 0.8,
        child: Column(
          children: [
            ImageAndIconFill(
              path: Assets.emptyArchive,
              imageType: ImageType.assets,
              width: width * 0.6,
              height: width * 0.6,
            ),
            SizedBox(
              height: width * 0.01,
            ),
            TextView(
              text: text(),
              size: 15,
              fontWeight: FontWeight.bold,
              color: brandMainColor,
            ),
          ],
        ),
      ),
    );
  }

  String text() {
    switch (archivesType) {
      case ArchivesType.subscribes:
        return subscriptionListEmptyText;
      case ArchivesType.downloads:
        return downloadListEmptyText;
      case ArchivesType.favorites:
        return favoriteListEmptyText;
      default:
        return subscriptionListEmptyText;
    }
  }
}
