// Global audio service configuration and state management
// ignore_for_file: depend_on_referenced_packages

import 'package:audio_service/audio_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shabadguru/audio_service/audio_player_handler.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/music_player/music_player_controller.dart';

// Global audio handler instance for managing music playback
AudioHandler? audioHandler;

// Current playing track information
String? playingTitle = ''; // Current track title
String? playingSubtitle = ''; // Current track subtitle
List<ShabadData>? playingListOfShabad; // Current playlist of Shabads
ShabadData? playingShabadData; // Currently playing Shabad data
LyricsReaderModel? playingLyricModel; // Current lyrics model

// Lyrics in different languages
String playingNormalLyrics = ''; // Normal lyrics (Gurmukhi)
String playingEnglishLyrics = ''; // English translation lyrics
String playingTranslationLyrics = ''; // Translation lyrics

String playingSpanishLyrics = ''; // Spanish translation lyrics
String playingHindiLyrics = ''; // Hindi translation lyrics

// UI and playback state management
int dismissedId = 0; // ID for dismissed mini player
bool shuffleOn = false; // Shuffle mode state
bool isMusicPlayerPageOpen = false; // Whether music player page is currently open
MusicPlayerController? musicPlayerController; // Music player controller instance
RemoteMessage? remoteMessageGlobal; // Global Firebase message for notifications



// Audio player handler instance (initialized later)
late AudioPlayerHandler audioPlayerHandler;

/// A stream reporting the combined state of the current media item and its
/// current position.
/// This stream combines the current media item with its playback position
/// to provide real-time updates about what's playing and where in the track.
Stream<MediaState>? get mediaStateStream => audioHandler!=null?
    Rx.combineLatest2<MediaItem?, Duration, MediaState>(
        audioHandler!.mediaItem, // Current media item stream
        AudioService.position, // Current position stream
        (mediaItem, position) => MediaState(mediaItem, position)):null; // Combine into MediaState

// Class representing the combined state of media item and position
class MediaState {
  final MediaItem? mediaItem; // Current media item being played
  final Duration position; // Current playback position

  MediaState(this.mediaItem, this.position);
}
