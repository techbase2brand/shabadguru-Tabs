import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/my_playlist_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'dart:math' as math;

import 'package:shabadguru/utils/font.dart';

// Widget for displaying individual playlist items in selection screen
class PlayListItem extends StatelessWidget {
  const PlayListItem(
      {super.key,
      required this.onMenuTaped,
      required this.myPlaylistModel,
      required this.isSelectedPlaylist});

  final Function onMenuTaped; // Menu tap callback function
  final MyPlaylistModel myPlaylistModel; // Playlist data model
  final bool isSelectedPlaylist; // Whether playlist is selected

  // Build the playlist item widget UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15), // Container margins
      color: themeProvider.darkTheme
          ? Colors.black // Dark theme background
          : const Color.fromARGB(255, 239, 242, 248), // Light theme background
      child: Column(
        children: [
          Row(
            children: [
              // Colored icon card with playlist initial
              Card(
                elevation: 2, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                color: themeProvider.darkTheme
                    ? Colors.blueGrey.shade900 // Dark theme card background
                    : Colors.white, // Light theme card background
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()) // Random color generation
                            .withOpacity(1.0),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Center(
                    child: Text(
                      myPlaylistModel.playlistName?[0]
                              .toString()
                              .capitalizeFirst ?? // Get first letter of playlist name
                          'S', // Default 'S' if no name
                      style: TextStyle(
                        color: Colors.white, // White text on colored background
                        fontFamily: poppinsExtraBold,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10, // Spacing between icon and text
              ),
              // Playlist name and count section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myPlaylistModel.playlistName.toString().capitalizeFirst ?? // Playlist name
                          '',
                      style: TextStyle(
                        color: themeProvider.darkTheme
                            ? Colors.white // White text for dark theme
                            : Colors.black, // Black text for light theme
                        fontFamily: poppinsExtraBold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5, // Spacing between name and count
                    ),
                    Text(
                      '${myPlaylistModel.shabadList!.length} ${myPlaylistModel.shabadList!.length > 1 ? "Shabads" : "Shabad"}', // Shabad count with proper pluralization
                      style: TextStyle(
                        color: themeProvider.darkTheme
                            ? Colors.white // White text for dark theme
                            : Colors.black, // Black text for light theme
                        fontFamily: poppinsMedium,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Selection checkbox
              Checkbox(
                activeColor: secondPrimaryColor, // Checkbox active color
                value: isSelectedPlaylist, // Current selection state
                onChanged: (value) {
                  onMenuTaped(); // Call menu tap callback
                },
              ),
              const SizedBox(
                width: 10, // Right spacing
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
