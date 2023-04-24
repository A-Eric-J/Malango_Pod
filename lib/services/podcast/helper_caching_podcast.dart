import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:malango_pod/models/cache.dart';
import 'package:malango_pod/models/podcast.dart';

/// We want to have the best performance for requesting to get podcast feed. so we use a mechanism
/// like Queue structure(First In First Out) to cache the feeds to not request for them due its expiration
/// and queue situation.
class HelperCachingPodcast {
  final Queue<Cache> cacheQueue;
  final int maxItemsCache;
  final Duration expirationTime;

  HelperCachingPodcast({
    @required this.expirationTime,
    @required this.maxItemsCache,
  }) : cacheQueue = Queue<Cache>();

  void storingPodcastForCaching(Podcast podcast) {
    /// as you know the behavior of Queue is FIFO
    /// that means the queue is full we will remove first item
    if (cacheQueue.length == maxItemsCache) {
      cacheQueue.removeFirst();
    }

    cacheQueue.addLast(
        Cache(podcast: podcast, dateTimePodcastIsAdded: DateTime.now()));
  }

  Podcast cachedItem(String podcastUrl) {
    var desiredPodcast = cacheQueue.firstWhere(
        (Cache cache) => cache.podcast.rssFeedLink == podcastUrl,
        orElse: () => null);
    Podcast podcast;

    if (desiredPodcast != null) {
      if (DateTime.now().difference(desiredPodcast.dateTimePodcastIsAdded) <=
          expirationTime) {
        podcast = desiredPodcast.podcast;
      } else {
        cacheQueue.remove(desiredPodcast);
      }
    }

    return podcast;
  }
}
