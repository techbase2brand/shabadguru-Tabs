// Library details screen for displaying playlist or favorite contents
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/library/library_controller.dart';
import 'package:shabadguru/screens/library_details/library_details_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

// Screen for displaying detailed view of library items (playlists or favorites)
class LibraryDetails extends StatelessWidget {
  const LibraryDetails(
      {super.key, required this.title, required this.libraryIndex});

  final String title; // Screen title
  final int libraryIndex; // Library item index

  // Build the library details screen UI
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
            title: Text(
              title, // Display screen title
              style: const TextStyle(color: Colors.white), // White title text
            ),
            leading: GestureDetector(
              onTap: () {
                controller.isSearchEnable.value = false; // Disable search
                controller.searchValue = ''; // Clear search value
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded, // Back arrow icon
                color: Colors.white, // White icon color
              ),
            ),
            // actions: [
            //   Obx(
            //     () => !controller.isSearchEnable.value
            //         ? IconButton(
            //             onPressed: () {
            //               controller.isSearchEnable.value = true;
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
              Obx(() => controller.isSearchEnable.value
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
                                  controller.onSearch(value); // Call search function
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
                              controller.isSearchEnable.value = false; // Disable search
                              controller.searchValue = ''; // Clear search value
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
              // Empty state - show when no shabads are found
              if (controller.shabadListOfLibrary.isEmpty)
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
                          'No Shabad Found', // Empty state message
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
              // Shabad list - show when shabads are available
              else if (controller.shabadListOfLibrary.isNotEmpty)
                Expanded(
                  child: AnimationLimiter( // Limit animations for performance
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true, // Shrink to fit content
                        physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                        itemCount: controller.shabadListOfLibrary.length, // Number of shabads
                        padding: EdgeInsets.only(
                            top: !controller.isSearchEnable.value ? 30 : 0, // Top padding when search is disabled
                            bottom: 60), // Bottom padding
                        itemBuilder: (context, index) {
                          // Search filtering logic
                          if (controller.isSearchEnable.value &&
                              controller.searchValue.isNotEmpty) {
                            // Check if shabad song name contains search term
                            if (controller.shabadListOfLibrary[index].song
                                .toString()
                                .toLowerCase()
                                .contains(
                                    controller.searchValue.toLowerCase())) {
                              // Show matching shabad with animation
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 1000), // Animation duration
                                child: SlideAnimation(
                                  verticalOffset: 50.0, // Slide from bottom
                                  duration: const Duration(milliseconds: 1000),
                                  child: FadeInAnimation(
                                    child: LibraryDetailsItem(
                                      shabadData:
                                          controller.shabadListOfLibrary[index], // Shabad data
                                      onMenuTaped: () {
                                        // Show popup menu for shabad options
                                        controller.showPopupForShabadMenu(
                                            context,
                                            controller
                                                .shabadListOfLibrary[index],
                                            libraryIndex,
                                            index);
                                      },
                                      onTaped: () {
                                        // Navigate to music player page
                                        goToMusicPlayerPage(
                                          context,
                                          controller.shabadListOfLibrary[index],
                                          controller.shabadListOfLibrary[index]
                                                  .title ??
                                              '', // Shabad title
                                          controller.shabadListOfLibrary, // Full shabad list
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const IgnorePointer(); // Hide non-matching items
                            }
                          } else {
                            // Show all shabads when search is disabled
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 1000), // Animation duration
                              child: SlideAnimation(
                                verticalOffset: 50.0, // Slide from bottom
                                duration: const Duration(milliseconds: 1000),
                                child: FadeInAnimation(
                                  child: LibraryDetailsItem(
                                    shabadData:
                                        controller.shabadListOfLibrary[index], // Shabad data
                                    onMenuTaped: () {
                                      // Show popup menu for shabad options
                                      controller.showPopupForShabadMenu(
                                          context,
                                          controller.shabadListOfLibrary[index],
                                          libraryIndex,
                                          index);
                                    },
                                    onTaped: () {
                                      // Navigate to music player page
                                      goToMusicPlayerPage(
                                          context,
                                          controller.shabadListOfLibrary[index],
                                          controller.shabadListOfLibrary[index]
                                                  .title ??
                                              '', // Shabad title
                                          controller.shabadListOfLibrary); // Full shabad list
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
            ],
          ),
        );
      },
    );
  }
}
