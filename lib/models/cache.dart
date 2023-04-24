import 'package:flutter/foundation.dart';
import 'package:malango_pod/models/podcast.dart';

/// This class is for storing in a queue to know which podcasts are loaded to handle
/// the feed requests
class Cache {
  final Podcast podcast;
  final DateTime dateTimePodcastIsAdded;

  Cache({@required this.podcast, @required this.dateTimePodcastIsAdded});
}