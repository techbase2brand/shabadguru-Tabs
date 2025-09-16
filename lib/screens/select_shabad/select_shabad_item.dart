// Widget for displaying individual Shabad item in selection list
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

// Widget for displaying a single Shabad item with selection checkbox
class SelectShabadItem extends StatelessWidget {
  const SelectShabadItem(
      {super.key,
      required this.shabadData,
      required this.isSelectedForPlaylist});

  final ShabadData shabadData; // Shabad data model
  final Function() isSelectedForPlaylist; // Callback for selection toggle

  // Build the select Shabad item widget UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    return GestureDetector(
      onTap: () {
        isSelectedForPlaylist(); // Toggle selection on tap
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10), // Container margins
        child: Card(
          elevation: 0.4, // Card shadow elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          color:
              themeProvider.darkTheme ? Colors.blueGrey.shade900 : Colors.white, // Card background color
          child: Container(
            width: widthOfScreen, // Full screen width
            height: 70, // Fixed height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 10, // Left spacing
                ),
                // Play button container
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color:
                        themeProvider.darkTheme ? Colors.black : Colors.white, // Button background
                    shape: BoxShape.circle, // Circular shape
                    border: Border.all(
                        width: 1.5,
                        color: themeProvider.darkTheme
                            ? Colors.white // White border for dark theme
                            : Colors.grey.shade400), // Grey border for light theme
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow, // Play arrow icon
                      color: themeProvider.darkTheme
                          ? Colors.white // White icon for dark theme
                          : Colors.grey.shade400, // Grey icon for light theme
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10, // Spacing between play button and text
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
                            color: themeProvider.darkTheme
                                ? Colors.white // White text for dark theme
                                : Colors.black, // Black text for light theme
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                // Selection checkbox
                Checkbox(
                  activeColor: secondPrimaryColor, // Gold color when checked
                  value: shabadData.isSelectedForPlaylist, // Current selection state
                  onChanged: (value) {
                    isSelectedForPlaylist(); // Toggle selection
                  },
                ),
                const SizedBox(
                  width: 10, // Right spacing
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
