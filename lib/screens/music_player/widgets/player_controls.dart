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

// Widget for music player controls (play/pause, skip, shuffle, seek bar)
class PlayerControls extends StatefulWidget {
  const PlayerControls(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.listOfShabads,
      required this.shabadData});

  final String title; // Shabad title
  final String subTitle; // Song subtitle
  final List<ShabadData> listOfShabads; // Playlist
  final ShabadData shabadData; // Current shabad data

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  // Initialize global playing variables
  @override
  void initState() {
    super.initState();
    playingTitle = widget.title; // Set global playing title
    playingSubtitle = widget.subTitle; // Set global playing subtitle
    playingShabadData = widget.shabadData; // Set global playing shabad data
    playingListOfShabad = widget.listOfShabads; // Set global playing list
  }

  // Build the player controls UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    return GetBuilder<MusicPlayerController>(
      builder: (controller) {
        return Column(
          children: [
            // Seek bar section
            SizedBox(
              width: screenWidth, // Full screen width
              child: const MusicPlayerSeekBar(), // Display seek bar
            ),
            // Time display section
            StreamBuilder<MediaState>(
              stream: mediaStateStream, // Listen to media state changes
              builder: (context, snapshot) {
                Duration? progressDuration; // Current playback position
                Duration? totalDuration; // Total audio duration
                final mediaState = snapshot.data; // Get current media state

                // Extract duration information from media state
                if (mediaState?.mediaItem?.duration != null) {
                  if (mediaState?.position != null) {
                    progressDuration = mediaState?.position; // Current position
                    totalDuration = mediaState?.mediaItem?.duration!; // Total duration
                  }
                }

                // Ensure progress doesn't exceed total duration
                if (progressDuration != null && totalDuration != null) {
                  if (progressDuration.inMilliseconds >
                      totalDuration.inMilliseconds) {
                    progressDuration = totalDuration; // Cap progress at total duration
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30,top: 30), // Time display padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between current and total time
                    children: [
                      // Current time display
                      Text(
                        _formatDuration(progressDuration), // Format current time
                        style: TextStyle(
                          fontSize: 15,
                          color: themeProvider.darkTheme
                              ? Colors.white // White for dark theme
                              : Colors.black, // Black for light theme
                          fontFamily: poppinsRegular,
                        ),
                      ),
                      // Total time display
                      Text(
                        _formatDuration(totalDuration), // Format total time
                        style: TextStyle(
                          fontSize: 15,
                          color: themeProvider.darkTheme
                              ? Colors.white // White for dark theme
                              : Colors.black, // Black for light theme
                          fontFamily: poppinsRegular,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Control buttons section
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10), // Control buttons padding
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between control buttons
                    children: [
                      // Restart button
                      IconButton(
                        onPressed: () {
                          Duration duration = const Duration(seconds: 0); // Seek to beginning
                          audioHandler!.seek(duration); // Seek to start
                        },
                        icon: SvgPicture.asset(
                          refreshSvg, // Restart icon
                          color: themeProvider.darkTheme ? Colors.white : null, // Icon color based on theme
                        ),
                      ),
                      // Previous track button
                      StreamBuilder<MediaState>(
                        stream: mediaStateStream, // Listen to media state
                        builder: (context, snapshot) {
                          // Determine if previous track is available
                          final list = widget.listOfShabads;
                          final currentIndex =
                              list.indexWhere((e) => e == widget.shabadData);
                          final hasPrev = list.length > 1 && currentIndex > 0;

                          return IconButton(
                            onPressed: hasPrev
                                ? () {
                                    if (widget.listOfShabads.length > 1) {
                                      int playingIndex = widget.listOfShabads
                                          .indexWhere((element) =>
                                              element == widget.shabadData);
                                      if (playingIndex <
                                              widget.listOfShabads.length &&
                                          playingIndex > 0) {
                                        // Stop current audio
                                        audioHandler!.pause();
                                        audioHandler!.stop();
                                        audioHandler = null;
                                        playingLyricModel = null;
                                        playingNormalLyrics = '';
                                        playingEnglishLyrics = '';
                                        playingTranslationLyrics = '';
                                        controller.sheetHeight =
                                            0.1; // Collapse sheet
                                        if (shuffleOn) {
                                          // Play random previous track
                                          if (getRandomNumberFromList() > 0) {
                                            controller.shabadData =
                                                widget.listOfShabads[
                                                    getRandomNumberFromList()];
                                            controller.playerLoading = true;
                                            playingShabadData =
                                                controller.shabadData;
                                            controller.update();
                                            controller.onInit();
                                          }
                                        } else {
                                          // Play previous track in sequence
                                          int indexOfPlayingShabad = widget
                                              .listOfShabads
                                              .indexWhere((element) =>
                                                  element == widget.shabadData);
                                          if (indexOfPlayingShabad > 0) {
                                            controller.shabadData =
                                                widget.listOfShabads[
                                                    indexOfPlayingShabad - 1];
                                            controller.playerLoading = true;
                                            playingShabadData =
                                                controller.shabadData;
                                            controller.update();
                                            controller.onInit();
                                          }
                                        }
                                      }
                                    }
                                  }
                                : null,
                            icon: SvgPicture.asset(
                              rewindSvg, // Previous track icon
                              width: 22,
                              height: 22,
                              color: hasPrev
                                  ? (themeProvider.darkTheme
                                      ? Colors.white
                                      : null)
                                  : Colors.grey
                                      .shade400, // Disabled look when no previous track
                            ),
                          );
                        },
                      ),
                      // Play/Pause button
                      StreamBuilder<bool>(
                        stream: audioHandler!.playbackState
                            .map((state) => state.playing) // Get playing state
                            .distinct(), // Only emit when state changes
                        builder: (context, snapshot) {
                          final playing = snapshot.data ?? false; // Get current playing state
                          controller.playing = playing; // Update controller state
                          return GestureDetector(
                            onTap: () {
                              if (playing) {
                                audioHandler!.pause(); // Pause if playing
                              } else {
                                audioHandler!.play(); // Play if paused
                              }
                              sendBroadcast('actionMusicPlaying'); // Broadcast state change
                            },
                            child: CircleAvatar(
                              radius: 25, // Button radius
                              backgroundColor: const Color(0XFF444444), // Button background
                              child: Icon(
                                  playing ? Icons.pause : Icons.play_arrow, // Pause or play icon
                                  color: Colors.white, // White icon
                                  size: 30), // Icon size
                            ),
                          );
                        },
                      ),
                      StreamBuilder<MediaState>(
                        stream: mediaStateStream,
                        builder: (context, snapshot) {
                          // Determine if next track is available
                          final list = widget.listOfShabads;
                          final currentIndex =
                              list.indexWhere((e) => e == widget.shabadData);
                          final hasNext = list.length > 1 &&
                              currentIndex >= 0 &&
                              currentIndex < list.length - 1;

                          return IconButton(
                            onPressed: hasNext
                                ? () {
                                    if (widget.listOfShabads.length > 1) {
                                      int indexOfPlayingShabad =
                                          widget.listOfShabads.indexWhere(
                                              (element) =>
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
                                            playingShabadData =
                                                controller.shabadData;
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
                                            playingShabadData =
                                                controller.shabadData;
                                            controller.playerLoading = true;
                                            controller.update();
                                            controller.onInit();
                                          }
                                        }
                                      }
                                    }
                                  }
                                : null,
                            icon: SvgPicture.asset(
                              forwardSvg,
                              width: 22,
                              height: 22,
                              color: hasNext
                                  ? (themeProvider.darkTheme
                                      ? Colors.white
                                      : null)
                                  : Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                      // Shuffle button
                      Builder(builder: (context) {
                        // Shuffle only makes sense when there is more than one track
                        final bool canShuffle =
                            widget.listOfShabads.length > 1;
                        return GestureDetector(
                          onTap: canShuffle
                              ? () {
                                  shuffleOn = !shuffleOn; // Toggle shuffle mode
                                  controller.update(); // Update UI
                                }
                              : null,
                          child: Container(
                            height: 50, // Button height
                            width: 50, // Button width
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Circular button
                              color: !canShuffle
                                  ? Colors.grey.shade300 // Disabled background
                                  : shuffleOn
                                      ? secondPrimaryColor // Gold when active
                                      : Colors.transparent, // Transparent when inactive
                            ),
                            padding: const EdgeInsets.all(15), // Button padding
                            child: SvgPicture.asset(
                              shuffleSvg, // Shuffle icon
                              color: !canShuffle
                                  ? Colors.grey.shade500 // Disabled icon
                                  : shuffleOn
                                      ? Colors.white // White when active
                                      : themeProvider.darkTheme
                                          ? Colors.white // White for dark theme when inactive
                                          : Colors.black, // Black for light theme when inactive
                            ),
                          ),
                        );
                      }),
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

  // Format duration to display on player (MM:SS or HH:MM:SS format)
  String _formatDuration(Duration? duration) {
    if (duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, '0'); // Add leading zero for single digits
      String twoDigitsBack(int n) => n.toString().padLeft(2, '0'); // Add leading zero for single digits
      if (duration.inSeconds < 3600) {
        // Format for less than 1 hour (MM:SS)
        final String twoDigitMinutes =
            twoDigits(duration.inMinutes.remainder(60)); // Minutes with leading zero
        final String twoDigitSeconds =
            twoDigitsBack(duration.inSeconds.remainder(60)); // Seconds with leading zero
        return "$twoDigitMinutes:$twoDigitSeconds"; // MM:SS format
      } else {
        // Format for 1 hour or more (HH:MM:SS)
        final String twoDigitHours = twoDigits(duration.inHours.remainder(60)); // Hours with leading zero
        final String twoDigitMinutes =
            twoDigitsBack(duration.inMinutes.remainder(60)); // Minutes with leading zero
        final String twoDigitSeconds =
            twoDigitsBack(duration.inSeconds.remainder(60)); // Seconds with leading zero
        return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds"; // HH:MM:SS format
      }
    }
    return "00:00"; // Default format when duration is null
  }
}
