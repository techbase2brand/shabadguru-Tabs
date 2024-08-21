// ignore_for_file: depend_on_referenced_packages

import 'package:audio_service/audio_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shabadguru/audio_service/audio_player_handler.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/music_player/music_player_controller.dart';

AudioHandler? audioHandler;
String? playingTitle = '';
String? playingSubtitle = '';
List<ShabadData>? playingListOfShabad;
ShabadData? playingShabadData;
LyricsReaderModel? playingLyricModel;

String playingNormalLyrics = '';
String playingEnglishLyrics = '';
String playingTranslationLyrics = '';

String playingSpanishLyrics = '';
String playingHindiLyrics = '';

int dismissedId = 0;
bool shuffleOn = false;
bool isMusicPlayerPageOpen = false;
MusicPlayerController? musicPlayerController;
RemoteMessage? remoteMessageGlobal;



late AudioPlayerHandler audioPlayerHandler;

/// A stream reporting the combined state of the current media item and its
/// current position.
Stream<MediaState>? get mediaStateStream => audioHandler!=null?
    Rx.combineLatest2<MediaItem?, Duration, MediaState>(
        audioHandler!.mediaItem,
        AudioService.position,
        (mediaItem, position) => MediaState(mediaItem, position)):null;

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}
