import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  AudioPlayerHandler({
    required List<MediaItem> items,
    required bool fromLocal,
    required bool autoPlay,
  }) {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    final List<UriAudioSource> playlist = [];
    mediaItem.add(items[0]);

    for (var element in items) {
      playlist.add(AudioSource.uri(Uri.parse(element.id)));
    }
    // if (fromLocal) {
    //   _player.setFilePath(items[0].id);
    // } else {

    _player.setAudioSource(ConcatenatingAudioSource(
      children:
          playlist.map((source) => ClippingAudioSource(child: source)).toList(),
    ));

    // _player.setAudioSource(AudioSource.uri(Uri.parse(items[0].id)));
    // }
    // _player.setAsset(items[0].id);
    if (autoPlay) {
      _player.play();
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

   @override
  Future<void> onTaskRemoved() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
