import 'package:flutter/foundation.dart';
import 'package:malango_pod/models/itunes_item.dart';

import 'episode.dart';

/// This class presents an Podcast that has some Episodes
class Podcast {
  /// Database ID
  int id;

  /// GUID is a Unique identifier for the podcast
  final String guId;

  /// The link of the podcast RSS feed.
  final String rssFeedLink;

  /// Podcast title
  final String podcastTitle;

  /// Podcast description
  final String podcastDescription;

  /// link of  the podcast image
  final String podcastImageLink;

  /// link of the thumbnail image of the podcast
  final String podcastThumbnailImageLink;

  /// the Owner of the podcast.
  final String podcastOwner;

  /// this parameter is for storing the state of podcast
  /// if it is subscribed in the database
  bool podcastSubscribed;

  /// DateTime of the subscribed podcast of the user.
  DateTime podcastSubscribedDate;

  /// every podcast has some episodes
  List<Episode> episodes;

  Podcast({
    this.id,
    this.guId,
    @required this.rssFeedLink,
    @required this.podcastTitle,
    this.podcastDescription,
    this.podcastImageLink,
    this.podcastThumbnailImageLink,
    this.podcastOwner,
    this.podcastSubscribed,
    this.podcastSubscribedDate,
    this.episodes,
  }) {
    /// at first when the podcast is fetched we make episodes empty
    /// to fill it when the user opened podcast detail
    episodes ??= [];
  }

  /// [fromJson] is used for converting the stored datas
  /// from the database to the object
  static Podcast fromJson(Map<String, dynamic> podcast) {
    return Podcast(
      id: podcast['id'] as int,
      guId: podcast['guId'] as String,
      rssFeedLink: podcast['rssFeedLink'] as String,
      podcastTitle: podcast['podcastTitle'] as String,
      podcastDescription: podcast['podcastDescription'] as String,
      podcastImageLink: podcast['podcastImageLink'] as String,
      podcastThumbnailImageLink: podcast['podcastThumbnailImageLink'] as String,
      podcastOwner: podcast['podcastOwner'] as String,
      podcastSubscribed: podcast['podcastSubscribed'] == 1 ? true : false,
      podcastSubscribedDate: podcast['podcastSubscribedDate'] == 'null'
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(
              int.parse(podcast['podcastSubscribedDate'] as String)),
    );
  }

  /// [toJson] is used for converting the object to storing
  /// in the database
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'guId': guId,
      'rssFeedLink': rssFeedLink,
      'podcastTitle': podcastTitle ?? '',
      'podcastDescription': podcastDescription ?? '',
      'podcastImageLink': podcastImageLink ?? '',
      'podcastThumbnailImageLink': podcastThumbnailImageLink ?? '',
      'podcastOwner': podcastOwner ?? '',
      'podcastSubscribed':
          (podcastSubscribed != null && podcastSubscribed) ? 'true' : 'false',
      'podcastSubscribedDate':
          podcastSubscribedDate?.millisecondsSinceEpoch.toString(),
    };
  }

  /// [fromSearchResponseItem] is used for getting podcast object
  /// from ItunesItem object that is fetched
  static Podcast fromSearchResponseItem(ItunesItem item) {
    return Podcast(
        guId: item.itunesGuId,
        rssFeedLink: item.rssFeedLink,
        podcastTitle: item.itunesTrackName,
        podcastDescription: '',
        podcastImageLink: item.itunesImageLink ?? item.itunesImageLink600In600 ?? item.itunesImageLink100In100 ?? item.itunesImageLink60In60 ?? item.itunesImageLink30In30,
        podcastThumbnailImageLink: item.itunesImageLink60In60 ?? item.itunesImageLink100In100 ?? item.itunesImageLink600In600 ?? item.itunesImageLink,
        podcastOwner: item.itunesArtistName);
  }
}
