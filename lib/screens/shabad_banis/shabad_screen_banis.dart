// Screen for displaying Shabads from Banis (Sikh prayers)
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/shabad_banis/shabad_controller_banis.dart';
import 'package:shabadguru/screens/shabad_banis/widget/shabad_item_banis.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

// Screen for displaying list of Shabads from a specific Bani with animations
class ShabadScreenBanis extends StatelessWidget {
  const ShabadScreenBanis(
      {super.key,
      required this.categoryId,
      required this.id,
      required this.title});

  final String categoryId; // Category identifier for the Bani
  final String id; // Unique identifier for the Bani
  final String title; // Title of the Bani

  // Build the Shabad Banis screen UI
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
    return GetBuilder<ShabadControllerBanis>(
      init: ShabadControllerBanis(categoryId: categoryId, id: id, title: title), // Initialize controller
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
              title, // Display Bani title
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
          body: Column(
            children: [
              // Show loading indicator while data is loading
              if (controller.shabadRaagModel == null)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: darkBlueColor, // Blue loading indicator
                    ),
                  ),
                )
              // Show Shabad list when data is loaded
              else if (controller.shabadRaagModel!.data != null)
                Expanded(
                  child: AnimationLimiter( // Limit animations for performance
                    child: ListView.builder(
                      shrinkWrap: true, // Shrink to fit content
                      physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                      itemCount: controller.shabadRaagModel!.data!.length, // Number of Shabads
                      padding: const EdgeInsets.only(top: 30, bottom: 60), // List padding
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
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
                                      controller.shabadRaagModel!.data![index], // Selected Shabad
                                      title, // Bani title
                                      controller.shabadRaagModel!.data!); // All Shabads for playlist
                                },
                                child: ShabadItemBanis(
                                  shabadData:
                                      controller.shabadRaagModel!.data![index], // Shabad data
                                  title: title, // Bani title
                                  onMenuTaped: () {
                                    // Show menu options for Shabad
                                    controller.showMenuOptions(
                                        context,
                                        controller
                                            .shabadRaagModel!.data![index]);
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
