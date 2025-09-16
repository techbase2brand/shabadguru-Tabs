// Baani screen for displaying popular Sikh prayers and hymns
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/baani/widgets/banni_item.dart';
import 'package:shabadguru/screens/home/home_controller.dart';
import 'package:shabadguru/screens/home/widgets/side_drawer.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

// Screen for displaying list of popular Banis with animations
class BaaniScreen extends StatelessWidget {
  const BaaniScreen({super.key});

  // Build the Baani screen UI with responsive design
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
    return GetBuilder<HomeController>(
      init: HomeController(buildContext: context), // Initialize home controller
      builder: (controller) {
        return Scaffold(
          key: controller.keyScaffoldBanis, // Scaffold key for drawer control
          drawer: const SideDrawer(), // Side navigation drawer
          backgroundColor: themeProvider.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          appBar: AppBar(
            centerTitle: true, // Center the title
            leading: GestureDetector(
              onTap: () {
                controller.keyScaffoldBanis.currentState!.openDrawer(); // Open drawer on tap
              },
              child: const Icon(
                Icons.menu, // Menu icon
                color: Colors.white,
              ),
            ),
            toolbarHeight: appBarHeight, // Dynamic toolbar height
            backgroundColor: themeProvider.darkTheme
                ? Colors.black // Dark theme app bar
                : const Color(0XFF24163A), // Light theme app bar
            title: const Text(
              'Popular Banis', // App bar title
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              // Show loading indicator while data is loading
              if (controller.popularBannisModel == null)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.darkTheme
                          ? Colors.white // White loading indicator for dark theme
                          : darkBlueColor, // Blue loading indicator for light theme
                    ),
                  ),
                )
              // Show Bani list when data is loaded
              else if (controller.popularBannisModel!.data != null)
                Expanded(
                  child: AnimationLimiter( // Limit animations for performance
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isTablet = constraints.maxWidth > 800; // Check if device is tablet
                        return isTablet
                            ? GridView.count( // Grid layout for tablets
                                crossAxisCount: 2, // 2 columns
                                childAspectRatio: 5, // Aspect ratio for grid items
                                physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                                padding: const EdgeInsets.all(8.0), // Grid padding
                                mainAxisSpacing: 12, // Vertical spacing between items
                                crossAxisSpacing: 1, // Horizontal spacing between items
                                children: List.generate(
                                  controller.popularBannisModel!.data!.length, // Generate items based on data length
                                  (int i) {
                                    return AnimationConfiguration.staggeredGrid( // Staggered grid animation
                                      columnCount: 2,
                                      position: i,
                                      duration:
                                          const Duration(milliseconds: 1500), // Animation duration
                                      child: SlideAnimation(
                                        verticalOffset: 50.0, // Slide from bottom
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        child: FadeInAnimation(
                                          child: GestureDetector(
                                            onTap: () {
                                              // Navigate to Shabad Banis page
                                              goToShabadBanisPage(
                                                context,
                                                controller.popularBannisModel!
                                                    .data![i].categories![0].id
                                                    .toString(), // Category ID
                                                controller.popularBannisModel!
                                                    .data![i].id
                                                    .toString(), // Bani ID
                                                controller.popularBannisModel!
                                                        .data![i].name ??
                                                    '', // Bani name
                                              );
                                            },
                                            child: BanniItem( // Bani item widget
                                              banniData: controller
                                                  .popularBannisModel!.data![i],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : ListView.builder( // List layout for phones
                                shrinkWrap: true, // Shrink to fit content
                                physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                                itemCount:
                                    controller.popularBannisModel!.data!.length, // Number of items
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 60), // List padding
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList( // Staggered list animation
                                    position: index,
                                    duration:
                                        const Duration(milliseconds: 1000), // Animation duration
                                    child: SlideAnimation(
                                      verticalOffset: 50.0, // Slide from bottom
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigate to Shabad Banis page
                                            goToShabadBanisPage(
                                              context,
                                              controller
                                                  .popularBannisModel!
                                                  .data![index]
                                                  .categories![0]
                                                  .id
                                                  .toString(), // Category ID
                                              controller.popularBannisModel!
                                                  .data![index].id
                                                  .toString(), // Bani ID
                                              controller.popularBannisModel!
                                                      .data![index].name ??
                                                  '', // Bani name
                                            );
                                          },
                                          child: BanniItem( // Bani item widget
                                            banniData: controller
                                                .popularBannisModel!
                                                .data![index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
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
