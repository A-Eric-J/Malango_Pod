import 'package:flutter/material.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/models/podcast_response.dart';

/// [SearchProvider] is a provider for searching podcasts and updating SearchScreen UI
class SearchProvider extends ChangeNotifier {

  PodcastResponse _podcastResponse;

  PodcastResponse get podcastResponse => _podcastResponse;

  void setPodcastResponse(PodcastResponse newPodcastResponse){
    _podcastResponse = newPodcastResponse;
    notifyListeners();
  }


  ViewState _podcastResponseViewState = ViewState.preparing;

  ViewState get podcastResponseViewState => _podcastResponseViewState;

  void setPodcastResponseViewState(ViewState state){
    _podcastResponseViewState = state;
    notifyListeners();
  }

  void clean(){
    _podcastResponse = null;
    _podcastResponseViewState = ViewState.preparing;
    notifyListeners();
  }
}
