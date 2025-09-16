// Settings screen for app configuration and preferences
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/settings/setting_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/image_app_bar.dart';
import 'package:shabadguru/utils/shared_pref.dart';

// Screen for managing app settings including notifications, dark mode, and font size
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Build the settings screen UI
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      init: SettingController(), // Initialize settings controller
      builder: (controller) {
        controller.themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
        controller.getDarkMode(); // Get current dark mode state
        return Scaffold(
          backgroundColor: controller.themeProvider!.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar with back button
              ImageAppBar(
                onDrwaerTap: () {}, // No drawer functionality
                showDrawer: false, // Hide drawer button
                showBack: true, // Show back button
              ),
              Expanded(
                child: SingleChildScrollView( // Scrollable content
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // Screen padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Settings title
                        Text(
                          'Settings', // Main title
                          style: TextStyle(
                            color: controller.themeProvider!.darkTheme
                                ? Colors.white // White text for dark theme
                                : darkBlueColor, // Blue text for light theme
                            fontFamily: poppinsBold,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 15, // Spacing after title
                        ),
                        // Notification settings container
                        Container(
                          width: Get.width, // Full width
                          padding: const EdgeInsets.all(20), // Container padding
                          decoration: BoxDecoration(
                              color: controller.themeProvider!.darkTheme
                                  ? Colors.grey // Grey background for dark theme
                                  : const Color(0XFF242760).withOpacity(0.05), // Light blue background for light theme
                              borderRadius: BorderRadius.circular(10)), // Rounded corners
                          child: Column(
                            children: [
                              // Notification section header
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8), // Icon padding
                                    decoration: const BoxDecoration(
                                        color: secondPrimaryColor, // Gold background
                                        shape: BoxShape.circle), // Circular shape
                                    child: const Icon(
                                      Icons.notifications, // Notification icon
                                      color: Colors.white, // White icon
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15, // Spacing between icon and text
                                  ),
                                  Text(
                                    'Notification', // Section title
                                    style: TextStyle(
                                      color: controller.themeProvider!.darkTheme
                                          ? Colors.white // White text for dark theme
                                          : const Color(0XFF454545), // Dark grey text for light theme
                                      fontFamily: poppinsBold,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20, // Spacing after header
                              ),
                              // Notification toggle row
                              Row(
                                children: [
                                  Text(
                                    'Notification', // Toggle label
                                    style: TextStyle(
                                      color: controller.themeProvider!.darkTheme
                                          ? Colors.white // White text for dark theme
                                          : Colors.black, // Black text for light theme
                                      fontFamily: poppinsBold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(), // Push switch to the right
                                  // Notification toggle switch
                                  Obx(
                                    () => Switch(
                                      value: controller.isNotificationOn.value, // Current notification state
                                      activeColor: secondPrimaryColor, // Gold color when active
                                      onChanged: (val) async {
                                        controller.isNotificationOn.value =
                                            !controller.isNotificationOn.value; // Toggle state
                                        SharedPref.saveNotificationStatus(
                                            controller.isNotificationOn.value); // Save to local storage
                                        controller.updateNotificationStatus(
                                            controller.isNotificationOn.value); // Update server
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25, // Spacing between sections
                        ),
                        // Other settings section header
                        Row(
                          children: [
                            const Icon(
                              Icons.settings_applications_sharp, // Settings icon
                              color: secondPrimaryColor, // Gold color
                            ),
                            const SizedBox(
                              width: 10, // Spacing between icon and text
                            ),
                            Text(
                              'Other', // Section title
                              style: TextStyle(
                                color: controller.themeProvider!.darkTheme
                                    ? Colors.white // White text for dark theme
                                    : darkBlueColor, // Blue text for light theme
                                fontFamily: poppinsBold,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15, // Spacing after header
                        ),
                        // Other settings container
                        Container(
                          width: Get.width, // Full width
                          padding: const EdgeInsets.all(20), // Container padding
                          decoration: BoxDecoration(
                              color: controller.themeProvider!.darkTheme
                                  ? Colors.grey // Grey background for dark theme
                                  : const Color(0XFF242760).withOpacity(0.05), // Light blue background for light theme
                              borderRadius: BorderRadius.circular(10)), // Rounded corners
                          child: Column(
                            children: [
                              // Dark mode toggle row
                              Row(
                                children: [
                                  Text(
                                    'Dark Mode', // Dark mode label
                                    style: TextStyle(
                                      color: controller.themeProvider!.darkTheme
                                          ? Colors.white // White text for dark theme
                                          : Colors.black, // Black text for light theme
                                      fontFamily: poppinsBold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(), // Push switch to the right
                                  // Dark mode toggle switch
                                  Obx(
                                    () => Switch(
                                      value: controller.isDakrModeOn.value, // Current dark mode state
                                      activeColor: secondPrimaryColor, // Gold color when active
                                      onChanged: (val) {
                                        controller.isDakrModeOn.value =
                                            !controller.isDakrModeOn.value; // Toggle state
                                        controller.changeDarkMode(); // Apply theme change
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15, // Spacing between settings
                              ),
                              // Font size selection row
                              Row(
                                children: [
                                  Text(
                                    'Lyrics Font Size', // Font size label
                                    style: TextStyle(
                                      color: controller.themeProvider!.darkTheme
                                          ? Colors.white // White text for dark theme
                                          : Colors.black, // Black text for light theme
                                      fontFamily: poppinsBold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(), // Push dropdown to the right
                                  // Font size dropdown container
                                  Container(
                                    height: 40, // Fixed height
                                    decoration: BoxDecoration(
                                      color: Colors.white, // White background
                                      borderRadius: BorderRadius.circular(10), // Rounded corners
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5), // Dropdown padding
                                    child: Obx(
                                      () => DropdownButton<String>(
                                        value: controller.fontSizeValue.value, // Current font size
                                        isDense: false, // Not dense
                                        borderRadius: BorderRadius.circular(10), // Rounded corners
                                        underline: const IgnorePointer(), // Hide underline
                                        style: TextStyle(
                                            fontFamily: poppinsExtraBold,
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                        // Font size options
                                        items: <String>['1x', '2x', '3x', '4x']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value, // Display font size option
                                              style: TextStyle(
                                                  fontFamily: poppinsExtraBold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          controller.updateFontSizePref(val!); // Update font size preference
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
