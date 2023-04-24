import 'package:flutter/material.dart';
import 'package:malango_pod/enums/archives_type.dart';
import 'package:malango_pod/providers/ui/archives_provider/archives_pager_provider.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// Archive Screen has these three parts : Subscriptions, Downloads and Favorites => [ArchiveParts]
class ArchiveParts extends StatelessWidget {
  const ArchiveParts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer<ArchivePagerProvider>(
        builder: (context, archiveProvider, child) {
      return Stroke(
        backgroundColor: white,
        boxShadow: [
          BoxShadow(
            color: archiveBackgroundColor,
            blurRadius: width * 0.0213,
            offset: const Offset(0.0, 10.0),
          ),
        ],
        innerPadding: EdgeInsets.symmetric(vertical: width * 0.08),
        child: Column(
          children: [
            const TextView(
              text: archivesScreenText,
              size: 18,
              fontWeight: FontWeight.bold,
              color: brandMainColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: width * 0.06,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                archivePartsButton(
                  archiveProvider,
                  width,
                  ArchivesType.subscribes,
                ),
                archivePartsButton(
                  archiveProvider,
                  width,
                  ArchivesType.downloads,
                ),
                archivePartsButton(
                  archiveProvider,
                  width,
                  ArchivesType.favorites,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget archivePartsButton(ArchivePagerProvider archiveProvider, double width,
      ArchivesType archivesType) {
    Color backgroundColor = transparent;
    Color iconColor = transparent;
    Function onTap = () {};
    String title = '';
    switch (archivesType) {
      case ArchivesType.subscribes:
        backgroundColor = archiveProvider.archivePage == 0
            ? green
            : brandMainColor.withOpacity(0.18);
        iconColor = archiveProvider.archivePage == 0 ? archiveIconColor : green;
        onTap = () => archiveProvider.changeArchivePage(0);
        title = subscribesText;
        break;
      case ArchivesType.downloads:
        backgroundColor = archiveProvider.archivePage == 1
            ? green
            : brandMainColor.withOpacity(0.18);
        iconColor = archiveProvider.archivePage == 1 ? archiveIconColor : green;
        onTap = () => archiveProvider.changeArchivePage(1);
        title = downloadsText;
        break;
      case ArchivesType.favorites:
        backgroundColor = archiveProvider.archivePage == 2
            ? green
            : brandMainColor.withOpacity(0.18);
        iconColor = archiveProvider.archivePage == 2 ? archiveIconColor : green;
        onTap = () => archiveProvider.changeArchivePage(2);
        title = favoritesText;
        break;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stroke(
          width: width * 0.151,
          height: width * 0.151,
          radius: width * 0.151,
          backgroundColor: backgroundColor,
          onTap: onTap,
          boxShadow: [
            BoxShadow(
              color: backgroundColor,
              blurRadius: width * 0.0133,
            ),
          ],
          child: ArchiveIconsList(
            archivesType: archivesType,
            color: iconColor,
          ),
        ),
        SizedBox(
          height: width * 0.02,
        ),
        TextView(
          text: title,
          size: 9,
          color: brandMainColor,
        ),
      ],
    );
  }
}
