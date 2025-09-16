import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/recent_played/recent_play_item.dart';
import 'package:shabadguru/screens/up_next/up_next_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

// Screen for displaying recently played shabads list
class RecentScreen extends StatelessWidget {
  const RecentScreen({
    super.key,
    required this.listOfShabads,
  });

  final List<ShabadData> listOfShabads; // List of recently played shabads

  // Build the recently played screen UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive design

    // Calculate app bar height based on screen size
    double appBarHeight;
    if (screenWidth > 600) {
      // Example breakpoint for tablets
      appBarHeight = 99; // Fixed height for tablets
    } else {
      appBarHeight = widthOfScreen * 0.15; // Responsive height for phones
    }
    return GetBuilder<UpNextController>(
      init: UpNextController(
        listOfShabads: listOfShabads, // Initialize with recent shabads list
      ),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          appBar: AppBar(
            centerTitle: true, // Center the title
            toolbarHeight: appBarHeight, // Dynamic toolbar height
            foregroundColor: Colors.white, // White foreground color
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor, // App bar background
            title: const Text(
              'Recently Played', // App bar title
              style: TextStyle(color: Colors.white), // White title text
            ),
          ),
          body: Column(
            children: [
              // Recently played shabads list
              Expanded(
                child: AnimationLimiter( // Limit animations for performance
                  child: ListView.builder(
                    shrinkWrap: true, // Shrink to fit content
                    physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                    itemCount: listOfShabads.length, // Number of recently played shabads
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
                                // Navigate to music player page
                                goToMusicPlayerPage(
                                    context,
                                    listOfShabads[index], // Current shabad data
                                    listOfShabads[index].title ?? '', // Shabad title
                                    listOfShabads); // Full recent shabads list
                              },
                              child: RecentPlayedItem(
                                shabadData: listOfShabads[index], // Pass shabad data
                                onMenuTaped: () {
                                  // Show menu options for shabad
                                  controller.showMenuOptions(
                                      context, controller.listOfShabads[index]);
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
            ],
          ),
        );
      },
    );
  }
}
