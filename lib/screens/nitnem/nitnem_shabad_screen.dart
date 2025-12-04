// Screen for displaying Nitnem with direct audio playback (no shabads list)
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/nitnem/nitnem_shabad_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';

// Screen for playing Nitnem directly with audio and lyrics
class NitnemShabadScreen extends StatelessWidget {
  const NitnemShabadScreen({
    super.key,
    required this.audioUrl,
    required this.lyricsUrl,
    required this.title,
  });

  final String audioUrl; // Direct audio MP3 URL
  final String lyricsUrl; // Lyrics JSON URL
  final String title; // Nitnem title

  // Build the Nitnem playback screen UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive design

    // Calculate app bar height based on screen size
    double appBarHeight;
    if (screenWidth > 600) {
      // Fixed height for tablets
      appBarHeight = 99;
    } else {
      // Responsive height for phones
      appBarHeight = widthOfScreen * 0.15;
    }
    
    return GetBuilder<NitnemShabadController>(
      init: NitnemShabadController(
        audioUrl: audioUrl,
        lyricsUrl: lyricsUrl,
        title: title,
      ), // Initialize controller
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          appBar: AppBar(
            centerTitle: true, // Center the title
            toolbarHeight: appBarHeight, // Dynamic toolbar height
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor, // App bar background
            title: Text(
              title, // Display Nitnem title
              style: const TextStyle(color: Colors.white), // White title text
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded, // Back arrow icon
                color: Colors.white, // White icon color
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play button
                GestureDetector(
                  onTap: () {
                    // Close this screen before playing (to avoid multiple instances)
                    Navigator.of(context).pop();
                    // Then play Nitnem
                    controller.playNitnem(context);
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: darkBlueColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: darkBlueColor.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Nitnem title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.darkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Subtitle
                Text(
                  'Tap to play',
                  style: TextStyle(
                    fontSize: 16,
                    color: themeProvider.darkTheme
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
