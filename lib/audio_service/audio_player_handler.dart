// Audio player handler for managing music playback with audio service integration
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Audio handler for playing Shabad music with playlist support and media controls
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer(); // Just audio player instance

  // Constructor for initializing audio player with playlist
  AudioPlayerHandler({
    required List<MediaItem> items, // List of media items to play
    required bool fromLocal, // Whether audio is from local storage (currently unused)
    required bool autoPlay, // Whether to start playing automatically
  }) {
    // Transform just_audio events to audio_service playback state
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    final List<UriAudioSource> playlist = []; // Create empty playlist
    mediaItem.add(items[0]); // Set first item as current media item

    // Build playlist from media items
    for (var element in items) {
      playlist.add(AudioSource.uri(Uri.parse(element.id))); // Add each item to playlist
    }
    // Local file support (currently commented out)
    // if (fromLocal) {
    //   _player.setFilePath(items[0].id);
    // } else {

    // Set concatenated audio source with clipping support
    _player.setAudioSource(ConcatenatingAudioSource(
      children:
          playlist.map((source) => ClippingAudioSource(child: source)).toList(), // Wrap each source with clipping
    ));

    // Alternative audio source methods (commented out)
    // _player.setAudioSource(AudioSource.uri(Uri.parse(items[0].id)));
    // }
    // _player.setAsset(items[0].id);
    
    // Auto play if requested
    if (autoPlay) {
      _player.play(); // Start playback immediately
    }
  }

  // Play audio
  @override
  Future<void> play() => _player.play();

  // Pause audio playback
  @override
  Future<void> pause() => _player.pause();

  // Seek to specific position in audio
  @override
  Future<void> seek(Duration position) => _player.seek(position);

  // Stop audio playback
  @override
  Future<void> stop() => _player.stop();

  // Skip to next track in playlist
  @override
  Future<void> skipToNext() => _player.seekToNext();

  // Skip to previous track in playlist
  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  // Set playback speed
  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  // Handle task removal (when app is removed from recent apps)
  @override
  Future<void> onTaskRemoved() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      // Media controls for notification and lock screen
      controls: [
        MediaControl.rewind, // Rewind button
        if (_player.playing) MediaControl.pause else MediaControl.play, // Play/pause button based on current state
        MediaControl.stop, // Stop button
        MediaControl.fastForward, // Fast forward button
      ],
      // System actions available
      systemActions: const {
        MediaAction.seek, // Seek action
        MediaAction.seekForward, // Seek forward action
        MediaAction.seekBackward, // Seek backward action
      },
      // Android compact action indices for notification
      androidCompactActionIndices: const [0, 1, 3], // Show rewind, play/pause, and fast forward
      // Map just_audio processing states to audio_service states
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle, // No audio loaded
        ProcessingState.loading: AudioProcessingState.loading, // Loading audio
        ProcessingState.buffering: AudioProcessingState.buffering, // Buffering audio
        ProcessingState.ready: AudioProcessingState.ready, // Ready to play
        ProcessingState.completed: AudioProcessingState.completed, // Playback completed
      }[_player.processingState]!, // Get current processing state
      playing: _player.playing, // Current playing state
      updatePosition: _player.position, // Current playback position
      bufferedPosition: _player.bufferedPosition, // Buffered position
      speed: _player.speed, // Current playback speed
      queueIndex: event.currentIndex, // Current track index in queue
    );
  }
}
