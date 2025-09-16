import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/home/home_controller.dart';
import 'package:shabadguru/screens/home/widgets/side_drawer.dart';
import 'package:shabadguru/screens/raag/widgets/raag_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

// Screen for displaying all Raags with category filtering (Pre Raags, Raags, Post Raags)
class RaagScreen extends StatelessWidget {
  const RaagScreen({super.key});

  // Build the Raags screen UI
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
    return GetBuilder<HomeController>(
      init: HomeController(buildContext: context), // Initialize home controller
      builder: (controller) {
        return Scaffold(
          key: controller.keyScaffoldRags, // Scaffold key for drawer control
          drawer: const SideDrawer(), // Side navigation drawer
          backgroundColor: themeProvider.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          appBar: AppBar(
            centerTitle: true, // Center the title
            // toolbarHeight: 68,
            toolbarHeight: appBarHeight, // Dynamic toolbar height
            leading: GestureDetector(
              onTap: () {
                controller.keyScaffoldRags.currentState!.openDrawer(); // Open drawer on tap
              },
              child: const Icon(
                Icons.menu, // Menu icon
                color: Colors.white, // White icon color
              ),
            ),
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor, // App bar background
            title: const Text(
              'All Raags', // App bar title
              style: TextStyle(color: Colors.white), // White title text
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 15, // Top spacing
              ),
              // Category filter buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
                children: [
                  // Pre Raags filter button
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.updatePreRaags(); // Update to show Pre Raags
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5), // Button padding
                        decoration: BoxDecoration(
                          color: controller.preRaagsSelected.value
                              ? const Color(0XFFB57F12) // Gold when selected
                              : Colors.white, // White when not selected
                          border: Border.all(
                            color: const Color(0XFFB57F12), // Gold border
                          ),
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                        ),
                        child: Text(
                          'Pre Raags', // Button text
                          style: TextStyle(
                              fontFamily: poppinsRegular,
                              color: controller.preRaagsSelected.value
                                  ? Colors.white // White text when selected
                                  : const Color(0XFFB57F12)), // Gold text when not selected
                        ),
                      ),
                    ),
                  ),
                  // Raags filter button
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.updateRaags(); // Update to show Raags
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5), // Button padding
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10, // Horizontal margin between buttons
                        ),
                        decoration: BoxDecoration(
                            color: controller.raagsSelected.value
                                ? const Color(0XFFB57F12) // Gold when selected
                                : Colors.white, // White when not selected
                            border: Border.all(
                              color: const Color(
                                0XFFB57F12, // Gold border
                              ),
                            ),
                            borderRadius: BorderRadius.circular(5)), // Rounded corners
                        child: Text(
                          'Raags', // Button text
                          style: TextStyle(
                            fontFamily: poppinsRegular,
                            color: controller.raagsSelected.value
                                ? Colors.white // White text when selected
                                : const Color(0XFFB57F12), // Gold text when not selected
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Post Raags filter button
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.updatePostRaags(); // Update to show Post Raags
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5), // Button padding
                        decoration: BoxDecoration(
                            color: controller.postRaagsSelected.value
                                ? const Color(0XFFB57F12) // Gold when selected
                                : Colors.white, // White when not selected
                            border: Border.all(
                              color: const Color(
                                0XFFB57F12, // Gold border
                              ),
                            ),
                            borderRadius: BorderRadius.circular(5)), // Rounded corners
                        child: Text(
                          'Post Raags', // Button text
                          style: TextStyle(
                              fontFamily: poppinsRegular,
                              color: controller.postRaagsSelected.value
                                  ? Colors.white // White text when selected
                                  : const Color(0XFFB57F12)), // Gold text when not selected
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15, // Spacing after filter buttons
              ),
              // Loading state - show when data is loading
              if (controller.popularRaagsModel == null)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: darkBlueColor, // Loading indicator color
                    ),
                  ),
                )
              // Raags list - show when data is loaded
              else if (controller.popularRaagsModel!.data != null)
                // Expanded(
                //   child: AnimationLimiter(
                //     child: ListView.builder(
                //       shrinkWrap: true,
                //       physics: const BouncingScrollPhysics(),
                //       itemCount: controller.raagsSelected.value
                //           ? controller.popularRaagsModel!.data!.length
                //           : controller.preRaagsSelected.value
                //               ? controller.popularRaagsModel!.preRaags!.length
                //               : controller.popularRaagsModel!.postRaags!.length,
                //       padding: const EdgeInsets.only(top: 0, bottom: 60),
                //       itemBuilder: (context, index) {
                //         return AnimationConfiguration.staggeredList(
                //           position: index,
                //           duration: const Duration(milliseconds: 1000),
                //           child: SlideAnimation(
                //             verticalOffset: 50.0,
                //             duration: const Duration(milliseconds: 1000),
                //             child: FadeInAnimation(
                //               child: GestureDetector(
                //                 onTap: () {
                //                   if (controller.raagsSelected.value) {
                //                     goToShabadRaagPage(
                //                         context,
                //                         controller.popularRaagsModel!
                //                             .data![index].categories![0].id
                //                             .toString(),
                //                         controller
                //                             .popularRaagsModel!.data![index].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                                 .data![index].name ??
                //                             '');
                //                   } else if (controller
                //                       .preRaagsSelected.value) {
                //                     goToShabadRaagPage(
                //                         context,
                //                         controller.popularRaagsModel!
                //                             .preRaags![index].categories![0].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                             .preRaags![index].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                                 .preRaags![index].name ??
                //                             '');
                //                   } else {
                //                     goToShabadRaagPage(
                //                         context,
                //                         controller.popularRaagsModel!
                //                             .postRaags![index].categories![0].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                             .postRaags![index].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                                 .postRaags![index].name ??
                //                             '');
                //                   }
                //                 },
                //                 child: RaagItem(
                //                   raagData: controller.raagsSelected.value
                //                       ? controller
                //                           .popularRaagsModel!.data![index]
                //                       : controller.preRaagsSelected.value
                //                           ? controller.popularRaagsModel!
                //                               .preRaags![index]
                //                           : controller.popularRaagsModel!
                //                               .postRaags![index],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
                Expanded(
                  child: MediaQuery.of(context).size.width > 800
                      // Tablet view - Grid layout
                      ? GridView.count(
                          crossAxisCount: 2, // Two items per row
                          childAspectRatio: 5, // Aspect ratio of the grid items
                          physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                          padding: const EdgeInsets.all(8.0), // Grid padding
                          mainAxisSpacing: 10, // Vertical spacing between items
                          crossAxisSpacing: 1, // Horizontal spacing between items
                          children: List.generate(
                            // Generate items based on selected category
                            controller.raagsSelected.value
                                ? controller.popularRaagsModel!.data!.length // Raags count
                                : controller.preRaagsSelected.value
                                    ? controller
                                        .popularRaagsModel!.preRaags!.length // Pre Raags count
                                    : controller
                                        .popularRaagsModel!.postRaags!.length, // Post Raags count
                            (int i) {
                              // Get raag data based on selected category
                              var raagData = controller.raagsSelected.value
                                  ? controller.popularRaagsModel!.data![i] // Raags data
                                  : controller.preRaagsSelected.value
                                      ? controller
                                          .popularRaagsModel!.preRaags![i] // Pre Raags data
                                      : controller
                                          .popularRaagsModel!.postRaags![i]; // Post Raags data

                              return AnimationConfiguration.staggeredGrid(
                                columnCount: 2, // Grid column count
                                position: i, // Animation position
                                duration: const Duration(milliseconds: 1500), // Animation duration
                                child: SlideAnimation(
                                  verticalOffset: 50.0, // Slide from bottom
                                  duration: const Duration(milliseconds: 1500),
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to Shabad Raag page
                                        goToShabadRaagPage(
                                          context,
                                          raagData.categories![0].id.toString(), // Category ID
                                          raagData.id.toString(), // Raag ID
                                          raagData.name ?? '', // Raag name
                                        );
                                      },
                                      child: RaagItem(
                                        raagData: raagData, // Pass raag data to item widget
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      // Mobile view - List layout
                      : AnimationLimiter(
                          child: ListView.builder(
                            shrinkWrap: true, // Shrink to fit content
                            physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                            itemCount: controller.raagsSelected.value
                                ? controller.popularRaagsModel!.data!.length // Raags count
                                : controller.preRaagsSelected.value
                                    ? controller
                                        .popularRaagsModel!.preRaags!.length // Pre Raags count
                                    : controller
                                        .popularRaagsModel!.postRaags!.length, // Post Raags count
                            padding: const EdgeInsets.only(top: 0, bottom: 60), // List padding
                            itemBuilder: (context, index) {
                              // Get raag data based on selected category
                              var raagData = controller.raagsSelected.value
                                  ? controller.popularRaagsModel!.data![index] // Raags data
                                  : controller.preRaagsSelected.value
                                      ? controller
                                          .popularRaagsModel!.preRaags![index] // Pre Raags data
                                      : controller
                                          .popularRaagsModel!.postRaags![index]; // Post Raags data

                              return AnimationConfiguration.staggeredList(
                                position: index, // Animation position
                                duration: const Duration(milliseconds: 1000), // Animation duration
                                child: SlideAnimation(
                                  verticalOffset: 50.0, // Slide from bottom
                                  duration: const Duration(milliseconds: 1000),
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to Shabad Raag page
                                        goToShabadRaagPage(
                                          context,
                                          raagData.categories![0].id.toString(), // Category ID
                                          raagData.id.toString(), // Raag ID
                                          raagData.name ?? '', // Raag name
                                        );
                                      },
                                      child: RaagItem(
                                        raagData: raagData, // Pass raag data to item widget
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
