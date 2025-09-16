// ignore_for_file: avoid_print

// Main dashboard screen with bottom navigation and mini music player
import 'package:action_broadcast/action_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/screens/dashboard/dashboard_controller.dart';
import 'package:shabadguru/screens/dashboard/mini_music_player.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'dart:io' show Platform;

// Main dashboard screen with persistent bottom navigation and music player
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

// Dashboard screen state with music player broadcast handling
class _DashboardScreenState extends State<DashboardScreen>
    with AutoCancelStreamMixin {
  // Register for music player state changes
  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver(['actionMusicPlaying']).listen(
      (intent) {
        switch (intent.action) {
          case 'actionMusicPlaying':
            setState(() {}); // Update UI when music state changes
            break;
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final themeProvider = Provider.of<DarkThemeProvider>(context);
  //   return GetBuilder<DashboardController>(
  //     init: DashboardController(context: context),
  //     builder: (controller) {
  //       return Scaffold(
  //         body: PersistentTabView(
  //           context,
  //           controller: controller.tabController,
  //           screens: controller.buildScreens(),
  //           navBarHeight: 60,
  //           items: controller.navBarsItems(themeProvider),
  //           confineInSafeArea: true,
  //           backgroundColor: themeProvider.darkTheme
  //               ? Colors.blueGrey.shade900
  //               : const Color.fromARGB(
  //                   255, 239, 242, 248), // Default is Colors.white.
  //           handleAndroidBackButtonPress: true, // Default is true.
  //           resizeToAvoidBottomInset: true,
  //           floatingActionButton: (audioHandler != null)
  //               ? const MiniMusicPlayer()
  //               : const IgnorePointer(),
  //           navBarStyle: NavBarStyle
  //               .simple, // Choose the nav bar style with this property.
  //         ),
  //       );
  //     },
  //   );
  // }

  // Build the main dashboard UI with navigation and music player
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    return GetBuilder<DashboardController>(
      init: DashboardController(context: context), // Initialize dashboard controller
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              // Main persistent tab view with bottom navigation
              PersistentTabView(
                context,
                controller: controller.tabController, // Tab controller
                screens: controller.buildScreens(), // List of screens
                navBarHeight: 60, // Navigation bar height
                items: controller.navBarsItems(themeProvider), // Navigation items
                confineInSafeArea: true, // Confine to safe area
                backgroundColor: themeProvider.darkTheme
                    ? Colors.blueGrey.shade900 // Dark theme background
                    : const Color.fromARGB(255, 239, 242, 248), // Light theme background
                handleAndroidBackButtonPress: true, // Handle back button
                resizeToAvoidBottomInset: true, // Resize for keyboard
                navBarStyle: NavBarStyle.simple, // Simple navigation bar style
              ),
              // Mini music player positioned above navigation bar
              Positioned(
                left: 0,
                right: 0,
                bottom: Platform.isIOS
                    ? MediaQuery.of(context).size.width > 600
                        ? 80 // iPad bottom position
                        : 93 // iPhone bottom position
                    : 60, // Android bottom position
                child: (audioHandler != null)
                    ? const MiniMusicPlayer() // Show mini player when music is playing
                    : const IgnorePointer(), // Hide when no music
              ),
            ],
          ),
        );
      },
    );
  }
}
