import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/recent_played/recent_play_item.dart';
import 'package:shabadguru/screens/up_next/up_next_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({
    super.key,
    required this.listOfShabads,
  });

  final List<ShabadData> listOfShabads;

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
    return GetBuilder<UpNextController>(
      init: UpNextController(
        listOfShabads: listOfShabads,
      ),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: appBarHeight,
            foregroundColor: Colors.white,
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor,
            title: const Text(
              'Recently Played',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: listOfShabads.length,
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
                                    listOfShabads[index],
                                    listOfShabads[index].title ?? '',
                                    listOfShabads);
                              },
                              child: RecentPlayedItem(
                                shabadData: listOfShabads[index],
                                onMenuTaped: () {
                                  controller.showMenuOptions(
                                      context, controller.listOfShabads[index]);
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
