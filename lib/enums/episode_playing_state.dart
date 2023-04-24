enum EpisodePlayingState { none, completed, stopped, paused }

EpisodePlayingState fromEpisodePlayingStateJson(String json){
  if (json != null) {
    switch (json) {
      case 'LastState.completed':
        return EpisodePlayingState.completed;
      case 'LastState.stopped':
        return EpisodePlayingState.stopped;
      case 'LastState.paused':
        return EpisodePlayingState.paused;
      default:
        return EpisodePlayingState.none;
    }
  }
  return EpisodePlayingState.none;
}

