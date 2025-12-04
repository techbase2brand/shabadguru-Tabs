// Screen for displaying Nitnem list (Daily prayers)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/home/widgets/side_drawer.dart';
import 'package:shabadguru/screens/nitnem/nitnem_controller.dart';
import 'package:shabadguru/screens/nitnem/widgets/nitnem_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/routes.dart';
import 'dart:convert';

// Screen for displaying list of Nitnem with animations
class NitnemScreen extends StatelessWidget {
  const NitnemScreen({super.key});

  // Helper function to map Nitnem name to JSON file name
  String _getNitnemFileName(String name) {
    // Normalize name: trim whitespace and convert to uppercase
    String normalizedName = name.trim().toUpperCase();
    
    // Map API names to local JSON file names
    switch (normalizedName) {
      case 'JAAP SAHIB':
        return 'shabad3.json';
      case 'JAPJI SAHIB':
        return 'shabad1.json';
      case 'CHAUPAI SAHIB':
        return 'shabad2.json';
      case 'ANAND SAHIB':
        return 'shabad4.json';
      case 'SHABAD HAZARE':
        return 'shabad5.json';
      case 'TAU PRASAD SAVAIYE':
      case 'TAV PRASAD SAVAIYE': // Handle both spellings
        return 'shabad6.json';  
      // Add more mappings as needed
      default:
        // Try to match partial names
        if (normalizedName.contains('HAZARE')) {
          return 'shabad5.json';
        }
        if (normalizedName.contains('PRASAD') && normalizedName.contains('SAVAIYE')) {
          return 'shabad6.json';
        }
        return '$name.json'; // Fallback to name.json
    }
  }

  // Build the Nitnem screen UI with responsive design
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive design

    // Calculate app bar height based on screen size
    double appBarHeight;
    if (screenWidth > 600) {
      appBarHeight = 99; // Fixed height for tablets
    } else {
      appBarHeight = widthOfScreen * 0.15; // Responsive height for phones
    }
    
    return GetBuilder<NitnemController>(
      init: NitnemController(buildContext: context), // Initialize Nitnem controller
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          appBar: AppBar(
            centerTitle: true, // Center the title
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded, // Back arrow icon
                color: Colors.white, // White icon color
              ),
            ),
            toolbarHeight: appBarHeight, // Dynamic toolbar height
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor, // App bar background
            title: const Text(
              'Nitnem', // Display Nitnem title
              style: TextStyle(color: Colors.white), // White title text
            ),
          ),
          body: Column(
            children: [
              // Show loading indicator while data is loading
              if (controller.nitnemModel == null)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.darkTheme
                          ? Colors.white // White loading indicator for dark theme
                          : darkBlueColor, // Blue loading indicator for light theme
                    ),
                  ),
                )
              // Show error message if data failed to load
              else if (controller.nitnemModel!.error != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: themeProvider.darkTheme ? Colors.white : Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.nitnemModel!.error ?? 'Failed to load data',
                          style: TextStyle(
                            color: themeProvider.darkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            controller.getNitnemData(); // Retry loading from API
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              // Show Nitnem list when data is loaded
              else if (controller.nitnemModel!.data != null)
                Expanded(
                  child: AnimationLimiter( // Limit animations for performance
                    child: ListView.builder(
                      shrinkWrap: true, // Shrink to fit content
                      physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                      itemCount: controller.nitnemModel!.data!.length, // Number of Nitnem items
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
                                onTap: () async {
                                  // Load Nitnem data from local JSON file (like Banis)
                                  final nitnemData = controller.nitnemModel!.data![index];
                                  String nitnemName = nitnemData.name?.toString() ?? 'Nitnem'; // Declare outside try-catch
                                  try {
                                    // Map Nitnem name to file name
                                    String fileName = _getNitnemFileName(nitnemName);
                                    print('Loading Nitnem: $nitnemName -> File: $fileName'); // Debug log
                                    
                                    final String response = await rootBundle
                                        .loadString('assets/nitnem_data/$fileName');
                                    final data = await json.decode(response);
                                    final shabadRaagModel = ShabadRaagModel.fromJson(data);
                                    
                                    if (shabadRaagModel.data != null && shabadRaagModel.data!.isNotEmpty) {
                                      // Use ShabadData from JSON file (has all lyrics arrays)
                                      final shabadData = shabadRaagModel.data![0];
                                      final listOfShabads = [shabadData];
                                      goToMusicPlayerPage(
                                        context,
                                        shabadData,
                                        nitnemName,
                                        listOfShabads,
                                      );
                                    } else {
                                      print('Warning: JSON file $fileName has no data'); // Debug log
                                      // Fallback: Create ShabadData manually if JSON not found
                                      final shabadData = ShabadData(
                                        title: nitnemName,
                                        song: nitnemName,
                                        author: 'Nitnem',
                                        audio: nitnemData.file?.toString() ?? '',
                                        jsonData: nitnemData.lyricsFile?.toString() ?? '',
                                        albumart: '',
                                      );
                                      final listOfShabads = [shabadData];
                                      goToMusicPlayerPage(
                                        context,
                                        shabadData,
                                        nitnemName,
                                        listOfShabads,
                                      );
                                    }
                                  } catch (e) {
                                    print('Error loading Nitnem file for $nitnemName: $e'); // Debug log
                                    // Fallback: Create ShabadData manually if JSON file not found
                                    final shabadData = ShabadData(
                                      title: nitnemName,
                                      song: nitnemName,
                                      author: 'Nitnem',
                                      audio: nitnemData.file?.toString() ?? '',
                                      jsonData: nitnemData.lyricsFile?.toString() ?? '',
                                      albumart: '',
                                    );
                                    final listOfShabads = [shabadData];
                                    goToMusicPlayerPage(
                                      context,
                                      shabadData,
                                      nitnemName,
                                      listOfShabads,
                                    );
                                  }
                                },
                                child: NitnemItem(
                                  nitnemData: controller.nitnemModel!.data![index],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              // Show empty state if no data
              else
                Expanded(
                  child: Center(
                    child: Text(
                      'No Nitnem available',
                      style: TextStyle(
                        color: themeProvider.darkTheme ? Colors.white : Colors.black,
                      ),
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
