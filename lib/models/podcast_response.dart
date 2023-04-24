import 'package:flutter/foundation.dart';
import 'package:malango_pod/models/itunes_item.dart';

class PodcastResponse {
  /// How much do you want the length of PodcastResponse to be?
  final int responseLength;

  /// List of Itunes item.
  final List<ItunesItem> itunesItems;

  PodcastResponse({
    this.responseLength = 0,
    this.itunesItems = const [],
  });

  factory PodcastResponse.fromJson({@required dynamic json}) {
    if (json['errorMessage'] != null) {
      return PodcastResponse(responseLength: 0, itunesItems: []);
    } else {
      return PodcastResponse(
          responseLength: json['resultCount'] ?? 0,
          itunesItems: json['results'] != null
              ? (json['results'] as List)
                  .cast<Map<String, dynamic>>()
                  .map((Map<String, dynamic> item) {
                  return ItunesItem.fromJson(json: item);
                }).toList()
              : []);
    }
  }
}
