import 'package:flutter/material.dart';
import 'package:malango_pod/enums/archives_type.dart';
import 'package:malango_pod/providers/episode_provider/episode_provider.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/episode_item.dart';
import 'package:malango_pod/ui/widgets/main_pages/archives/archive_empty_placeholder.dart';
import 'package:provider/provider.dart';

/// Download page of ArchiveScreen where the downloaded episodes placed
class Download extends StatefulWidget {
  const Download({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Download();
  }
}

class _Download extends State<Download> {
  @override
  void initState() {
    super.initState();
    final episodeProvider =
        Provider.of<EpisodeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      episodeProvider.loadDownloads();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EpisodeProvider>(
        builder: (context, episodeProvider, child) {
      if (episodeProvider.downloads != null) {
        if (episodeProvider.downloads.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            itemCount: episodeProvider.downloads.length,
            itemBuilder: (BuildContext context, int index) {
              return EpisodeItem(
                  episode: episodeProvider.downloads[index],
                  isFromArchive: true);
            },
          );
        } else {
          return const ArchiveEmptyPlaceholder(
              archivesType: ArchivesType.downloads);
        }
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(
                color: brandMainColor,
              ),
            ],
          ),
        );
      }
    });
  }
}
