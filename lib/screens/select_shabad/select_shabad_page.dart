// Screen for selecting Shabads to add to a playlist
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/library/library_controller.dart';
import 'package:shabadguru/screens/select_shabad/select_shabad_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

// Screen for selecting multiple Shabads to add to a playlist
class SelectShabadPage extends StatelessWidget {
  const SelectShabadPage(
      {super.key, required this.indexOfList, required this.title});

  final int indexOfList; // Index of the playlist in the library
  final String title; // Title of the playlist
  // Build the select Shabad page UI
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
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor, // App bar background
            title: const Text(
              'Select Shabad', // App bar title
              style: TextStyle(color: Colors.white), // White title text
            ),
            leading: GestureDetector(
              onTap: () {
                controller.isShabadSearchEnable.value = false; // Disable search
                controller.shabadSearchValue = ''; // Clear search value
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded, // Back arrow icon
                color: Colors.white, // White icon color
              ),
            ),
            // actions: [
            //   Obx(
            //     () => !controller.isShabadSearchEnable.value
            //         ? IconButton(
            //             onPressed: () {
            //               controller.isShabadSearchEnable.value = true;
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
              Obx(() => controller.isShabadSearchEnable.value
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
                                  controller.onSearchShabad(value); // Call search function
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
                              controller.isShabadSearchEnable.value = false; // Disable search
                              controller.shabadSearchValue = ''; // Clear search value
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
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true, // Shrink to fit content
                        physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                        itemCount: controller.shabadRaagModel!.data!.length, // Number of Shabads
                        padding: EdgeInsets.only(
                            top:
                                !controller.isShabadSearchEnable.value ? 30 : 0, // Top padding when search is disabled
                            bottom: 60), // Bottom padding
                        itemBuilder: (context, index) {
                          // Search filtering logic
                          if (controller.isShabadSearchEnable.value &&
                              controller.shabadSearchValue.isNotEmpty) {
                            // Check if Shabad song name contains search term
                            if (controller.shabadRaagModel!.data![index].song
                                .toString()
                                .toLowerCase()
                                .contains(controller.shabadSearchValue
                                    .toLowerCase())) {
                              // Show matching Shabad with animation
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 1000), // Animation duration
                                child: SlideAnimation(
                                  verticalOffset: 50.0, // Slide from bottom
                                  duration: const Duration(milliseconds: 1000),
                                  child: FadeInAnimation(
                                    child: SelectShabadItem(
                                      shabadData: controller
                                          .shabadRaagModel!.data![index], // Shabad data
                                      isSelectedForPlaylist: () {
                                        // Toggle selection state
                                        controller.shabadRaagModel!.data![index]
                                                .isSelectedForPlaylist =
                                            !controller
                                                .shabadRaagModel!
                                                .data![index]
                                                .isSelectedForPlaylist;
                                        controller.update(); // Update UI
                                        if (controller
                                            .shabadRaagModel!
                                            .data![index]
                                            .isSelectedForPlaylist) {
                                          // Add to selected list if not already present
                                          if (!controller.selectedShabadList
                                              .contains(controller
                                                  .shabadRaagModel!
                                                  .data![index])) {
                                            controller.selectedShabadList.add(
                                                controller.shabadRaagModel!
                                                    .data![index]);
                                          }
                                        } else {
                                          // Remove from selected list
                                          controller.selectedShabadList
                                              .removeWhere((element) =>
                                                  element.audio ==
                                                  controller.shabadRaagModel!
                                                      .data![index].audio);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const IgnorePointer(); // Hide non-matching items
                            }
                          } else {
                            // Show all Shabads with animation when not searching
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 1000), // Animation duration
                              child: SlideAnimation(
                                verticalOffset: 50.0, // Slide from bottom
                                duration: const Duration(milliseconds: 1000),
                                child: FadeInAnimation(
                                  child: SelectShabadItem(
                                    shabadData: controller
                                        .shabadRaagModel!.data![index], // Shabad data
                                    isSelectedForPlaylist: () {
                                      // Toggle selection state
                                      controller.shabadRaagModel!.data![index]
                                              .isSelectedForPlaylist =
                                          !controller
                                              .shabadRaagModel!
                                              .data![index]
                                              .isSelectedForPlaylist;
                                      controller.update(); // Update UI
                                      if (controller.shabadRaagModel!
                                          .data![index].isSelectedForPlaylist) {
                                        // Add to selected list if not already present
                                        if (!controller.selectedShabadList
                                            .contains(controller
                                                .shabadRaagModel!
                                                .data![index])) {
                                          controller.shabadRaagModel!
                                              .data![index].title = title; // Set playlist title
                                          controller.selectedShabadList.add(
                                              controller.shabadRaagModel!
                                                  .data![index]);
                                        }
                                      } else {
                                        // Remove from selected list
                                        controller.selectedShabadList
                                            .removeWhere((element) =>
                                                element.audio ==
                                                controller.shabadRaagModel!
                                                    .data![index].audio);
                                      }
                                    },
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
              // Save playlist button container
              Container(
                width: Get.width, // Full width
                color: themeProvider.darkTheme
                    ? Colors.blueGrey.shade900 // Dark theme background
                    : Colors.white, // Light theme background
                padding: const EdgeInsets.symmetric(vertical: 20), // Vertical padding
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            themeProvider.darkTheme
                                ? Colors.white // White background for dark theme
                                : darkBlueColor)), // Blue background for light theme
                    onPressed: () {
                      controller.savePlaylist(indexOfList); // Save playlist with selected Shabads
                      Navigator.of(context).pop(); // Navigate back to library
                      Navigator.of(context).pop(); // Navigate back to previous screen
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20), // Horizontal padding
                      child: Text(
                        'Save Playlist', // Button text
                        style: TextStyle(
                            color: themeProvider.darkTheme
                                ? Colors.black // Black text for dark theme
                                : Colors.white, // White text for light theme
                            fontFamily: poppinsBold,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
