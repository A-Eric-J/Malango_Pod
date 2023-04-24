import 'package:flutter/material.dart';
import 'package:malango_pod/enums/archives_type.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/episode_item.dart';
import 'package:malango_pod/ui/widgets/main_pages/archives/archive_empty_placeholder.dart';
import 'package:provider/provider.dart';

/// Favorite page of ArchiveScreen where the favorited episodes placed
class Favorite extends StatefulWidget {
  const Favorite({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Favorite();
  }
}

class _Favorite extends State<Favorite> {
  @override
  void initState() {
    super.initState();

    final podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      podcastProvider.loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastProvider>(
        builder: (context, podcastProvider, child) {
      if (podcastProvider.episodes != null) {
        if (podcastProvider.episodes.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            itemCount: podcastProvider.episodes.length,
            itemBuilder: (BuildContext context, int index) {
              return EpisodeItem(
                  episode: podcastProvider.episodes[index],
                  isFromArchive: true);
            },
          );
        } else {
          return const ArchiveEmptyPlaceholder(
              archivesType: ArchivesType.favorites);
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
