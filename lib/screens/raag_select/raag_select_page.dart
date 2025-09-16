import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/baani/widgets/banni_item.dart';
import 'package:shabadguru/screens/library/library_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

// Screen for selecting Raags for playlist creation
class RaagSelectPage extends StatelessWidget {
  const RaagSelectPage({super.key, required this.indexOfList});

  final int indexOfList; // Index of the playlist being created

  // Build the Raag selection screen UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    return GetBuilder<LibraryController>(
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
            title: const Text(
              'Select Raags', // App bar title
              style: TextStyle(color: Colors.white), // White title text
            ),
            leading: GestureDetector(
              onTap: () {
                controller.isRaagSearchEnable.value = false; // Disable search
                controller.raagSearchValue = ''; // Clear search value
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded, // Back arrow icon
                color: Colors.white, // White icon color
              ),
            ),
            // actions: [
            //   Obx(
            //     () => !controller.isRaagSearchEnable.value
            //         ? IconButton(
            //             onPressed: () {
            //               controller.isRaagSearchEnable.value = true;
            //             },
            //             icon: const Icon(
            //               Icons.search,
            //               color: Colors.white,
            //             ),
            //           )
            //         : const IgnorePointer(),
            //   ),
            // ],
          ),
          body: Column(
            children: [
              // Search bar section - shown when search is enabled
              Obx(() => controller.isRaagSearchEnable.value
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 30, bottom: 30), // Search container margins
                      width: Get.width, // Full width
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0), // No horizontal padding
                              decoration: BoxDecoration(
                                color: Colors.white, // White background
                                borderRadius: BorderRadius.circular(5), // Rounded corners
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey, // Grey shadow
                                    blurRadius: 2, // Shadow blur
                                    offset: Offset(1, 1), // Shadow offset
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  controller.onSearchRaags(value); // Call search function
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search, // Search icon
                                      color: Colors.grey, // Grey icon color
                                    ),
                                    border: InputBorder.none, // No border
                                    hintText: 'Search...', // Search placeholder
                                    hintStyle: TextStyle(color: Colors.grey)), // Grey hint text
                              ),
                            ),
                          ),
                          // Cancel search button
                          IconButton(
                            onPressed: () {
                              controller.isRaagSearchEnable.value = false; // Disable search
                              controller.raagSearchValue = ''; // Clear search value
                            },
                            icon: Icon(
                              Icons.cancel, // Cancel icon
                              color: themeProvider.darkTheme
                                  ? Colors.white // White for dark theme
                                  : darkBlueColor, // Blue for light theme
                            ),
                          ),
                        ],
                      ),
                    )
                  : const IgnorePointer()), // Hide search when disabled
              // Raags list section
              Expanded(
                child: AnimationLimiter( // Limit animations for performance
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true, // Shrink to fit content
                      physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                      itemCount: controller.playlistRaagslist.length, // Number of Raags
                      padding: EdgeInsets.only(
                          top: !controller.isRaagSearchEnable.value ? 30 : 0, // Top padding when search is disabled
                          bottom: 60), // Bottom padding
                      itemBuilder: (context, index) {
                        // Search filtering logic
                        if (controller.isRaagSearchEnable.value &&
                            controller.raagSearchValue.isNotEmpty) {
                          // Check if Raag name contains search term
                          if (controller.playlistRaagslist[index].name
                              .toString()
                              .toLowerCase()
                              .contains(
                                  controller.raagSearchValue.toLowerCase())) {
                            // Show matching Raag with animation
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 1000), // Animation duration
                              child: SlideAnimation(
                                verticalOffset: 50.0, // Slide from bottom
                                duration: const Duration(milliseconds: 1000),
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Load Raag data and navigate to shabad selection
                                      controller.readJson(controller
                                          .playlistRaagslist[index].id
                                          .toString());
                                      goToSelectShabadScreen(
                                          context,
                                          indexOfList, // Playlist index
                                          controller
                                              .playlistRaagslist[index].name); // Raag name
                                    },
                                    child: BanniItem(
                                      banniData:
                                          controller.playlistRaagslist[index], // Raag data
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const IgnorePointer(); // Hide non-matching items
                          }
                        } else {
                          // Show all Raags when search is disabled
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 1000), // Animation duration
                            child: SlideAnimation(
                              verticalOffset: 50.0, // Slide from bottom
                              duration: const Duration(milliseconds: 1000),
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    // Load Raag data and navigate to shabad selection
                                    controller.readJson(controller
                                        .playlistRaagslist[index].id
                                        .toString());
                                    goToSelectShabadScreen(
                                        context,
                                        indexOfList, // Playlist index
                                        controller
                                            .playlistRaagslist[index].name); // Raag name
                                  },
                                  child: BanniItem(
                                    banniData:
                                        controller.playlistRaagslist[index], // Raag data
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
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
