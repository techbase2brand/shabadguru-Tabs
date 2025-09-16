// Screen for displaying The Kirtanis information and images
// ignore_for_file: equal_elements_in_set

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/the_kirtanis/the_kirtanis_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

// Screen for displaying information about The Kirtanis and their images
class TheKirtanisScreen extends StatelessWidget {
  const TheKirtanisScreen({super.key});

  // Build the The Kirtanis screen UI
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
    return GetBuilder<TheKirtanisController>(
        init: TheKirtanisController(), // Initialize controller
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
              title: const Text(
                'The Kirtanis', // App bar title
                style: TextStyle(color: Colors.white), // White title text
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
            body: controller.list.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.darkTheme
                          ? Colors.white // White loading indicator for dark theme
                          : darkBlueColor, // Blue loading indicator for light theme
                    ),
                  )
                : SingleChildScrollView( // Scrollable content
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20, // Top spacing
                        ),
                        // Main title section
                        Text(
                          'The Kirtanis', // Main title
                          style: TextStyle(
                              fontFamily: poppinsBold,
                              fontSize: 22,
                              color: themeProvider.darkTheme
                                  ? Colors.white // White text for dark theme
                                  : Colors.black, // Black text for light theme
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5, // Spacing after title
                        ),
                        // Title underline
                        Container(
                          width: 100,
                          height: 1.5,
                          color: secondPrimaryColor, // Gold underline
                        ),
                        const SizedBox(
                          height: 15, // Spacing after underline
                        ),
                        // Description text container
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15), // Horizontal margins
                          child: Text(
                            'The Kirtan on this website has been sung by the students of Baru Sahib (Kalgidhar Society). These young students have been trained in Raags by dozens of accomplished Professors of Raagas (Music).Anahad BaniwithTantiSaaz has been undertaken by these students for the first time in the history of Sikh television. It is a mesmerizing Raag Aadharit rendition of the complete Guru Granth Sahib Ji. All the Kirtan you hear on this website is the audio files of the Kirtan they sung on television. More information on the Kalgidhar Society is available on https://barusahib.org/.', // Description text
                            textAlign: TextAlign.center, // Center aligned text
                            style: TextStyle(
                                fontFamily: poppinsMedium,
                                fontSize: 15,
                                height: 1.4, // Line height
                                color: themeProvider.darkTheme
                                    ? Colors.white // White text for dark theme
                                    : Colors.black, // Black text for light theme
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 8, // Spacing after description
                        ),
                        // Description underline
                        Container(
                          width: 100,
                          height: 1.5,
                          color: secondPrimaryColor, // Gold underline
                        ),
                        const SizedBox(
                          height: 25, // Spacing before images section
                        ),
                        // Images section title
                        Text(
                          'Baru Sahib Kids doing Kirtan', // Images section title
                          style: TextStyle(
                              fontFamily: poppinsBold,
                              fontSize: 22,
                              color: themeProvider.darkTheme
                                  ? Colors.white // White text for dark theme
                                  : Colors.black, // Black text for light theme
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5, // Spacing after title
                        ),
                        // Images section underline
                        Container(
                          width: 100,
                          height: 1.5,
                          color: secondPrimaryColor, // Gold underline
                        ),
                        const SizedBox(
                          height: 15, // Spacing before images
                        ),
                        // Animated images list
                        AnimationLimiter( // Limit animations for performance
                          child: ListView.builder(
                            shrinkWrap: true, // Shrink to fit content
                            physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                            itemCount: controller.list.length, // Number of images
                            padding: const EdgeInsets.only(top: 0), // No top padding
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 1000), // Animation duration
                                child: SlideAnimation(
                                  verticalOffset: 50.0, // Slide from bottom
                                  duration: const Duration(milliseconds: 1000),
                                  child: FadeInAnimation(
                                    child: Container(
                                      height: screenWidth > 600 ? 400 : 200, // Dynamic height based on screen size
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15), // Container margins
                                      width: widthOfScreen, // Full screen width
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200, // Light grey background
                                        borderRadius: BorderRadius.circular(15), // Rounded corners
                                        image: DecorationImage(
                                          fit: screenWidth > 600
                                              ? BoxFit.cover // Cover for tablets
                                              : BoxFit.cover, // Cover for phones
                                          image: NetworkImage(
                                            controller.list[index].url, // Network image URL
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
