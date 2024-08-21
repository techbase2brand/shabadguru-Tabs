import 'package:flutter/material.dart';
// import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader.dart';
import 'package:shabadguru/screens/music_player/music_player_controller.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';

class LyricsWidget extends StatelessWidget {
  const LyricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<MusicPlayerController>(
      builder: (controller) {
        return LyricsReader(
          isDarkMode: themeProvider.darkTheme,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          model: controller.lyricModel,
          position: controller.playProgress,
          lyricUi: controller.lyricUI,
          playing: controller.playing,
          emptyBuilder: () => Center(
            child: Text(
              "No lyrics",
              style: controller.lyricUI.getOtherMainTextStyle(),
            ),
          ),
          selectLineBuilder: (progress, confirm) {
            return const IgnorePointer();
          },
          fontSizeOfMain: controller.fontSizeOfLyricsMain,
          fontSizeOfExit: controller.fontSizeOfLyricsExit,
          fontSizeOfMid: controller.fontSizeOfLyricsMid,
          fontSizeOfSpanish: controller.fontSizeOfLyricsSpanish,
          fontSizeOfHindi: controller.fontSizeOfLyricsHindi,
        );
      },
    );
  }
}
