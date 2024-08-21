import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/settings/setting_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/image_app_bar.dart';
import 'package:shabadguru/utils/shared_pref.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      init: SettingController(),
      builder: (controller) {
        controller.themeProvider = Provider.of<DarkThemeProvider>(context);
        controller.getDarkMode();
        return Scaffold(
          backgroundColor: controller.themeProvider!.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageAppBar(
                onDrwaerTap: () {},
                showDrawer: false,
                showBack: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: controller.themeProvider!.darkTheme
                                ? Colors.white
                                : darkBlueColor,
                            fontFamily: poppinsBold,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: controller.themeProvider!.darkTheme
                                  ? Colors.grey
                                  : const Color(0XFF242760).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: secondPrimaryColor,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Notification',
                                    style: TextStyle(
                                      color: controller.themeProvider!.darkTheme
                                          ? Colors.white
                                          : const Color(0XFF454545),
                                      fontFamily: poppinsBold,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Notification',
                                    style: TextStyle(
                                      color: controller.themeProvider!.darkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: poppinsBold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  Obx(
                                    () => Switch(
                                      value: controller.isNotificationOn.value,
                                      activeColor: secondPrimaryColor,
                                      onChanged: (val) async {
                                        controller.isNotificationOn.value =
                                            !controller.isNotificationOn.value;
                                        SharedPref.saveNotificationStatus(
                                            controller.isNotificationOn.value);
                                        controller.updateNotificationStatus(
                                            controller.isNotificationOn.value);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.settings_applications_sharp,
                              color: secondPrimaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Other',
                              style: TextStyle(
                                color: controller.themeProvider!.darkTheme
                                    ? Colors.white
                                    : darkBlueColor,
                                fontFamily: poppinsBold,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: controller.themeProvider!.darkTheme
                                  ? Colors.grey
                                  : const Color(0XFF242760).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                      color: controller.themeProvider!.darkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: poppinsBold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  Obx(
                                    () => Switch(
                                      value: controller.isDakrModeOn.value,
                                      activeColor: secondPrimaryColor,
                                      onChanged: (val) {
                                        controller.isDakrModeOn.value =
                                            !controller.isDakrModeOn.value;
                                        controller.changeDarkMode();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Lyrics Font Size',
                                    style: TextStyle(
                                      color: controller.themeProvider!.darkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: poppinsBold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Obx(
                                      () => DropdownButton<String>(
                                        value: controller.fontSizeValue.value,
                                        isDense: false,
                                        borderRadius: BorderRadius.circular(10),
                                        underline: const IgnorePointer(),
                                        style: TextStyle(
                                            fontFamily: poppinsExtraBold,
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                        items: <String>['1x', '2x', '3x', '4x']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  fontFamily: poppinsExtraBold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          controller.updateFontSizePref(val!);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
