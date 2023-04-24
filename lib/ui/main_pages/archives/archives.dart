import 'package:flutter/material.dart';
import 'package:malango_pod/providers/ui/archives_provider/archives_pager_provider.dart';
import 'package:malango_pod/ui/main_pages/archives/download/download.dart';
import 'package:malango_pod/ui/main_pages/archives/favorite/favorite.dart';
import 'package:malango_pod/ui/main_pages/archives/subscribe/subscribe.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/main_pages/archives/archive_parts.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:provider/provider.dart';

/// [Archives] is a screen in the MainView where
/// subscribed podcasts, downloaded episodes and favorited ones are placed
class Archives extends StatefulWidget {
  const Archives({Key key}) : super(key: key);

  @override
  State<Archives> createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(child:
        Consumer<ArchivePagerProvider>(builder: (context, archivePager, child) {
      return Column(
        children: [
          const ArchiveParts(),
          SizedBox(
            height: width * 0.03,
          ),
          Expanded(
            child: Container(
                color: mainBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(width * 0.02),
                      child: TextView(
                        text: _textOfArchivePages(archivePager.archivePage),
                        size: 16,
                        color: primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      color: mainBackgroundColor,
                      child: _archivePages(archivePager.archivePage),
                    )),
                  ],
                )),
          )
        ],
      );
    }));
  }

  Widget _archivePages(int index) {
    switch (index) {
      case 0:
        return const Subscribe();
        break;

      case 1:
        return const Download();
        break;

      case 2:
        return const Favorite();
        break;

      default:
        return const Subscribe();
    }
  }

  String _textOfArchivePages(int index) {
    switch (index) {
      case 0:
        return subscribesText;
        break;

      case 1:
        return downloadsText;
        break;

      case 2:
        return favoritesText;
        break;

      default:
        return subscribesText;
    }
  }
}
