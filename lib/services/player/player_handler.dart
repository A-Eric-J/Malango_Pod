import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/services/database/database.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';

/// [PlayerHandler] has relation between audio_service package and the player
/// and this handler is based on
/// this link: https://github.com/ryanheise/audio_service/blob/master/audio_service/example/lib/main.dart
/// please read the audio_service document completely about this handler
class PlayerHandler extends BaseAudioHandler with SeekHandler {
  final MalangoDatabase malangoDb;
  AndroidLoudnessEnhancer androidLoudnessEnhancer;
  AudioPipeline audioPipeline;
  AudioPlayer player;

  PlayerHandler({
    @required this.malangoDb,
  }) {
    /// setting up for Android
    if (Platform.isAndroid) {
      androidLoudnessEnhancer = AndroidLoudnessEnhancer();
      androidLoudnessEnhancer.setEnabled(true);
      audioPipeline =
          AudioPipeline(androidAudioEffects: [androidLoudnessEnhancer]);
      player = AudioPlayer(audioPipeline: audioPipeline);
    } else {
      /// setting up for iOS
      player = AudioPlayer(
          userAgent: '',
          audioLoadConfiguration: AudioLoadConfiguration(
            androidLoadControl: AndroidLoadControl(
              backBufferDuration: const Duration(seconds: 45),
            ),
            darwinLoadControl: DarwinLoadControl(),
          ));
    }

    /// here we set up our audio handler to broadcast all
    /// playback state changes as they happen via playbackState...
    player.playbackEventStream
        .map(_transformEvent)
        .pipe(playbackState)
        .catchError((Object o, StackTrace s) async {
      await player.stop();
    });

    player.currentIndexStream.listen((int index) {});
  }

  @override
  Future<void> play() async {
    await player.play();
  }

  @override
  Future<void> pause() async {
    await saveEpisodePosition();
    await player.pause();
  }

  @override
  Future<void> stop() async {
    await player.stop();
    await saveEpisodePosition();
  }

  @override
  Future<void> fastForward() async {
    var forwardPosition = player.position?.inMilliseconds ?? 0;

    /// fastForward in MilliSeconds => 30000
    await player.seek(Duration(milliseconds: forwardPosition + 30000));
  }

  @override
  Future<void> seek(Duration position) async {
    return player.seek(position);
  }

  @override
  Future<void> rewind() async {
    var rewindPosition = player.position?.inMilliseconds ?? 0;

    if (rewindPosition > 0) {
      /// rewind in milliSeconds =>  10001
      rewindPosition -= 10001;

      if (rewindPosition < 0) {
        rewindPosition = 0;
      }

      await player.seek(Duration(milliseconds: rewindPosition));
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    if (player.processingState == ProcessingState.completed) {
      processingStateIsCompleted();
    }

    return PlaybackState(
      controls: [
        const MediaControl(
          androidIcon: Assets.androidRewindIcon,
          label: rewind_,
          action: MediaAction.rewind,
        ),
        if (player.playing) MediaControl.pause else MediaControl.play,
        const MediaControl(
          androidIcon: Assets.androidFastForwardIcon,
          label: fastForward_,
          action: MediaAction.fastForward,
        ),
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState],
      playing: player.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      queueIndex: event.currentIndex,
    );
  }

  Future<void> processingStateIsCompleted() async {
    await player.stop();
    await saveEpisodePosition(isCompleted: true);
  }

  MediaItem currentMediaItem;

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    currentMediaItem = mediaItem;

    var episodePosition = currentMediaItem.extras['position'] as int ?? 0;
    var isEpisodeDownloaded =
        currentMediaItem.extras['downloaded'] as bool ?? true;
    var episodeBoost = currentMediaItem.extras['boost'] as bool ?? true;
    var startPosition = episodePosition > 0
        ? Duration(milliseconds: episodePosition)
        : Duration.zero;

    /// we check that is the episode downloaded or not to get its source
    var audioSource = isEpisodeDownloaded
        ? AudioSource.uri(
            Uri.parse(audioSourceDownloadedFile(currentMediaItem.id)),
            tag: currentMediaItem.id,
          )
        : AudioSource.uri(Uri.parse(currentMediaItem.id),
            headers: <String, String>{
              userAgent: '',
            },
            tag: currentMediaItem.id);

    try {
      var duration = await player.setAudioSource(audioSource,
          initialPosition: startPosition);

      /// (_currentItem.duration.inSeconds == 0 || _currentItem.duration == null) this condition means that we do not
      /// have a duration and we can create and update the _currentItem
      if (duration != null &&
          (currentMediaItem.duration.inSeconds == 0 ||
              currentMediaItem.duration == null)) {
        currentMediaItem = currentMediaItem.copyWith(duration: duration);
      }

      if (player.processingState != ProcessingState.idle) {
        try {
          if (Platform.isAndroid) {
            /// _player.setSkipSilenceEnabled(false) calling will disable silence skipping in the audio player.
            /// When skipSilenceEnabled is false, the audio player will not skip over any periods of silence in the audio file during playback.
            /// This can be useful in situations where the silence is an intentional part of the audio, such as in a musical performance or a spoken word recording with natural pauses.
            if (player.skipSilenceEnabled) {
              await player.setSkipSilenceEnabled(false);
            }

            var androidAudioEffect = audioPipeline.androidAudioEffects[0];

            if (androidAudioEffect is AndroidLoudnessEnhancer) {
              androidAudioEffect.setTargetGain(episodeBoost ? 0.8 : 0.0);
            }
          }

          player.play();
        } catch (e) {
          log('Player_handler Error: ${e.toString()}');
        }
      }
    } on PlayerInterruptedException catch (e) {
      await stop();
      log('PlayerInterruptedException: $e');
    } on PlayerException catch (e) {
      await stop();
      log('PlayerException: $e');
    } catch (e) {
      await stop();
      log('playMediaItem: $e');
    }

    super.mediaItem.add(currentMediaItem);
  }

  /// Note that we save the episode position when the episode is paused and after
  /// that it is stopped
  Future<void> saveEpisodePosition({bool isCompleted = false}) async {
    if (currentMediaItem != null) {
      var databaseStoredEpisode = await malangoDb
          .findEpisodeByGuid(currentMediaItem.extras['eid'] as String);
      var episodeCurrentPosition =
          playbackState.value.position.inMilliseconds ?? 0;

      /// when the episode is Completed we should note that
      /// when we are storing new state of the episode we should change
      /// episode position to zero before storing to able it starts at first when
      /// we want to play it again later
      if (isCompleted) {
        databaseStoredEpisode.episodePosition = 0;
        await malangoDb.saveEpisode(databaseStoredEpisode);
      } else if (episodeCurrentPosition !=
          databaseStoredEpisode.episodePosition) {
        databaseStoredEpisode.episodePosition = episodeCurrentPosition;

        await malangoDb.saveEpisode(databaseStoredEpisode);
      }
    } else {
      log('Player_handler: Can\'t save position because episode is null');
    }
  }
}
