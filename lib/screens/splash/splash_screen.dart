// Splash screen for app startup with logo and background
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shabadguru/screens/splash/splash_controller.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/global.dart';

// Splash screen widget with animated logo and background images
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // Build the splash screen UI with layered background and logo
  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width; // Set global screen width
    heightOfScreen = MediaQuery.of(context).size.height; // Set global screen height
    return GetBuilder<SplashController>(
      init: SplashController(), // Initialize splash controller
      builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              // Background image container
              Container(
                width: widthOfScreen, // Full screen width
                height: heightOfScreen, // Full screen height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover, // Cover entire container
                    image: AssetImage(splashBack), // Background image asset
                  ),
                ),
              ),
              // Sun overlay image container
              Container(
                width: widthOfScreen, // Full screen width
                height: heightOfScreen, // Full screen height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover, // Cover entire container
                    image: AssetImage(splashSun), // Sun overlay image asset
                  ),
                ),
              ),
              // Centered logo container
              Center(
                child: Container(
                  width: widthOfScreen * 0.45, // 45% of screen width
                  height: widthOfScreen * 0.45, // 45% of screen width (square)
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(splashLogo), // Logo image asset
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
