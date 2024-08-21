// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shabadguru/screens/baani/baani_screen.dart';
import 'package:shabadguru/screens/contact_us/contact_us_screen.dart';
import 'package:shabadguru/screens/home/home_screen.dart';
import 'package:shabadguru/screens/raag/raag_screen.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';

class DashboardController extends GetxController {
  DashboardController({required this.context});
  late PersistentTabController tabController;
  int selectIndex = 0;
  final BuildContext context;

  @override
  void onInit() {
    super.onInit();
    tabController = PersistentTabController(initialIndex: 0);
    tabController.addListener(() {
      selectIndex = tabController.index;
      update();
    });
  }

  List<Widget> buildScreens() {
    return [
      HomeScreen(tabController),
      const RaagScreen(),
      const BaaniScreen(),
      const ContactUsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems(
      DarkThemeProvider themeProvider) {
    return [
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              homeSvg,
              height: 20,
              width: 20,
              color: selectIndex == 0
                  ? themeProvider.darkTheme
                      ? Colors.white
                      : const Color(0XFFB68A1E)
                  : Colors.grey,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Home",
              style: TextStyle(
                fontSize: 12,
                fontFamily: poppinsBold,
                color: selectIndex == 0
                    ? themeProvider.darkTheme
                        ? Colors.white
                        : const Color(0XFFB68A1E)
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              raagsSvg,
              height: 20,
              width: 20,
              color: selectIndex == 1
                  ? themeProvider.darkTheme
                      ? Colors.white
                      : const Color(0XFFB68A1E)
                  : Colors.grey,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Raags",
              style: TextStyle(
                fontSize: 12,
                fontFamily: poppinsBold,
                color: selectIndex == 1
                    ? themeProvider.darkTheme
                        ? Colors.white
                        : const Color(0XFFB68A1E)
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              banisSvg,
              height: 20,
              width: 20,
              color: selectIndex == 2
                  ? themeProvider.darkTheme
                      ? Colors.white
                      : const Color(0XFFB68A1E)
                  : Colors.grey,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Banis",
              style: TextStyle(
                fontSize: 12,
                fontFamily: poppinsBold,
                color: selectIndex == 2
                    ? themeProvider.darkTheme
                        ? Colors.white
                        : const Color(0XFFB68A1E)
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SvgPicture.asset(
              contactsUsSvg,
              height: 20,
              width: 20,
              color: selectIndex == 3
                  ? themeProvider.darkTheme
                      ? Colors.white
                      : const Color(0XFFB68A1E)
                  : Colors.grey,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Contact",
              style: TextStyle(
                fontSize: 12,
                fontFamily: poppinsBold,
                color: selectIndex == 3
                    ? themeProvider.darkTheme
                        ? Colors.white
                        : const Color(0XFFB68A1E)
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
    ];
  }
}
