import 'package:malango_pod/const_values/urls.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/models/itunes_item.dart';
import 'package:malango_pod/models/podcast_response.dart';
import 'package:malango_pod/providers/ui/home_provider/home_provider.dart';
import 'package:malango_pod/services/web_service.dart';

class HomeService {
  static Future<void> getPodcastSliders(
    WebService webService,
    HomeProvider homeProvider,
    String url,
  ) async {
    if (homeProvider.sliderPodcastResponse == null) {
      homeProvider.setSliderResponseViewState(ViewState.busy);

      var response = await webService.getFunction(url);

      if (response.success) {
        var items = <ItunesItem>[];
        var podcastEntries = response.body['feed']['entry'];
        if (podcastEntries != null) {
          for (var podcastEntry in podcastEntries) {
            var imId = podcastEntry['id']['attributes']['im:id'];

            var lookUpResponse =
                await webService.getFunction(URLs.lookUpPodcastUrl(imId));

            if (lookUpResponse.body['results'] != null) {
              var item =
                  ItunesItem.fromJson(json: lookUpResponse.body['results'][0]);
              items.add(item);
            }
          }
        }

        var homeResults =
            PodcastResponse(responseLength: items.length, itunesItems: items);
        homeProvider.setSliderPodcastResponse(homeResults);
        homeProvider.setSliderResponseViewState(ViewState.ready);
      } else {
        homeProvider.setSliderResponseViewState(ViewState.failed);
      }
    }
  }

  static Future<void> getHomePopularPodcast(
    WebService webService,
    HomeProvider homeProvider,
    String url,
  ) async {
    if (homeProvider.popularPodcastResponse == null) {
      homeProvider.setPopularResponseViewState(ViewState.busy);

      var response = await webService.getFunction(url);

      if (response.success) {
        var items = <ItunesItem>[];
        var podcastEntries = response.body['feed']['entry'];
        if (podcastEntries != null) {
          for (var podcastEntry in podcastEntries) {
            var imId = podcastEntry['id']['attributes']['im:id'];

            var lookUpResponse =
                await webService.getFunction(URLs.lookUpPodcastUrl(imId));

            if (lookUpResponse.body['results'] != null) {
              var item =
                  ItunesItem.fromJson(json: lookUpResponse.body['results'][0]);
              items.add(item);
            }
          }
        }

        var homeResults =
            PodcastResponse(responseLength: items.length, itunesItems: items);
        homeProvider.setPopularPodcastResponse(homeResults);
        homeProvider.setPopularResponseViewState(ViewState.ready);
      } else {
        homeProvider.setPopularResponseViewState(ViewState.failed);
      }
    }
  }

  static Future<void> getHomeSportPodcast(
    WebService webService,
    HomeProvider homeProvider,
    String url,
  ) async {
    if (homeProvider.sportPodcastResponse == null) {
      homeProvider.setSportResponseViewState(ViewState.busy);

      var response = await webService.getFunction(url);

      if (response.success) {
        var items = <ItunesItem>[];
        var podcastEntries = response.body['feed']['entry'];
        if (podcastEntries != null) {
          for (var podcastEntry in podcastEntries) {
            var imId = podcastEntry['id']['attributes']['im:id'];

            var lookUpResponse =
                await webService.getFunction(URLs.lookUpPodcastUrl(imId));

            if (lookUpResponse.body['results'] != null) {
              var item =
                  ItunesItem.fromJson(json: lookUpResponse.body['results'][0]);
              items.add(item);
            }
          }
        }

        var homeResults =
            PodcastResponse(responseLength: items.length, itunesItems: items);
        homeProvider.setSportPodcastResponse(homeResults);
        homeProvider.setSportResponseViewState(ViewState.ready);
      } else {
        homeProvider.setSportResponseViewState(ViewState.failed);
      }
    }
  }
}
