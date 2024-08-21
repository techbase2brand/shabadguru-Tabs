// ignore_for_file: must_be_immutable, depend_on_referenced_packages

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

class MiniMusicPlayer extends StatefulWidget {
  const MiniMusicPlayer({super.key});

  @override
  State<MiniMusicPlayer> createState() => _MiniMusicPlayerState();
}

class _MiniMusicPlayerState extends State<MiniMusicPlayer>
    with AutoCancelStreamMixin {
  bool playerLoading = false;
  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver(['actionMusicPlaying']).listen(
      (intent) {
        switch (intent.action) {
          case 'actionMusicPlaying':
            setState(() {});
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('Dismissile$dismissedId'),
      onDismissed: (direction) {
        dismissedId = dismissedId + 1;
        if (audioHandler != null) {
          audioHandler!.pause();
          audioHandler!.stop();
          audioHandler = null;
        }
        playingLyricModel = null;
        playingEnglishLyrics = '';
        playingNormalLyrics = '';
        playingTranslationLyrics = '';
        sendBroadcast('actionMusicPlaying');
      },
      direction: DismissDirection.horizontal,
      child: GestureDetector(
        onTap: () {
          goToMusicPlayerPage(context, playingShabadData!, playingTitle ?? '',
              playingListOfShabad!);
        },
        child: Container(
          width: widthOfScreen,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0XFFFFF8EA),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0XFFB57F12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    playingTitle!.isEmpty ? 'S' : playingTitle?[0] ?? 'S',
                    style: TextStyle(
                        fontFamily: poppinsBold,
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        return Text(
                          playingTitle ?? '',
                          style: TextStyle(
                              color: darkBlueColor,
                              fontFamily: poppinsBold,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                    Builder(builder: (context) {
                      return Text(
                        playingSubtitle ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: secondPrimaryColor,
                            fontFamily: poppinsBold,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      );
                    }),
                  ],
                ),
              ),
              StreamBuilder<bool>(
                stream: audioHandler!.playbackState
                    .map((state) => state.playing)
                    .distinct(),
                builder: (context, snapshot) {
                  final playing = snapshot.data ?? false;
                  return InkWell(
                    onTap: () {
                      if (playing) {
                        audioHandler!.pause();
                      } else {
                        audioHandler!.play();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Icon(
                        playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: secondPrimaryColor,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  if (!isMusicPlayerPageOpen) {
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
                  Icons.skip_next_rounded,
                  color: secondPrimaryColor,
                  size: 42,
                ),
              ),
              StreamBuilder<MediaState>(
                stream: mediaStateStream,
                builder: (context, snapshot) {
                  if (!isMusicPlayerPageOpen) {
                    final mediaState = snapshot.data;
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
                  return const IgnorePointer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initPlayer() async {
    if (audioHandler == null) {
      List<MediaItem> mediaItems = [];

      final player = AudioPlayer();
      var duration = await player.setUrl(playingShabadData!.audio ?? '');
      mediaItems = [];

      mediaItems.add(
        MediaItem(
          id: playingShabadData!.audio ?? '',
          album: playingShabadData!.albumart ?? '',
          title: playingTitle ?? '',
          artist: playingShabadData!.song ?? '',
          duration: duration ?? const Duration(milliseconds: 100000),
          artUri: Uri.parse(''),
        ),
      );
      audioHandler = await AudioService.init(
        cacheManager: null,
        builder: () => AudioPlayerHandler(
          autoPlay: true,
          fromLocal: true,
          items: mediaItems,
        ),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
          androidNotificationChannelName: 'Audio playback',
          androidNotificationOngoing: true,
        ),
      );
      playerLoading = false;
      setState(() {});
      sendBroadcast('actionMusicPlaying');
    }
  }
}
