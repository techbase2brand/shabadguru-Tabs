import 'package:flutter/material.dart';
// import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader.dart';
import 'package:shabadguru/screens/music_player/music_player_controller.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';

// Widget for displaying synchronized lyrics with multiple language support
class LyricsWidget extends StatelessWidget {
  const LyricsWidget({super.key});

  // Build the lyrics display widget
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    return GetBuilder<MusicPlayerController>(
      builder: (controller) {
        return LyricsReader(
          isDarkMode: themeProvider.darkTheme, // Dark mode setting
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0), // Lyrics padding
          model: controller.lyricModel, // Lyrics model with all language data
          position: controller.playProgress, // Current playback position
          lyricUi: controller.lyricUI, // Lyrics UI configuration
          playing: controller.playing, // Current playing state
          emptyBuilder: () => Center(
            child: Text(
              "No lyrics", // Empty state message
              style: controller.lyricUI.getOtherMainTextStyle(), // Empty state text style
            ),
          ),
          selectLineBuilder: (progress, confirm) {
            return const IgnorePointer(); // Disable line selection
          },
          // Font sizes for different lyrics languages
          fontSizeOfMain: controller.fontSizeOfLyricsMain, // Main lyrics font size
          fontSizeOfExit: controller.fontSizeOfLyricsExit, // Exit lyrics font size
          fontSizeOfMid: controller.fontSizeOfLyricsMid, // Mid lyrics font size
          fontSizeOfSpanish: controller.fontSizeOfLyricsSpanish, // Spanish lyrics font size
          fontSizeOfHindi: controller.fontSizeOfLyricsHindi, // Hindi lyrics font size
        );
      },
    );
  }
}
