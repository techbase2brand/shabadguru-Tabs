import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        width: screenWidth > 600 ? Get.width * 0.40 : Get.width * 0.70,
        height: Get.height - 60,
        color:
            themeProvider.darkTheme ? Colors.blueGrey.shade900 : darkBlueColor,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 45, bottom: 5),
                    height: widthOfScreen * 0.14,
                    child: Image.asset(appBarLogo),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                goToLibraryPage(context, false, null);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: poppinsBold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                goToMyFavoriteScreen(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_vintage_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'My favorite',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: poppinsBold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                goToSettingScreen(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: poppinsBold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                goToEmailSubscribeScreen(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notification_important_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'News letter subscribe',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: poppinsBold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUrlString('https://in.pinterest.com/shabadguruorg/',
                        mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SvgPicture.asset(
                      pinterestSvg,
                      color: themeProvider.darkTheme
                          ? Colors.black
                          : darkBlueColor,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    launchUrlString(
                        'https://www.instagram.com/shabadguru_official/',
                        mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SvgPicture.asset(
                      instagramSvg,
                      color: themeProvider.darkTheme
                          ? Colors.black
                          : darkBlueColor,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    launchUrlString(
                        'https://www.youtube.com/channel/UCdxMJWYl3N5nCB7dghN7GEA',
                        mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SvgPicture.asset(
                      youtubeSvg,
                      color: themeProvider.darkTheme
                          ? Colors.black
                          : darkBlueColor,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    launchUrlString(
                        'https://www.facebook.com/shabadguruofficial',
                        mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SvgPicture.asset(
                      facebookSvg,
                      color: themeProvider.darkTheme
                          ? Colors.black
                          : darkBlueColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
