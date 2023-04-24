import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/urls.dart';
import 'package:malango_pod/enums/podcast_type.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/providers/ui/home_provider/home_provider.dart';
import 'package:malango_pod/services/home/home_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/main_pages/home/malango_label.dart';
import 'package:malango_pod/ui/widgets/main_pages/home/podcast_horizontal_list.dart';
import 'package:malango_pod/ui/widgets/main_pages/home/podcast_horizontal_list_in_busy_state.dart';
import 'package:malango_pod/ui/widgets/main_pages/home/podcast_slider.dart';
import 'package:malango_pod/ui/widgets/main_pages/home/podcast_slider_in_busy_state.dart';
import 'package:malango_pod/ui/widgets/main_pages/home/search_bar_label.dart';
import 'package:provider/provider.dart';

/// [Home] is a screen in the MainView where
/// we have searchBar for searching podcasts, sliders of important podcasts,
/// popular podcasts and sport podcasts. you can place whatever you need and want
class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeProvider homeProvider;

  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    if (homeProvider.popularPodcastResponse == null ||
        homeProvider.sliderPodcastResponse == null ||
        homeProvider.sportPodcastResponse == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        requestsToServer();
      });
    }
  }

  void requestsToServer() {
    HomeService.getPodcastSliders(Provider.of(context, listen: false),
        homeProvider, URLs.homePopularPodcastUrl(4));
    HomeService.getHomePopularPodcast(Provider.of(context, listen: false),
        homeProvider, URLs.homePopularPodcastUrl(10));
    HomeService.getHomeSportPodcast(Provider.of(context, listen: false),
        homeProvider, URLs.homeSportPodcastUrl(10));
  }

  Future<void> refresh() async {
    homeProvider.setHomePodcastResponseToNull();
    requestsToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: SafeArea(
        child: Consumer<HomeProvider>(builder: (context, homeProvider, child) {
          return Column(
            children: [
              const SearchBarLabel(),
              Expanded(
                child: RefreshIndicator(
                  color: brandMainColor,
                  backgroundColor: white,
                  onRefresh: () => refresh(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        podcastTypeWidgets(
                            homeProvider: homeProvider,
                            podcastType: PodcastType.slider),
                        podcastTypeWidgets(
                            homeProvider: homeProvider,
                            podcastType: PodcastType.popular),
                        podcastTypeWidgets(
                            homeProvider: homeProvider,
                            podcastType: PodcastType.sports),
                        const MalangoLabel(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget podcastTypeWidgets(
      {HomeProvider homeProvider, PodcastType podcastType}) {
    switch (podcastType) {
      case PodcastType.slider:
        if (homeProvider.sliderResponseViewState == ViewState.ready &&
            homeProvider.sliderPodcastResponse != null &&
            homeProvider.sliderPodcastResponse.itunesItems.isNotEmpty) {
          return PodcastSlider(
            itunesItems: homeProvider.sliderPodcastResponse.itunesItems,
          );
        } else {
          return const PodcastSliderInBusyState();
        }
        break;
      case PodcastType.popular:
        if (homeProvider.popularResponseViewState == ViewState.ready &&
            homeProvider.popularPodcastResponse != null &&
            homeProvider.popularPodcastResponse.itunesItems.isNotEmpty) {
          return PodcastHorizontalList(
            title: popularTitleText,
            itunesItems: homeProvider.popularPodcastResponse.itunesItems,
          );
        } else {
          return const PodcastHorizontalListInBusyState(
              title: popularTitleText);
        }
        break;
      case PodcastType.sports:
        if (homeProvider.sportResponseViewState == ViewState.ready &&
            homeProvider.sportPodcastResponse != null &&
            homeProvider.sportPodcastResponse.itunesItems.isNotEmpty) {
          return PodcastHorizontalList(
            title: sportTitleText,
            itunesItems: homeProvider.sportPodcastResponse.itunesItems,
          );
        } else {
          return const PodcastHorizontalListInBusyState(title: sportTitleText);
        }
        break;
      default:
        return Container();
    }
  }
}
