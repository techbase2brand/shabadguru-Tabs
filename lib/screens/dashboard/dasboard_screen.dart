// ignore_for_file: avoid_print

import 'package:action_broadcast/action_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/screens/dashboard/dashboard_controller.dart';
import 'package:shabadguru/screens/dashboard/mini_music_player.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'dart:io' show Platform;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutoCancelStreamMixin {
  @override
  Iterable<StreamSubscription> get registerSubscriptions sync* {
    yield registerReceiver(['actionMusicPlaying']).listen(
      (intent) {
        switch (intent.action) {
          case 'actionMusicPlaying':
            setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<DashboardController>(
      init: DashboardController(context: context),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              PersistentTabView(
                context,
                controller: controller.tabController,
                screens: controller.buildScreens(),
                navBarHeight: 60, // Adjust this value as needed
                items: controller.navBarsItems(themeProvider),
                confineInSafeArea: true,
                backgroundColor: themeProvider.darkTheme
                    ? Colors.blueGrey.shade900
                    : const Color.fromARGB(
                        255, 239, 242, 248), // Default is Colors.white.
                handleAndroidBackButtonPress: true, // Default is true.
                resizeToAvoidBottomInset: true,
                navBarStyle: NavBarStyle
                    .simple, // Choose the nav bar style with this property.
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: Platform.isIOS
                    ? MediaQuery.of(context).size.width > 600
                        ? 80
                        : 93
                    : 60, // Align it perfectly with the bottom
                child: (audioHandler != null)
                    ? const MiniMusicPlayer()
                    : const IgnorePointer(),
              ),
            ],
          ),
        );
      },
    );
  }
}
