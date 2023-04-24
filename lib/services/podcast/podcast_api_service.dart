import 'dart:developer';

import 'package:dart_rss/domain/rss_feed.dart';
import 'package:flutter/foundation.dart';
import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:malango_pod/providers/podcast/podcast_provider.dart';
import 'package:malango_pod/services/podcast/helper_caching_podcast.dart';
import 'package:malango_pod/services/web_service.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';

class PodcastApiService {
  /// in every time that the app is open we cache 5 podcasts fot not sending request for those
  /// 5 podcasts to have a good performance
  static final helperCachingPodcast = HelperCachingPodcast(
      maxItemsCache: 5, expirationTime: const Duration(minutes: 40));

  static Future<void> getPodcastFeed(
      WebService webService,
      PodcastProvider podcastProvider,
      Podcast entryPodcast,
      MalangoDatabase malangoDatabase) async {
    podcastProvider.setPodcastFeedViewState(ViewState.busy);
    podcastProvider.episodeClear();
    try {
      var podcast = await getPodcast(
        webService,
        podcast: entryPodcast,
        malangoDatabase: malangoDatabase,
      );

      var episodes = podcast?.episodes;

      podcastProvider.setEpisodes(episodes);
      podcastProvider.setPodcast(podcast);

      podcastProvider.setPodcastFeedViewState(ViewState.ready);
    } on Exception {
      podcastProvider.setPodcastFeedViewState(ViewState.failed);
    }
  }

  /// [getPodcast] checks that if the podcast is cached before or not. if it doesn't
  /// we get it from requesting to server

  static Future<Podcast> getPodcast(
    WebService webService, {
    @required Podcast podcast,
    @required MalangoDatabase malangoDatabase,
  }) async {
    log('loadPodcast ${podcast.rssFeedLink}');

    /// we want to check that this podcast that we want is one the 5 caches?
    Podcast receivedPodcast =
        helperCachingPodcast.cachedItem(podcast.rssFeedLink);

    /// if loadedPodcast is null means that we haven't found it in our cache and lets get it from the server
    if (receivedPodcast == null) {
      log('receivedPodcast is null and we have to send request');
      try {
        log('Loading podcast from feed ${podcast.rssFeedLink}');

        /// here we set withUserAgent to true because to use rawResponse for RssFeed
        var response = await webService.getFunction(podcast.rssFeedLink,
            withUserAgent: true);

        var rssFeedResponse = RssFeed.parse(response.rawResponse);

        var episodes = <Episode>[];
        var narrator = rssFeedResponse.itunes.author;

        /// loading Episodes of this podcast
        for (var item in rssFeedResponse.items) {
          /// first we fill episodes then podcast because we need these episode
          /// to making receivedPodcast.
          episodes.add(Episode(
            guId: item.guid ?? '',
            episodeTitle: item.title ?? '',
            episodeDescription: item.description ?? '',
            episodePublicationDate: parseRFC2822Date(item.pubDate),
            narrator: item.author ?? item.itunes.author ?? item.dc?.creator,
            episodeDuration: item.itunes?.duration?.inMilliseconds,
            episodeLink: item.enclosure?.url,
            episodeImageLink: item.itunes?.image?.href,
            podcastSeason: item.itunes?.season,
            episodeSize: item.enclosure?.length.toString(),
            seasonEpisodeNumber: item.itunes?.episode,
          ));
        }

        /// after loading episodes we fill receivedPodcast and pass
        /// episodes to it
        receivedPodcast = Podcast(
          rssFeedLink: podcast.rssFeedLink,
          podcastTitle: rssFeedResponse.title,
          podcastDescription: rssFeedResponse.description,
          podcastImageLink:
              rssFeedResponse.image?.url ?? rssFeedResponse.itunes?.image?.href,
          podcastOwner: narrator,
          episodes: episodes,
        );
      } catch (e) {
        log('Error on $e');
        rethrow;
      }

      /// after filling receivedPodcast we add it to the cache for not to load it
      /// before loading 5 different podcasts for better performance
      helperCachingPodcast.storingPodcastForCaching(receivedPodcast);
    }

    final podcastTitle = removingHTMLPadding(receivedPodcast.podcastTitle);
    final podcastDescription =
        removingHTMLPadding(receivedPodcast.podcastDescription);
    final podcastOwner = removingHTMLPadding(receivedPodcast.podcastOwner);

    /// we check Db to give use the list of episodes that is favorited or downloaded(we mean that these episodes are in DB for a purpose)
    final existingEpisodes = await malangoDatabase
        .findEpisodesByPodcastGuid(receivedPodcast.rssFeedLink);
    var podcastImageLink = podcast.podcastImageLink;
    var podcastThumbnailImageLink = podcast.podcastThumbnailImageLink;

    if (podcastImageLink == null || podcastImageLink.isEmpty) {
      podcastImageLink = receivedPodcast.podcastImageLink;
      podcastThumbnailImageLink = receivedPodcast.podcastImageLink;
    }

    var podcast_ = Podcast(
      guId: receivedPodcast.rssFeedLink,
      rssFeedLink: receivedPodcast.rssFeedLink,
      podcastTitle: podcastTitle,
      podcastDescription: podcastDescription,
      podcastImageLink: podcastImageLink,
      podcastThumbnailImageLink: podcastThumbnailImageLink,
      podcastOwner: podcastOwner,
      episodes: <Episode>[],
    );

    /// here is for checking that this podcast is subscribed or not
    var subscribed =
        await malangoDatabase.findPodcastByGuid(receivedPodcast.rssFeedLink);
    if (subscribed != null) {
      podcast_.id = subscribed.id;
      podcast_.podcastSubscribed = subscribed.podcastSubscribed;
    }

    if (receivedPodcast.episodes != null) {
      /// most of the episodes are listed by sorted as publication date but
      /// not all of them, we check that if the length of the episode is more that one
      /// and first episode publication time in milliseconds is less than the second one it means
      /// that the list need sorting
      if (receivedPodcast.episodes.length > 1) {
        if (receivedPodcast
                .episodes[0].episodePublicationDate.millisecondsSinceEpoch <
            receivedPodcast
                .episodes[1].episodePublicationDate.millisecondsSinceEpoch) {
          receivedPodcast.episodes.sort((e1, e2) =>
              e2.episodePublicationDate.compareTo(e1.episodePublicationDate));
        }
      }

      for (final episode in receivedPodcast.episodes) {
        /// as we told before existingEpisodes is the list of episodes of this podcast that were in
        /// database before and if the episode(object item of the loop) is in existingEpisodes then
        /// we update existingEpisode maybe some changes happened  in the update and after that we add it as an episode of this podcast
        final existingEpisode = existingEpisodes
            .firstWhere((ep) => ep.guId == episode.guId, orElse: () => null);
        final author = episode.narrator?.replaceAll('\n', '')?.trim() ?? '';
        final title = removingHTMLPadding(episode.episodeTitle);
        final description = removingHTMLPadding(episode.episodeDescription);
        final episodeImage =
            episode.episodeImageLink == null || episode.episodeImageLink.isEmpty
                ? podcast_.podcastImageLink
                : episode.episodeImageLink;
        final episodeThumbImage =
            episode.episodeImageLink == null || episode.episodeImageLink.isEmpty
                ? podcast_.podcastThumbnailImageLink
                : episode.episodeImageLink;
        final duration =
            Duration(milliseconds: episode.episodeDuration)?.inSeconds ?? 0;

        /// calculating the episode size
        var size = episode.episodeSize;
        if (size == null) {
          size = '!';
        } else {
          if (!size.contains('.')) {
            if (size.length >= 4) {
              var sizeInByte = int.parse(size);
              var sizeInMb = sizeInByte.toDouble() / 1000000;
              var sizeNotRounded = sizeInMb.toString();
              var splitSize = sizeNotRounded.split('.');
              size = '${splitSize[0]}.${splitSize[1][0]}';
            }
          }
        }

        if (existingEpisode == null) {
          podcast_.episodes.add(Episode(
            podcastGuId: podcast_.guId,
            guId: episode.guId,
            podcastName: podcast_.podcastTitle,
            episodeTitle: title,
            episodeDescription: description,
            narrator: author,
            podcastSeason: episode.podcastSeason ?? 0,
            seasonEpisodeNumber: episode.seasonEpisodeNumber ?? 0,
            episodeLink: episode.episodeLink,
            episodeImageLink: episodeImage,
            episodeThumbnailImageLink: episodeThumbImage,
            episodeDuration: duration,
            episodeSize: size,
            episodePublicationDate: episode.episodePublicationDate,
          ));
        } else {
          /// maybe some of the information that you see in bellow
          /// are changed in a new update that we get from server and
          /// we just change those information. and another information
          /// are the same as before, maybe this episode is downloaded or favorited.
          /// this condition helps us to know that which episodes are favorited or
          /// downloaded before and we want their state be like before just some information may changed
          existingEpisode.episodeTitle = title;
          existingEpisode.episodeDescription = description;
          existingEpisode.narrator = author;
          existingEpisode.podcastSeason = episode.podcastSeason ?? 0;
          existingEpisode.seasonEpisodeNumber =
              episode.seasonEpisodeNumber ?? 0;
          existingEpisode.episodeLink = episode.episodeLink;
          existingEpisode.episodeImageLink = episodeImage;
          existingEpisode.episodeThumbnailImageLink = episodeThumbImage;
          existingEpisode.episodePublicationDate =
              episode.episodePublicationDate;

          if (duration > 0) {
            existingEpisode.episodeDuration = duration;
          }

          podcast_.episodes.add(existingEpisode);

          /// removing this episode from the existing list making existingEpisodes
          /// smaller and when the loop starts at first again, it faces to a smaller list for a better performance
          existingEpisodes.remove(existingEpisode);
        }
      }
    }

    return podcast_;
  }
}
