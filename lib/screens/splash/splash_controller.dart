import 'package:get/get.dart';
import 'package:shabadguru/screens/dashboard/dasboard_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getToNextScreen();
  }

  void getToNextScreen() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Get.offAll(const DashboardScreen());
      },
    );
  }
}
