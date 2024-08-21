import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shabadguru/screens/splash/splash_controller.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/global.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: widthOfScreen,
                height: heightOfScreen,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(splashBack),
                  ),
                ),
              ),
              Container(
                width: widthOfScreen,
                height: heightOfScreen,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(splashSun),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: widthOfScreen * 0.45,
                  height: widthOfScreen * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(splashLogo),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
