import 'package:flutter/material.dart';
import 'package:malango_pod/enums/archives_type.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/ui/widgets/main_pages/archives/subscribe_item.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/main_pages/archives/archive_empty_placeholder.dart';
import 'package:provider/provider.dart';

/// Subscribe page of ArchiveScreen where the subscribed podcasts placed
class Subscribe extends StatefulWidget {
  const Subscribe({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Subscribe();
  }
}

class _Subscribe extends State<Subscribe> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer<PodcastProvider>(
        builder: (context, podcastProvider, child) {
      if (podcastProvider.subscriptions != null) {
        if (podcastProvider.subscriptions.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: width * 0.02,
                crossAxisCount: 3,
                childAspectRatio: 0.76,
              ),
              itemCount: podcastProvider.subscriptions.length,
              itemBuilder: (BuildContext context, int index) {
                return SubscribeItem(
                    podcast: podcastProvider.subscriptions[index]);
              },
            ),
          );
        } else {
          return const ArchiveEmptyPlaceholder(
            archivesType: ArchivesType.subscribes,
          );
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
