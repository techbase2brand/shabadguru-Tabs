// ignore_for_file: deprecated_member_use

// Controller for managing dashboard navigation and tab states
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shabadguru/screens/baani/baani_screen.dart';
import 'package:shabadguru/screens/contact_us/contact_us_screen.dart';
import 'package:shabadguru/screens/home/home_screen.dart';
import 'package:shabadguru/screens/raag/raag_screen.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';

// Controller for managing dashboard navigation tabs and screens
class DashboardController extends GetxController {
  DashboardController({required this.context}); // Constructor with context
  late PersistentTabController tabController; // Tab controller for navigation
  int selectIndex = 0; // Currently selected tab index
  final BuildContext context; // Build context

  // Initialize controller and set up tab listener
  @override
  void onInit() {
    super.onInit();
    tabController = PersistentTabController(initialIndex: 0); // Initialize with first tab
    tabController.addListener(() {
      selectIndex = tabController.index; // Update selected index
      update(); // Update UI
    });
  }

  // Build list of screens for bottom navigation
  List<Widget> buildScreens() {
    return [
      HomeScreen(tabController), // Home screen with tab controller
      const RaagScreen(), // Raag screen
      const BaaniScreen(), // Baani screen
      const ContactUsScreen(), // Contact us screen
    ];
  }

  // Build navigation bar items with theme support
  List<PersistentBottomNavBarItem> navBarsItems(
      DarkThemeProvider themeProvider) {
    return [
      // Home tab item
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              homeSvg, // Home icon
              height: 20,
              width: 20,
              color: selectIndex == 0
                  ? themeProvider.darkTheme
                      ? Colors.white // White for dark theme when selected
                      : const Color(0XFFB68A1E) // Gold for light theme when selected
                  : Colors.grey, // Grey when not selected
            ),
            const SizedBox(
              height: 4, // Spacing between icon and text
            ),
            Text(
              "Home", // Home tab label
              style: TextStyle(
                fontSize: 12,
                fontFamily: poppinsBold,
                color: selectIndex == 0
                    ? themeProvider.darkTheme
                        ? Colors.white // White for dark theme when selected
                        : const Color(0XFFB68A1E) // Gold for light theme when selected
                    : Colors.grey, // Grey when not selected
              ),
            )
          ],
        ),
      ),
      // Raags tab item
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              raagsSvg, // Raags icon
              height: 20,
              width: 20,
              color: selectIndex == 1
                  ? themeProvider.darkTheme
                      ? Colors.white // White for dark theme when selected
                      : const Color(0XFFB68A1E) // Gold for light theme when selected
                  : Colors.grey, // Grey when not selected
            ),
            const SizedBox(
              height: 4, // Spacing between icon and text
            ),
            Text(
              "Raags", // Raags tab label
              style: TextStyle(
                fontSize: 12,
                fontFamily: poppinsBold,
                color: selectIndex == 1
                    ? themeProvider.darkTheme
                        ? Colors.white // White for dark theme when selected
                        : const Color(0XFFB68A1E) // Gold for light theme when selected
                    : Colors.grey, // Grey when not selected
              ),
            )
          ],
        ),
      ),
      // Banis tab item
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              banisSvg, // Banis icon
              height: 20,
              width: 20,
              color: selectIndex == 2
                  ? themeProvider.darkTheme
                      ? Colors.white // White for dark theme when selected
                      : const Color(0XFFB68A1E) // Gold for light theme when selected
                  : Colors.grey, // Grey when not selected
            ),
            const SizedBox(
              height: 4, // Spacing between icon and text
            ),
            Text(
              "Banis", // Banis tab label
              style: TextStyle(
                fontSize: 12,
                fontFamily: poppinsBold,
                color: selectIndex == 2
                    ? themeProvider.darkTheme
                        ? Colors.white // White for dark theme when selected
                        : const Color(0XFFB68A1E) // Gold for light theme when selected
                    : Colors.grey, // Grey when not selected
              ),
            )
          ],
        ),
      ),
      // Contact tab item
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              contactsUsSvg, // Contact icon
              height: 20,
              width: 20,
              color: selectIndex == 3
                  ? themeProvider.darkTheme
                      ? Colors.white // White for dark theme when selected
                      : const Color(0XFFB68A1E) // Gold for light theme when selected
                  : Colors.grey, // Grey when not selected
            ),
            const SizedBox(
              height: 4, // Spacing between icon and text
            ),
            Text(
              "Contact", // Contact tab label
              style: TextStyle(
                fontSize: 12,
                fontFamily: poppinsBold,
                color: selectIndex == 3
                    ? themeProvider.darkTheme
                        ? Colors.white // White for dark theme when selected
                        : const Color(0XFFB68A1E) // Gold for light theme when selected
                    : Colors.grey, // Grey when not selected
              ),
            )
          ],
        ),
      ),
    ];
  }
}
