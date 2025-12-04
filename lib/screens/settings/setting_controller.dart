// Controller for managing app settings and preferences
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/shared_pref.dart';

// Controller for managing app settings including notifications, dark mode, and font size
class SettingController extends GetxController {
  RxString fontSizeValue = '1x'.obs; // Observable font size value
  RxBool isNotificationOn = true.obs; // Observable notification state
  RxBool isDakrModeOn = false.obs; // Observable dark mode state

  DarkThemeProvider? themeProvider; // Theme provider reference

  // Change dark mode theme
  void changeDarkMode() {
    themeProvider!.darkTheme = isDakrModeOn.value; // Set theme based on toggle state
    themeProvider!.systemDarkTheme = true; // Enable system dark theme
  }

  ApiRepository apiRepository = ApiRepository(); // API service for settings

  // Initialize controller and load settings
  @override
  void onInit() {
    super.onInit();
    getDarkMode(); // Load dark mode state
    getFontSize(); // Load font size preference
    getNotificationStatus(); // Load notification status
  }

  // Get current dark mode state from theme provider
  void getDarkMode() {
    if (themeProvider != null) {
      isDakrModeOn.value = themeProvider!.darkTheme; // Set dark mode state
    }
  }

  // Load font size preference from local storage
  Future<void> getFontSize() async {
    fontSizeValue.value = await SharedPref.getFontSizePref(); // Get saved font size
  }

  // Update font size preference and save to local storage
  Future<void> updateFontSizePref(String value) async {
    fontSizeValue.value = value; // Update observable value
    await SharedPref.saveFontPref(value); // Save to local storage
  }

  // Update notification status on server
  Future<void> updateNotificationStatus(status) async {
    String deviceId = '123456789'; // Default device ID
    var deviceInfo = DeviceInfoPlugin(); // Device info plugin
    if (Platform.isIOS) {
      // Get iOS device identifier
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor ?? ''; // iOS vendor identifier
    } else if (Platform.isAndroid) {
      // Get Android device ID
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id; // Android device ID
    }

    // Prepare JSON body for API call
    final body = jsonEncode(
      {'device': deviceId, "active": status ? 1 : 0}, // Device ID and active status
    );
    apiRepository.updateNotificationStatus(body); // Send to server
  }

  // Load notification status from local storage
  Future<void> getNotificationStatus() async {
    isNotificationOn.value = await SharedPref.getNotificationStatus(); // Get saved notification status
  }
}
