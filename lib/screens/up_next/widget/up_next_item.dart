// Widget for displaying individual Shabad item in up next playlist
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

// Widget for displaying a single Shabad item in up next playlist with play/pause state
class UpNextItem extends StatelessWidget {
  const UpNextItem(
      {super.key,
      required this.shabadData,
      required this.isPlaying, required this.onMenuTaped});

  final ShabadData shabadData; // Shabad data model
  final bool isPlaying; // Whether this Shabad is currently playing
  final Function onMenuTaped; // Callback for menu tap

  // Build the up next item widget UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10), // Container margins
      child: Card(
        elevation: 2, // Card shadow elevation
        color: themeProvider.darkTheme?Colors.black:Colors.white, // Card background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Container(
          width: widthOfScreen, // Full screen width
          height: 70, // Fixed height
          decoration: BoxDecoration(
            color: isPlaying ? const Color(0XFFFFF8EA) : themeProvider.darkTheme?Colors.blueGrey.shade900: Colors.white, // Background color based on playing state and theme
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10, // Left spacing
              ),
              // Play/Pause button container
              if (isPlaying)
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: secondPrimaryColor, // Gold background when playing
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pause, // Pause icon when playing
                      color: Colors.white, // White icon
                    ),
                  ),
                )
              else
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color:themeProvider.darkTheme?Colors.black: Colors.white, // Button background
                    shape: BoxShape.circle, // Circular shape
                    border:
                        Border.all(width: 1.5, color:themeProvider.darkTheme?Colors.white: Colors.grey.shade400), // Border color
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow, // Play arrow icon when not playing
                      color:themeProvider.darkTheme?Colors.white: Colors.grey.shade400, // Icon color
                    ),
                  ),
                ),
              const SizedBox(
                width: 10, // Spacing between button and text
              ),
              // Shabad name text section
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shabadData.song ?? '', // Shabad song name
                      maxLines: 2, // Maximum 2 lines
                      overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                      style: TextStyle(
                          fontFamily: poppinsRegular,
                          color:
                              isPlaying ? secondPrimaryColor :  themeProvider.darkTheme?Colors.white: Colors.black, // Text color based on playing state and theme
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10, // Spacing between text and menu button
              ),
              // Menu button
              IconButton(
                onPressed: () {
                  onMenuTaped(); // Call menu tap callback
                },
                icon: Icon(
                  Icons.more_vert_outlined, // Vertical dots menu icon
                  color:isPlaying?Colors.black: themeProvider.darkTheme ? Colors.white : Colors.black, // Icon color based on playing state and theme
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
