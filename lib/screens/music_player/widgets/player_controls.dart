// ignore_for_file: deprecated_member_use

import 'package:action_broadcast/action_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/music_player/music_player_controller.dart';
import 'package:shabadguru/screens/music_player/widgets/music_player_seek_bar.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

class PlayerControls extends StatefulWidget {
  const PlayerControls(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.listOfShabads,
      required this.shabadData});

  final String title;
  final String subTitle;
  final List<ShabadData> listOfShabads;
  final ShabadData shabadData;

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  @override
  void initState() {
    super.initState();
    playingTitle = widget.title;
    playingSubtitle = widget.subTitle;
    playingShabadData = widget.shabadData;
    playingListOfShabad = widget.listOfShabads;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<MusicPlayerController>(
      builder: (controller) {
        return Column(
          children: [
            SizedBox(
              width: widthOfScreen,
              child: const MusicPlayerSeekBar(),
            ),
            StreamBuilder<MediaState>(
              stream: mediaStateStream,
              builder: (context, snapshot) {
                Duration? progressDuration;
                Duration? totalDuration;
                final mediaState = snapshot.data;

                if (mediaState?.mediaItem?.duration != null) {
                  if (mediaState?.position != null) {
                    progressDuration = mediaState?.position;
                    totalDuration = mediaState?.mediaItem?.duration!;
                  }
                }


              if (progressDuration != null && totalDuration != null) {
                if (progressDuration.inMilliseconds > totalDuration.inMilliseconds) {
                  progressDuration = totalDuration;
                }
              }
                return Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(progressDuration),
                        style: TextStyle(
                          fontSize: 15,
                          color: themeProvider.darkTheme
                              ? Colors.white
                              : Colors.black,
                          fontFamily: poppinsRegular,
                        ),
                      ),
                      Text(
                        _formatDuration(totalDuration),
                        style: TextStyle(
                          fontSize: 15,
                          color: themeProvider.darkTheme
                              ? Colors.white
                              : Colors.black,
                          fontFamily: poppinsRegular,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Duration duration = const Duration(seconds: 0);
                          audioHandler!.seek(duration);
                        },
                        icon: SvgPicture.asset(
                          refreshSvg,
                          color: themeProvider.darkTheme ? Colors.white : null,
                        ),
                      ),
                      StreamBuilder<MediaState>(
                        stream: mediaStateStream,
                        builder: (context, snapshot) {
                          return IconButton(
                            onPressed: () {
                              if (widget.listOfShabads.length > 1) {
                                int playingIndex = widget
                                      .listOfShabads
                                      .indexWhere((element) =>
                                          element == widget.shabadData);
                                          if(playingIndex < widget.listOfShabads.length && playingIndex>0){
                                audioHandler!.pause();
                                audioHandler!.stop();
                                audioHandler = null;
                                playingLyricModel = null;
                                playingNormalLyrics = '';
                                playingEnglishLyrics = '';
                                playingTranslationLyrics = '';
                                controller.sheetHeight = 0.1;
                                if (shuffleOn) {
                                  if (getRandomNumberFromList() > 0) {
                                    controller.shabadData =
                                        widget.listOfShabads[
                                            getRandomNumberFromList()];
                                    controller.playerLoading = true;
                                    playingShabadData = controller.shabadData;
                                    controller.update();
                                    controller.onInit();
                                  }
                                } else {
                                  int indexOfPlayingShabad = widget
                                      .listOfShabads
                                      .indexWhere((element) =>
                                          element == widget.shabadData);
                                  if (indexOfPlayingShabad > 0) {
                                    controller.shabadData =
                                        widget.listOfShabads[
                                            indexOfPlayingShabad - 1];
                                    controller.playerLoading = true;
                                    playingShabadData = controller.shabadData;
                                    controller.update();
                                    controller.onInit();
                                  }
                                }
                                          }
                              }
                            },
                            icon: SvgPicture.asset(
                              rewindSvg,
                              width: 22,
                              height: 22,
                              color:
                                  themeProvider.darkTheme ? Colors.white : null,
                            ),
                          );
                        },
                      ),
                      StreamBuilder<bool>(
                        stream: audioHandler!.playbackState
                            .map((state) => state.playing)
                            .distinct(),
                        builder: (context, snapshot) {
                          final playing = snapshot.data ?? false;
                          controller.playing = playing;
                          return GestureDetector(
                            onTap: () {
                              if (playing) {
                                audioHandler!.pause();
                              } else {
                                audioHandler!.play();
                              }
                              sendBroadcast('actionMusicPlaying');
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: const Color(0XFF444444),
                              child: Icon(
                                  playing ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 30),
                            ),
                          );
                        },
                      ),
                      StreamBuilder<MediaState>(
                        stream: mediaStateStream,
                        builder: (context, snapshot) {
                          return IconButton(
                            onPressed: () {
                              if (widget.listOfShabads.length > 1) {
                                int indexOfPlayingShabad = widget
                                      .listOfShabads
                                      .indexWhere((element) =>
                                          element == widget.shabadData);
                                  if (indexOfPlayingShabad + 1 <
                                      widget.listOfShabads.length) {
                                audioHandler!.pause();
                                audioHandler!.stop();
                                audioHandler = null;
                                playingLyricModel = null;
                                playingNormalLyrics = '';
                                playingEnglishLyrics = '';
                                playingTranslationLyrics = '';
                                controller.sheetHeight = 0.1;

                                if (shuffleOn) {
                                  if (getRandomNumberFromList() <
                                      widget.listOfShabads.length) {
                                    controller.shabadData =
                                        widget.listOfShabads[
                                            getRandomNumberFromList()];
                                    playingShabadData = controller.shabadData;
                                    controller.playerLoading = true;
                                    controller.update();
                                    controller.onInit();
                                  }
                                } else {
                                  int indexOfPlayingShabad = widget
                                      .listOfShabads
                                      .indexWhere((element) =>
                                          element == widget.shabadData);
                                  if (indexOfPlayingShabad + 1 <
                                      widget.listOfShabads.length) {
                                    controller.shabadData =
                                        widget.listOfShabads[
                                            indexOfPlayingShabad + 1];
                                    playingShabadData = controller.shabadData;
                                    controller.playerLoading = true;
                                    controller.update();
                                    controller.onInit();
                                  }
                                }
                              }
                              }
                            },
                            icon: SvgPicture.asset(
                              forwardSvg,
                              width: 22,
                              height: 22,
                              color:
                                  themeProvider.darkTheme ? Colors.white : null,
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          shuffleOn = !shuffleOn;
                          controller.update();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: shuffleOn
                                ? secondPrimaryColor
                                : Colors.transparent,
                          ),
                          padding: const EdgeInsets.all(15),
                          child: SvgPicture.asset(
                            shuffleSvg,
                            color: shuffleOn
                                ? Colors.white
                                : themeProvider.darkTheme
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  //Formate the duration to show on player
  String _formatDuration(Duration? duration) {
    if (duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String twoDigitsBack(int n) => n.toString().padLeft(2, '0');
      if (duration.inSeconds < 3600) {
        final String twoDigitMinutes =
            twoDigits(duration.inMinutes.remainder(60));
        final String twoDigitSeconds =
            twoDigitsBack(duration.inSeconds.remainder(60));
        return "$twoDigitMinutes:$twoDigitSeconds";
      } else {
        final String twoDigitHours = twoDigits(duration.inHours.remainder(60));
        final String twoDigitMinutes =
            twoDigitsBack(duration.inMinutes.remainder(60));
        final String twoDigitSeconds =
            twoDigitsBack(duration.inSeconds.remainder(60));
        return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
      }
    }
    return "00:00";
  }
}
