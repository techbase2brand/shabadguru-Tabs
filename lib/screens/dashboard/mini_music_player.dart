// ignore_for_file: must_be_immutable, depend_on_referenced_packages

// Mini music player widget for dashboard with play/pause and skip controls
import 'package:action_broadcast/action_broadcast.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shabadguru/audio_service/audio_player_handler.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

// Mini music player widget with dismissible functionality and playback controls
class MiniMusicPlayer extends StatefulWidget {
  const MiniMusicPlayer({super.key});

  @override
  State<MiniMusicPlayer> createState() => _MiniMusicPlayerState();
}

// Mini music player state with broadcast handling
class _MiniMusicPlayerState extends State<MiniMusicPlayer>
    with AutoCancelStreamMixin {
  bool playerLoading = false; // Loading state for player operations
  // Register for music player state changes
  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver(['actionMusicPlaying']).listen(
      (intent) {
        switch (intent.action) {
          case 'actionMusicPlaying':
            setState(() {}); // Update UI when music state changes
            break;
        }
      },
    );
  }

  // Build the mini music player UI
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('Dismissile$dismissedId'), // Unique key for dismissible
      onDismissed: (direction) {
        dismissedId = dismissedId + 1; // Increment dismissed ID
        // Stop and clear audio handler
        if (audioHandler != null) {
          audioHandler!.pause();
          audioHandler!.stop();
          audioHandler = null;
        }
        // Clear playing data
        playingLyricModel = null;
        playingEnglishLyrics = '';
        playingNormalLyrics = '';
        playingTranslationLyrics = '';
        sendBroadcast('actionMusicPlaying'); // Broadcast state change
      },
      direction: DismissDirection.horizontal, // Allow horizontal dismiss
      child: GestureDetector(
        onTap: () {
          // Navigate to full music player page
          goToMusicPlayerPage(context, playingShabadData!, playingTitle ?? '',
              playingListOfShabad!);
        },
        child: Container(
          width: widthOfScreen, // Full screen width
          height: 70, // Fixed height
          padding: const EdgeInsets.symmetric(horizontal: 20), // Horizontal padding
          decoration: const BoxDecoration(
            color: Color(0XFFFFF8EA), // Light background color
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Song initial icon container
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0XFFB57F12), // Gold background
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    playingTitle!.isEmpty ? 'S' : playingTitle?[0] ?? 'S', // Song initial or 'S'
                    style: TextStyle(
                        fontFamily: poppinsBold,
                        color: Colors.white, // White text
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                width: 10, // Spacing between icon and text
              ),
              // Song title and subtitle section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        return Text(
                          playingTitle ?? '', // Song title
                          style: TextStyle(
                              color: darkBlueColor, // Dark blue color
                              fontFamily: poppinsBold,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                    Builder(builder: (context) {
                      return Text(
                        playingSubtitle ?? '', // Song subtitle
                        maxLines: 1, // Single line
                        overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                        style: TextStyle(
                            color: secondPrimaryColor, // Secondary color
                            fontFamily: poppinsBold,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      );
                    }),
                  ],
                ),
              ),
              // Play/Pause button with stream builder
              StreamBuilder<bool>(
                stream: audioHandler!.playbackState
                    .map((state) => state.playing) // Get playing state
                    .distinct(), // Only emit when state changes
                builder: (context, snapshot) {
                  final playing = snapshot.data ?? false; // Get current playing state
                  return InkWell(
                    onTap: () {
                      if (playing) {
                        audioHandler!.pause(); // Pause if playing
                      } else {
                        audioHandler!.play(); // Play if paused
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 8, right: 8), // Button padding
                      child: Icon(
                        playing
                            ? Icons.pause_rounded // Pause icon when playing
                            : Icons.play_arrow_rounded, // Play icon when paused
                        color: secondPrimaryColor, // Icon color
                        size: 40, // Icon size
                      ),
                    ),
                  );
                },
              ),
              // Skip to next button
              GestureDetector(
                onTap: () {
                  if (!isMusicPlayerPageOpen) { // Check if music player page is not open
                    if (!playerLoading) { // Check if not already loading
                      playerLoading = true; // Set loading state
                      //   if (audioHandler != null) {
                      //     audioHandler!.pause();
                      //     audioHandler!.stop();
                      //     audioHandler = null;
                      playingLyricModel = null;
                      playingEnglishLyrics = '';
                      playingNormalLyrics = '';
                      playingTranslationLyrics = '';

                      // if (shuffleOn) {
                      //   if (getRandomNumberFromList() <
                      //       playingListOfShabad!.length) {
                      //     playingShabadData = playingListOfShabad![ getRandomNumberFromList()];
                      //     playingSubtitle = playingShabadData!.song ?? '';
                      //     initPlayer();
                      //   }
                      // } else {
                      int indexOfPlayingShabad = playingListOfShabad!
                          .indexWhere(
                              (element) => element == playingShabadData);

                      if (indexOfPlayingShabad + 1 <
                          playingListOfShabad!.length) {
                        playingShabadData =
                            playingListOfShabad![indexOfPlayingShabad + 1];
                        playingSubtitle = playingShabadData!.song ?? '';
                        audioHandler!.skipToNext();

                        playerLoading = false;
                        // setState(() {});
                        sendBroadcast('actionMusicPlaying');

                        final player = AudioPlayer();
                        player
                            .setUrl(playingShabadData!.audio ?? '')
                            .then((duration) {
                          final item = MediaItem(
                            id: playingShabadData!.audio ?? '',
                            album: playingShabadData!.albumart ?? '',
                            title: playingTitle ?? '',
                            artist: playingShabadData!.song ?? '',
                            duration: duration,
                            artUri: Uri.parse(''),
                          );

                          audioPlayerHandler.mediaItem.add(item);
                        });

                        // initPlayer();
                        //   }
                        // }
                      }
                    }
                  }
                },
                child: const Icon(
                  Icons.skip_next_rounded, // Skip next icon
                  color: secondPrimaryColor, // Icon color
                  size: 42, // Icon size
                ),
              ),
              // Media state stream builder for auto-play next track
              StreamBuilder<MediaState>(
                stream: mediaStateStream, // Listen to media state changes
                builder: (context, snapshot) {
                  if (!isMusicPlayerPageOpen) { // Check if music player page is not open
                    final mediaState = snapshot.data; // Get current media state
                    if (mediaState?.mediaItem?.duration != null) {
                      if (mediaState?.position != null) {
                        int totalSeconds =
                            mediaState?.mediaItem?.duration!.inSeconds ?? 0;
                        int runningSeconds =
                            mediaState?.position.inSeconds ?? 0;
                        if (totalSeconds > 0) {
                          if (runningSeconds > 0) {
                            if (totalSeconds == runningSeconds) {
                              if (!playerLoading) {
                                playerLoading = true;
                                //   if (audioHandler != null) {
                                //     audioHandler!.pause();
                                //     audioHandler!.stop();
                                //     audioHandler = null;
                                playingLyricModel = null;
                                playingEnglishLyrics = '';
                                playingNormalLyrics = '';
                                playingTranslationLyrics = '';

                                // if (shuffleOn) {
                                //   if (getRandomNumberFromList() <
                                //       playingListOfShabad!.length) {
                                //     playingShabadData = playingListOfShabad![ getRandomNumberFromList()];
                                //     playingSubtitle = playingShabadData!.song ?? '';
                                //     initPlayer();
                                //   }
                                // } else {
                                int indexOfPlayingShabad = playingListOfShabad!
                                    .indexWhere((element) =>
                                        element == playingShabadData);

                                if (indexOfPlayingShabad + 1 <
                                    playingListOfShabad!.length) {
                                  playingShabadData = playingListOfShabad![
                                      indexOfPlayingShabad + 1];
                                  playingSubtitle =
                                      playingShabadData!.song ?? '';
                                  audioHandler!.skipToNext();

                                  playerLoading = false;
                                  // setState(() {});
                                  sendBroadcast('actionMusicPlaying');

                                  final player = AudioPlayer();
                                  player
                                      .setUrl(playingShabadData!.audio ?? '')
                                      .then((duration) {
                                    final item = MediaItem(
                                      id: playingShabadData!.audio ?? '',
                                      album: playingShabadData!.albumart ?? '',
                                      title: playingTitle ?? '',
                                      artist: playingShabadData!.song ?? '',
                                      duration: duration,
                                      artUri: Uri.parse(''),
                                    );

                                    audioPlayerHandler.mediaItem.add(item);
                                  });

                                  // initPlayer();
                                  //   }
                                  // }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                  return const IgnorePointer(); // Ignore pointer for this widget
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Initialize audio player with media items
  Future<void> initPlayer() async {
    if (audioHandler == null) { // Check if audio handler is not initialized
      List<MediaItem> mediaItems = []; // List to store media items

      final player = AudioPlayer(); // Create audio player instance
      var duration = await player.setUrl(playingShabadData!.audio ?? ''); // Get audio duration
      mediaItems = []; // Initialize media items list

      // Add current playing item to media items
      mediaItems.add(
        MediaItem(
          id: playingShabadData!.audio ?? '', // Audio URL as ID
          album: playingShabadData!.albumart ?? '', // Album art URL
          title: playingTitle ?? '', // Song title
          artist: playingShabadData!.song ?? '', // Artist name
          duration: duration ?? const Duration(milliseconds: 100000), // Audio duration
          artUri: Uri.parse(''), // Empty art URI
        ),
      );
      // Initialize audio service
      audioHandler = await AudioService.init(
        cacheManager: null, // No cache manager
        builder: () => AudioPlayerHandler(
          autoPlay: true, // Auto play when initialized
          fromLocal: true, // Play from local source
          items: mediaItems, // Media items list
        ),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio', // Notification channel ID
          androidNotificationChannelName: 'Audio playback', // Notification channel name
          androidNotificationOngoing: true, // Ongoing notification
        ),
      );
      playerLoading = false; // Set loading to false
      setState(() {}); // Update UI
      sendBroadcast('actionMusicPlaying'); // Broadcast state change
    }
  }
}
