import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/shabad_home/shabad_controller.dart';
import 'package:shabadguru/screens/shabad_home/widget/shabad_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

class ShabadScreen extends StatelessWidget {
  const ShabadScreen(
      {super.key,
      required this.categoryId,
      required this.id,
      required this.title});

  final String categoryId;
  final String id;
  final String title;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    double appBarHeight;
    if (screenWidth > 600) {
      // Example breakpoint for tablets
      appBarHeight = 99;
    } else {
      appBarHeight = widthOfScreen * 0.15;
    }
    return GetBuilder<ShabadController>(
      init: ShabadController(categoryId: categoryId, id: id, title: title),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: appBarHeight,
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor,
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            children: [
              if (controller.shabadRaagModel == null)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.darkTheme
                          ? Colors.white
                          : darkBlueColor,
                    ),
                  ),
                )
              else if (controller.shabadRaagModel!.data != null)
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.shabadRaagModel!.data!.length,
                      padding: const EdgeInsets.only(top: 30, bottom: 60),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 1000),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            duration: const Duration(milliseconds: 1000),
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  goToMusicPlayerPage(
                                      context,
                                      controller.shabadRaagModel!.data![index],
                                      title,
                                      controller.shabadRaagModel!.data!);
                                },
                                child: ShabadItem(
                                  shabadData:
                                      controller.shabadRaagModel!.data![index],
                                  title: title,
                                  onMenuTaped: () {
                                    controller.showMenuOptions(
                                        context,
                                        controller
                                            .shabadRaagModel!.data![index]);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
