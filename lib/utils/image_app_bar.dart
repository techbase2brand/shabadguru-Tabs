// Custom app bar widget with logo and navigation controls
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';

// Custom app bar widget with ShabadGuru logo and responsive design
class ImageAppBar extends StatelessWidget {
  const ImageAppBar(
      {super.key,
      required this.onDrwaerTap,
      required this.showDrawer,
      required this.showBack});

  final Function onDrwaerTap; // Callback function for drawer tap
  final bool showDrawer; // Whether to show drawer button
  final bool showBack; // Whether to show back button

  // Build the custom app bar with responsive design
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive design
    double imageHeight; // Logo height
    double imageWidth; // Logo width
    double appBarHeight; // App bar height
    
    // Responsive design based on screen width
    if (screenWidth > 600) {
      // Tablet layout - larger dimensions
      appBarHeight = 99; // Fixed height for tablets
      imageHeight = widthOfScreen * 0.9; // Logo height for tablets
      imageWidth = widthOfScreen * 0.20; // Logo width for tablets
    } else {
      // Mobile layout - smaller dimensions
      appBarHeight = 60; // Fixed height for mobile
      imageHeight = screenWidth * 0.14; // Logo height for mobile
      imageWidth = screenWidth * 0.35; // Logo width for mobile
    }
    return AppBar(
      backgroundColor:
          themeProvider.darkTheme ? Colors.black : const Color(0XFF24163A), // Theme-aware background color
      leading: showDrawer
          ? GestureDetector(
              onTap: () {
                onDrwaerTap(); // Call drawer tap callback
              },
              child: const Icon(
                Icons.menu, // Menu icon for drawer
                color: Colors.white, // White icon color
              ),
            )
          : showBack
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Navigate back
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded, // Back arrow icon
                    color: Colors.white, // White icon color
                  ),
                )
              : const IgnorePointer(), // Hide leading widget if neither drawer nor back is shown
      centerTitle: true, // Center the title/logo
      title: Container(
        margin: const EdgeInsets.only(bottom: 5), // Bottom margin for logo positioning
        height: imageHeight, // Responsive logo height
        width: imageWidth, // Responsive logo width
        child: Image.asset(appBarLogo), // ShabadGuru logo
      ),
      toolbarHeight: appBarHeight, // Responsive toolbar height
    );
    // return Container(
    //   width: widthOfScreen,
    //   color: themeProvider.darkTheme?Colors.black: darkBlueColor,
    //   child: Stack(
    //     children: [
    //       if(showDrawer)
    //       SafeArea(
    //         child: GestureDetector(
    //           onTap: (){
    //             onDrwaerTap();
    //           },
    //           child: Container(
    //             margin: const EdgeInsets.only(left: 20, top: 20),
    //             child: const Icon(
    //               Icons.menu,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ),
    //       if(showBack)
    //       SafeArea(
    //         child: GestureDetector(
    //           onTap: (){
    //             Navigator.of(context).pop();
    //           },
    //           child: Container(
    //             margin: const EdgeInsets.only(left: 20, top: 20),
    //             child: const Icon(
    //               Icons.arrow_back_ios_new_rounded,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ),
    //         Center(
    //           child: Container(
    //             margin: const EdgeInsets.only(top: 45, bottom: 5),
    //             height: widthOfScreen * 0.14,
    //             width: widthOfScreen * 0.35,
    //             child: Image.asset(appBarLogo),
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }
}
