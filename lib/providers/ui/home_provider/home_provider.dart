import 'package:flutter/material.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/models/podcast_response.dart';

/// In HomeScreen we have 3 parts of podcast showing(Slider,Populars,Sports)
/// every of these podcast showing parts have a different services for requesting
/// to server and we need a [HomeProvider] to have interactions between the response datas
/// and the every podcast showing parts for updating UI
class HomeProvider extends ChangeNotifier {
  /// Slider
  PodcastResponse _sliderPodcastResponse;

  PodcastResponse get sliderPodcastResponse => _sliderPodcastResponse;

  void setSliderPodcastResponse(PodcastResponse newResponse) {
    _sliderPodcastResponse = newResponse;
    notifyListeners();
  }

  ViewState _sliderResponseViewState = ViewState.preparing;

  ViewState get sliderResponseViewState => _sliderResponseViewState;

  void setSliderResponseViewState(ViewState state) {
    _sliderResponseViewState = state;
    notifyListeners();
  }

  /// Populars
  PodcastResponse _popularPodcastResponse;

  PodcastResponse get popularPodcastResponse => _popularPodcastResponse;

  void setPopularPodcastResponse(PodcastResponse newResponse) {
    _popularPodcastResponse = newResponse;
    notifyListeners();
  }

  ViewState _popularResponseViewState = ViewState.preparing;

  ViewState get popularResponseViewState => _popularResponseViewState;

  void setPopularResponseViewState(ViewState state) {
    _popularResponseViewState = state;
    notifyListeners();
  }

  /// Sports

  PodcastResponse _sportPodcastResponse;

  PodcastResponse get sportPodcastResponse => _sportPodcastResponse;

  void setSportPodcastResponse(PodcastResponse newResponse) {
    _sportPodcastResponse = newResponse;
    notifyListeners();
  }

  ViewState _sportResponseViewState = ViewState.preparing;

  ViewState get sportResponseViewState => _sportResponseViewState;

  void setSportResponseViewState(ViewState state) {
    _sportResponseViewState = state;
    notifyListeners();
  }

  /// [setHomePodcastResponseToNull] is called when we refresh the podcasts by RefreshIndicator

  void setHomePodcastResponseToNull() {
    _sliderPodcastResponse = null;
    _sliderResponseViewState = ViewState.preparing;

    _popularPodcastResponse = null;
    _popularResponseViewState = ViewState.preparing;

    _sportPodcastResponse = null;
    _sportResponseViewState = ViewState.preparing;

    notifyListeners();
  }
}
