import 'dart:async';
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/enums/episode_playing_state.dart';
import 'package:malango_pod/enums/sound_state.dart';
import 'package:malango_pod/models/background_player.dart';
import 'package:malango_pod/providers/lifecycle_provider/lifecycle_provider.dart';
import 'package:malango_pod/enums/player_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:flutter/foundation.dart';
import 'package:malango_pod/models/player_position_model.dart';
import 'package:malango_pod/services/player/player_handler.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';
import 'package:malango_pod/ui/shared/text.dart';

/// [PlayerProvider] is a provider that has relation between the user and AudioService
class PlayerProvider extends LifecycleProvider {
  final MalangoDatabase malangoDb;
  AudioHandler _audioHandler;
  var _isAudioHandlerInitialised = false;
  SoundState _playingState = SoundState.none;

  /// [_playerPositionStreamSubscription] is an object that listens to [_playerPositionStreamer] and receives events from it
  StreamSubscription<int> _playerPositionStreamSubscription;

  /// Updates our current position within an episode when it is playing
  final _playerPositionStreamer =
      Stream<int>.periodic(const Duration(milliseconds: 500))
          .asBroadcastStream();
  PlayerPositionModel _playerPosition;
  var _playingFlag = false;

  /// the nowPlaying episode
  Episode _episode;

  PlayerProvider({
    @required this.malangoDb,
  }) {
    /// initializing the AudioService for PlayerProvider
    AudioService.init(
      builder: () => PlayerHandler(
        malangoDb: malangoDb,
      ),

      /// setting config of the Player
      config: const AudioServiceConfig(
        androidNotificationChannelName: malangoPodText,
        androidNotificationIcon: Assets.androidNotificationIcon,
        androidResumeOnClick: true,
        androidStopForegroundOnPause: true,
        androidNotificationOngoing: false,

        /// fastForward of player is 30 secs
        fastForwardInterval: Duration(seconds: fastForwardedPlayerSec),

        /// rewind of player is 10 secs
        rewindInterval: Duration(seconds: rewindPlayerSec),
      ),
    ).then((audioHandler) {
      _isAudioHandlerInitialised = true;
      _audioHandler = audioHandler;
      audioPlayBackStateHandling();
    });
  }

  void audioPlayBackStateHandling() {
    _audioHandler.playbackState.distinct((previousState, nowState) {
      return (previousState.processingState == nowState.processingState &&
          previousState.playing == nowState.playing);
    }).listen((PlaybackState state) {
      switch (state.processingState) {
        case AudioProcessingState.idle:
          setPlayingState(SoundState.none);
          stopPositioning();
          break;
        case AudioProcessingState.loading:
          loadingEpisode(state);
          setPlayingState(SoundState.waiting);
          break;
        case AudioProcessingState.buffering:
          setPlayingState(SoundState.waiting);
          break;
        case AudioProcessingState.ready:
          if (state.playing) {
            startPositioning();
            setPlayingState(SoundState.playing);
          } else {
            stopPositioning();
            setPlayingState(SoundState.pausing);
          }
          break;
        case AudioProcessingState.completed:
          audioPlayingCompleted();
          break;
        case AudioProcessingState.error:
          setPlayingState(SoundState.error);
          break;
      }
    });
  }

  void setPlayingState(SoundState state) {
    _playingState = state;
    notifyListeners();
  }

  SoundState get playingState => _playingState;

  /// [nowPlaying] is getter of [_episode], the episode that is playing
  Episode get nowPlaying => _episode;

  void setPlayPosition(PlayerPositionModel newPositionState) {
    _playerPosition = newPositionState;
    notifyListeners();
  }

  PlayerPositionModel get playPosition => _playerPosition;

  /// setting Episode to play with notifier
  void setPlayEpisode(Episode newPlayEpisode) {
    playEpisode(episode: newPlayEpisode);
    notifyListeners();
  }

  /// every state of player that happens we handle it by audio handler
  Future<void> setPlayerPlayingState(PlayerState state) async {
    switch (state) {
      case PlayerState.play:
        await play();
        break;
      case PlayerState.pause:
        await _audioHandler.pause();
        break;
      case PlayerState.fastForward:
        await _audioHandler.fastForward();
        break;
      case PlayerState.rewind:
        await _audioHandler.rewind();
        break;
      case PlayerState.stop:
        await audioPlayingStopped();
        break;
    }
    notifyListeners();
  }

  Future<void> play() {
    if (_playingFlag) {
      _playingFlag = false;
      return playEpisode(
        episode: _episode,
      );
    } else {
      return _audioHandler.play();
    }
  }

  Future<void> playEpisode({Episode episode}) async {
    /// for playing episode we need to check that we episode guId to play and our
    /// audio handler initialized at first
    if (episode.guId != '' && _isAudioHandlerInitialised) {
      var uri = await getEpisodePlayingUri(episode);
      log('episode uri: $uri');

      setPlayingState(SoundState.waiting);

      log('Playing episode ${episode?.id} - ${episode?.episodeTitle} from position ${episode.episodePosition}');

      episodePositionPropagation(episode);

      /// we save the current position of the episode for playing
      /// from the position we saved for the next time
      var audioProcessingState =
          _audioHandler.playbackState.value.processingState ??
              AudioProcessingState.idle;

      if (audioProcessingState == AudioProcessingState.ready) {
        await storingEpisodePlayingPositionToDatabase();
      } else if (audioProcessingState == AudioProcessingState.loading) {
        _audioHandler.stop();
      }

      /// out current episode position is stored. now we put the episode that we passed to the method, to the current episode.
      _episode = episode;

      await malangoDb.saveEpisode(_episode);

      try {
        await _audioHandler
            .playMediaItem(convertingEpisodeToMediaItem(_episode, uri));
        _episode.episodeDuration =
            _audioHandler.mediaItem.value.duration.inSeconds;

        await malangoDb.saveEpisode(_episode);
      } catch (e) {
        log('Error throw episode playback ${e.toString()}');
        setPlayingState(SoundState.error);
        setPlayingState(SoundState.stopped);
        await _audioHandler.stop();
      }
    } else {
      log('Error is episode is empty or AudioHandler is not Initialised and we can not play it');
    }
  }

  /// when we want to play an episode we have 2 situations
  /// one of them is that we have downloaded it before and we need to play
  /// from downloaded path and another way is that we have not
  /// downloaded it before and we want to stream it from network
  Future<String> getEpisodePlayingUri(Episode episode) async {
    var uri = '';

    if (episode.episodeDownloadState == DownloadState.downloaded) {
      if (await storagePermission()) {
        uri = await getPath(episode);
      } else {
        throw Exception('Insufficient storage permissions');
      }
    } else {
      uri = episode.episodeLink;
    }

    return uri;
  }

  void episodePositionPropagation(Episode episode) {
    if (episode != null) {
      var episodeDurationInSeconds = Duration(seconds: episode.episodeDuration);
      var episodeTimeCompletedInSeconds = episode.episodePosition > 0
          ? (episodeDurationInSeconds.inSeconds / episode.episodePosition) * 100
          : 0;

      setPlayPosition(PlayerPositionModel(
          Duration(milliseconds: episode.episodePosition),
          episodeDurationInSeconds,
          episodeTimeCompletedInSeconds.toInt(),
          episode,
          false));
    }
  }

  /// we save the current position of the episode for playing
  /// from the position we saved for the next time
  Future<void> storingEpisodePlayingPositionToDatabase(
      {bool complete = false}) async {
    if (_episode != null) {
      ///finding that position from db for changing
      _episode = await malangoDb.findEpisodeByGuid(_episode.guId);

      var currentPosition =
          _audioHandler.playbackState.value.position.inMilliseconds ?? 0;

      if (currentPosition != _episode.episodePosition) {
        _episode.episodePosition = complete ? 0 : currentPosition;
        _episode = await malangoDb.saveEpisode(_episode);
      }
    } else {
      log('couldn\'t save the episode position because _episode is null');
    }
  }

  MediaItem convertingEpisodeToMediaItem(Episode episode, String uri) {
    return MediaItem(
      id: uri,
      artUri: Uri.parse(episode.episodeImageLink),
      title: episode.episodeTitle ?? unknownTitleText,
      artist: episode.narrator ?? unknownTitleText,
      duration: Duration(seconds: episode.episodeDuration ?? 0),
      extras: <String, dynamic>{
        'eid': episode.guId,
        'position': episode.episodePosition ?? 0,
        'downloaded': episode.isEpisodeDownloaded,
        'speed': speedOfPlayer,
        'boost': false,
        'trim': false,
      },
    );
  }

  /// setting position seek to changing the UI
  void setPositionSeek(double position) async {
    await positionSeek(position: position.ceil());
    notifyListeners();
  }

  Future<void> positionSeek({int position}) async {
    var duration =
        _audioHandler.mediaItem.value?.duration ?? const Duration(seconds: 1);
    var positionDurationInSeconds = Duration(seconds: position);
    var complete = positionDurationInSeconds.inSeconds > 0
        ? (duration.inSeconds / positionDurationInSeconds.inSeconds) * 100
        : 0;

    /// we pause the _playerPositionStreamSubscription not to have  UI Jumping.
    _playerPositionStreamSubscription?.pause();

    setPlayPosition(PlayerPositionModel(
        positionDurationInSeconds, duration, complete.toInt(), _episode, true));

    await _audioHandler.seek(Duration(seconds: position));

    _playerPositionStreamSubscription?.resume();
  }

  Future<void> updatePosition() async {
    var playbackState = _audioHandler?.playbackState?.value;

    if (playbackState != null) {
      var currentMediaItem = _audioHandler.mediaItem.value;
      var duration = currentMediaItem?.duration ?? const Duration(seconds: 1);
      var position = playbackState.position;
      var complete = position.inSeconds > 0
          ? (duration.inSeconds / position.inSeconds) * 100
          : 0;
      var buffering =
          playbackState.processingState == AudioProcessingState.buffering;

      setPlayPosition(PlayerPositionModel(
          position, duration, complete.toInt(), _episode, buffering));
    }
  }

  ///  when the player starts to play everytime that we get an event from
  ///  the stream we check the episode in audio service and after that we push
  ///  the information to inform our listeners
  void startPositioning() async {
    if (_playerPositionStreamSubscription == null) {
      _playerPositionStreamSubscription =
          _playerPositionStreamer.listen((int period) async {
        await updatePosition();
      });
    } else if (_playerPositionStreamSubscription.isPaused) {
      _playerPositionStreamSubscription.resume();
    }
  }

  void stopPositioning() async {
    if (_playerPositionStreamSubscription != null) {
      await _playerPositionStreamSubscription.cancel();

      _playerPositionStreamSubscription = null;
    }
  }

  Future<void> backgroundPlayerState() async {
    var episodeCurrentPosition =
        _audioHandler?.playbackState?.value?.position?.inMilliseconds ?? 0;

    /// We just need to check the pausing state
    if (_playingState == SoundState.pausing) {
      await pauseBackgroundPlayerState(BackgroundPlayer(
        backgroundEpisodeId: _episode.id,
        backgroundPosition: episodeCurrentPosition,
        backgroundPlayingState: EpisodePlayingState.paused,
      ));
    }
  }

  Future<void> lifecyclePauseListening() async {
    stopPositioning();
    backgroundPlayerState();
  }

  @override
  void lifecyclePauseListener() async {
    log('PlayerProvider lifecycle pause');
    await lifecyclePauseListening();
  }

  @override
  void lifecycleResumeListener() async {
    log('Sound lifecycle resume');
    var episode = await resumeEpisode();

    if (episode != null) {
      log('Resuming with episode ${episode?.episodeTitle} - ${episode?.episodePosition}');
    } else {
      log('episode is null for resuming');
    }
  }

  Future<Episode> resumeEpisode() async {
    if (_audioHandler != null) {
      /// If [_episode] is null, we must  stop it until the episode will be active or will be killed
      if (_episode == null) {
        if (_audioHandler?.mediaItem?.value != null) {
          final extras = _audioHandler.mediaItem.value.extras;

          if (extras['eid'] != null) {
            _episode =
                await malangoDb.findEpisodeByGuid(extras['eid'] as String);
          }
        } else {
          var backgroundPlaying = await getBackgroundPlayerState();

          if (backgroundPlaying != null &&
              backgroundPlaying.backgroundPlayingState ==
                  EpisodePlayingState.paused) {
            _episode = await malangoDb
                .findEpisodeById(backgroundPlaying.backgroundEpisodeId);
            _episode.episodePosition = backgroundPlaying.backgroundPosition;
            setPlayingState(SoundState.pausing);

            updateEpisodeCurrentPosition(_episode);

            _playingFlag = true;
          }
        }
      } else {
        final playbackState = _audioHandler.playbackState.value;
        final processingState =
            playbackState?.processingState ?? AudioProcessingState.idle;

        if (processingState == AudioProcessingState.idle) {
          /// We will have to assume we have stopped.
          setPlayingState(SoundState.stopped);
        } else if (processingState == AudioProcessingState.ready) {
          startPositioning();
        }
      }

      await clearBackgroundPlayerState();

      return Future.value(_episode);
    }

    return Future.value(null);
  }

  void updateEpisodeCurrentPosition(Episode episode) {
    if (episode != null) {
      var episodeDurationInSeconds = Duration(seconds: episode.episodeDuration);
      var episodeCompleteInSeconds = episode.episodePosition > 0
          ? (episodeDurationInSeconds.inSeconds / episode.episodePosition) * 100
          : 0;

      setPlayPosition(PlayerPositionModel(
          Duration(milliseconds: episode.episodePosition),
          episodeDurationInSeconds,
          episodeCompleteInSeconds.toInt(),
          episode,
          false));
    }
  }

  void loadingEpisode(PlaybackState state) async {
    if (_episode == null) {
      log('loadingEpisode: episode is null and we can\'t load it!');
      return;
    }

    await updatePosition();
  }

  Future<void> audioPlayingCompleted() async {
    await storingEpisodePlayingPositionToDatabase(complete: true);

    log('${_episode?.episodeTitle} episode is completed in playing');

    stopPositioning();
  }

  Future<void> audioPlayingStopped() {
    _episode = null;
    return _audioHandler.stop();
  }
}
