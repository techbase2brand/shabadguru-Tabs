// Controller for managing splash screen timing and navigation
import 'package:get/get.dart';
import 'package:shabadguru/screens/dashboard/dasboard_screen.dart';

// Controller for managing splash screen duration and navigation to dashboard
class SplashController extends GetxController {
  // Initialize controller and start navigation timer
  @override
  void onInit() {
    super.onInit();
    getToNextScreen(); // Start navigation timer
  }

  // Navigate to dashboard after splash screen delay
  void getToNextScreen() {
    Future.delayed(
      const Duration(seconds: 2), // 2 second delay for splash screen
      () {
        Get.offAll(const DashboardScreen()); // Navigate to dashboard and clear navigation stack
      },
    );
  }
}
