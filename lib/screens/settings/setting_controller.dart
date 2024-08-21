import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/shared_pref.dart';

class SettingController extends GetxController {
  RxString fontSizeValue = '1x'.obs;
  RxBool isNotificationOn = true.obs;
  RxBool isDakrModeOn = false.obs;

  DarkThemeProvider? themeProvider;

  void changeDarkMode() {
    themeProvider!.darkTheme = isDakrModeOn.value;
    themeProvider!.systemDarkTheme = true;
  }

  ApiRepository apiRepository = ApiRepository();

  @override
  void onInit() {
    super.onInit();
    getDarkMode();
    getFontSize();
    getNotificationStatus();
  }

  void getDarkMode() {
    if (themeProvider != null) {
      isDakrModeOn.value = themeProvider!.darkTheme;
    }
  }

  Future<void> getFontSize() async {
    fontSizeValue.value = await SharedPref.getFontSizePref();
  }

  updateFontSizePref(String value) async {
    fontSizeValue.value = value;
    await SharedPref.saveFontPref(value);
  }

  Future<void> updateNotificationStatus(status) async {
    String deviceId = '123456789';
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor ?? '';
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    }

    final body = jsonEncode(
      {'device': deviceId, "active": status ? 1 : 0},
    );
    apiRepository.updateNotificationStatus(body);
  }

  Future<void> getNotificationStatus() async {
    isNotificationOn.value = await SharedPref.getNotificationStatus();
  }
}
