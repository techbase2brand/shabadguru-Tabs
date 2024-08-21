import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/shabad_banis/shabad_controller_banis.dart';
import 'package:shabadguru/screens/shabad_banis/widget/shabad_item_banis.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

class ShabadScreenBanis extends StatelessWidget {
  const ShabadScreenBanis(
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
    return GetBuilder<ShabadControllerBanis>(
      init: ShabadControllerBanis(categoryId: categoryId, id: id, title: title),
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
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: darkBlueColor,
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
                                child: ShabadItemBanis(
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
