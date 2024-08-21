import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';

class ImageAppBar extends StatelessWidget {
  const ImageAppBar(
      {super.key,
      required this.onDrwaerTap,
      required this.showDrawer,
      required this.showBack});

  final Function onDrwaerTap;
  final bool showDrawer;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    double imageHeight;
    double imageWidth;
    double appBarHeight;
    if (screenWidth > 600) {
      // Example breakpoint for tablets
      appBarHeight = 99;
      imageHeight = screenWidth * 0.909;
      imageWidth = screenWidth * 0.172;
    } else {
      appBarHeight = 60;
      imageHeight = screenWidth * 0.14;
      imageWidth = screenWidth * 0.35;
    }
    return AppBar(
      backgroundColor:
          themeProvider.darkTheme ? Colors.black : const Color(0XFF24163A),
      leading: showDrawer
          ? GestureDetector(
              onTap: () {
                onDrwaerTap();
              },
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            )
          : showBack
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                )
              : const IgnorePointer(),
      centerTitle: true,
      title: Container(
        margin: const EdgeInsets.only(bottom: 5),
        height: imageHeight,
        width: imageWidth,
        child: Image.asset(appBarLogo),
      ),
      toolbarHeight: appBarHeight,
    );
    // return Container(
    //   width: widthOfScreen,
    //   color: themeProvider.darkTheme?Colors.black: darkBlueColor,
    //   child: Stack(
    //     children: [
    //       if(showDrawer)
    //       SafeArea(
    //         child: GestureDetector(
    //           onTap: (){
    //             onDrwaerTap();
    //           },
    //           child: Container(
    //             margin: const EdgeInsets.only(left: 20, top: 20),
    //             child: const Icon(
    //               Icons.menu,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ),
    //       if(showBack)
    //       SafeArea(
    //         child: GestureDetector(
    //           onTap: (){
    //             Navigator.of(context).pop();
    //           },
    //           child: Container(
    //             margin: const EdgeInsets.only(left: 20, top: 20),
    //             child: const Icon(
    //               Icons.arrow_back_ios_new_rounded,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ),
    //         Center(
    //           child: Container(
    //             margin: const EdgeInsets.only(top: 45, bottom: 5),
    //             height: widthOfScreen * 0.14,
    //             width: widthOfScreen * 0.35,
    //             child: Image.asset(appBarLogo),
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }
}
