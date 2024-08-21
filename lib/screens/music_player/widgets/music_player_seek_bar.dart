import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/screens/music_player/music_player_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';

class MusicPlayerSeekBar extends StatefulWidget {
  const MusicPlayerSeekBar({super.key});

  @override
  State<MusicPlayerSeekBar> createState() => _MusicPlayerSeekBarState();
}

class _MusicPlayerSeekBarState extends State<MusicPlayerSeekBar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<MusicPlayerController>(builder: (controller) {
      return SizedBox(
        width: widthOfScreen,
        child: StreamBuilder<MediaState>(
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

              if (!snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 15, bottom: 15),
                  child: ProgressBar(
                    thumbColor: secondPrimaryColor,
                    bufferedBarColor: Colors.transparent,
                    progressBarColor: themeProvider.darkTheme
                        ? secondPrimaryColor
                        : darkBlueColor,
                    baseBarColor: Colors.grey,
                    timeLabelLocation: TimeLabelLocation.none,
                    barHeight: 4,
                    thumbRadius: 8.0,
                    progress: progressDuration ?? Duration.zero,
                    total: totalDuration ?? Duration.zero,
                    onDragStart: (_) {},
                    onDragEnd: () {},
                    onSeek: (duration) {
                      audioHandler!.seek(duration);
                    },
                  ),
                );
              } else {
                return const IgnorePointer();
              }
            }),
      );
    });
  }
}
