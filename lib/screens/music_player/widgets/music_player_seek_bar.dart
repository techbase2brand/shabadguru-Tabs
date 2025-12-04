import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/screens/music_player/music_player_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';

// Widget for displaying audio progress bar with seek functionality
class MusicPlayerSeekBar extends StatefulWidget {
  const MusicPlayerSeekBar({super.key});

  @override
  State<MusicPlayerSeekBar> createState() => _MusicPlayerSeekBarState();
}

class _MusicPlayerSeekBarState extends State<MusicPlayerSeekBar> {
  // Build the seek bar widget
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
     final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    return GetBuilder<MusicPlayerController>(builder: (controller) {
      return SizedBox(
        width: screenWidth, // Full screen width
        child: StreamBuilder<MediaState>(
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
                if (progressDuration.inMilliseconds > totalDuration.inMilliseconds) {
                  progressDuration = totalDuration; // Cap progress at total duration
                }
              }

              if (!snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 15, bottom: 15), // Container padding
                  child: ProgressBar(
                    thumbColor: secondPrimaryColor, // Thumb color
                    bufferedBarColor: Colors.transparent, // Transparent buffered bar
                    progressBarColor: themeProvider.darkTheme
                        ? secondPrimaryColor // Gold for dark theme
                        : darkBlueColor, // Blue for light theme
                    baseBarColor: Colors.grey, // Base bar color
                    timeLabelLocation: TimeLabelLocation.none, // Hide time labels
                    barHeight: 4, // Progress bar height
                    thumbRadius: 8.0, // Thumb radius
                    progress: progressDuration ?? Duration.zero, // Current progress
                    total: totalDuration ?? Duration.zero, // Total duration
                    onDragStart: (_) {}, // Drag start callback
                    onDragEnd: () {}, // Drag end callback
                    onSeek: (duration) {
                      audioHandler!.seek(duration); // Seek to position
                    },
                  ),
                );
              } else {
                return const IgnorePointer(); // Hide if error
              }
            }),
      );
    });
  }
}
