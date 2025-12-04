// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/select_playlist/playlist_item.dart';
import 'package:shabadguru/screens/select_playlist/select_playlist_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/shared_pref.dart';

// Screen for selecting playlists to add a shabad to
class SelectPlaylistScreen extends StatelessWidget {
  const SelectPlaylistScreen({super.key, required this.shabadData});

  final ShabadData shabadData; // Shabad data to be added to playlists

  // Build the playlist selection screen UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    return GetBuilder<SelectPlaylistController>(
      init: SelectPlaylistController(), // Initialize playlist selection controller
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          appBar: AppBar(
            centerTitle: true, // Center the title
            toolbarHeight: widthOfScreen * 0.15, // Dynamic toolbar height
            backgroundColor: themeProvider.darkTheme
                ? Colors.black // Dark theme app bar
                : const Color(0XFF24163A), // Light theme app bar
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded, // Back arrow icon
                color: Colors.white, // White icon color
              ),
            ),
            title: const Text(
              'Select Playlist', // App bar title
              style: TextStyle(color: Colors.white), // White title text
            ),
          ),
          body: Column(
            children: [
              // Empty state - show when no playlists are found
              if (controller.myPlaylist == null ||
                  controller.myPlaylist!.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Empty state image (commented out)
                        // Image.asset(
                        //   'assets/images/empty_search.png',
                        //   width: 150,
                        //   height: 150,
                        // ),
                        const SizedBox(
                          height: 15, // Spacing before text
                        ),
                        Text(
                          'No Playlist found', // Empty state message
                          style: TextStyle(
                              color: themeProvider.darkTheme
                                  ? Colors.white // White text for dark theme
                                  : Colors.black, // Black text for light theme
                              fontSize: 18,
                              fontFamily: poppinsRegular,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              // Playlists list - show when playlists are available
              else
                Expanded(
                  child: AnimationLimiter( // Limit animations for performance
                    child: ListView.builder(
                      shrinkWrap: true, // Shrink to fit content
                      physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                      itemCount: controller.myPlaylist!.length, // Number of playlists
                      padding: const EdgeInsets.only(top: 30, bottom: 60), // List padding
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index, // Animation position
                          duration: const Duration(milliseconds: 1000), // Animation duration
                          child: SlideAnimation(
                            verticalOffset: 50.0, // Slide from bottom
                            duration: const Duration(milliseconds: 1000),
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  // Toggle playlist selection
                                  if (controller.selectedPlaylistList.contains(
                                      controller.myPlaylist![index])) {
                                    controller.selectedPlaylistList
                                        .remove(controller.myPlaylist![index]); // Remove from selected
                                  } else {
                                    controller.selectedPlaylistList
                                        .add(controller.myPlaylist![index]); // Add to selected
                                  }
                                  controller.myPlaylist![index].isSelected =
                                      !controller.myPlaylist![index].isSelected; // Toggle selection state
                                  controller.update(); // Update UI
                                },
                                child: PlayListItem(
                                  myPlaylistModel:
                                      controller.myPlaylist![index], // Pass playlist data
                                  isSelectedPlaylist:
                                      controller.myPlaylist![index].isSelected, // Pass selection state
                                  onMenuTaped: () {
                                    // Handle checkbox tap
                                    if (controller.selectedPlaylistList
                                        .contains(
                                            controller.myPlaylist![index])) {
                                      controller.selectedPlaylistList.remove(
                                          controller.myPlaylist![index]); // Remove from selected
                                    } else {
                                      controller.selectedPlaylistList
                                          .add(controller.myPlaylist![index]); // Add to selected
                                    }
                                    controller.myPlaylist![index].isSelected =
                                        !controller
                                            .myPlaylist![index].isSelected; // Toggle selection state
                                    controller.update(); // Update UI
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(
                height: 15, // Spacing before done button
              ),
              // Done button - show when playlists are available
              if (controller.myPlaylist != null &&
                  controller.myPlaylist!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 100, // Left spacing
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(darkBlueColor)), // Button background
                        onPressed: () async {
                          if (controller.selectedPlaylistList.isEmpty) {
                            // Show error message if no playlist selected
                            Fluttertoast.showToast(
                              msg: "Please select at least one playlist", // Error message
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: darkBlueColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            // Add shabad to selected playlists
                            for (var i = 0;
                                i < controller.myPlaylist!.length;
                                i++) {
                              if (controller.myPlaylist![i].isSelected) {
                                controller.myPlaylist![i].shabadList!
                                    .add(shabadData); // Add shabad to playlist
                              }
                            }
                            await SharedPref.savePlaylist(
                                controller.myPlaylist!); // Save updated playlists
                            // Show success message
                            Fluttertoast.showToast(
                              msg: "Shabad added to your playlist", // Success message
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: darkBlueColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.of(context).pop(); // Navigate back
                          }
                        },
                        child: const Center(
                          child: Text(
                            'Done', // Button text
                            style: TextStyle(color: Colors.white), // White text
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 100, // Right spacing
                    ),
                  ],
                ),
              const SizedBox(
                height: 35, // Bottom spacing
              ),
            ],
          ),
        );
      },
    );
  }
}
