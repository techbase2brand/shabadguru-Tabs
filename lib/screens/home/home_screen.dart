import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/home/home_controller.dart';
import 'package:shabadguru/screens/home/widgets/featured_item.dart';
import 'package:shabadguru/screens/home/widgets/popular_raag_item.dart';
import 'package:shabadguru/screens/home/widgets/recent_play_item.dart';
import 'package:shabadguru/screens/home/widgets/side_drawer.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/image_app_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.tabController, {super.key});

  final PersistentTabController tabController;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<HomeController>(
      init: HomeController(buildContext: context),
      builder: (controller) {
        controller.themeProvider = Provider.of<DarkThemeProvider>(context);
        return UpgradeAlert(
          upgrader: Upgrader(
            dialogStyle: UpgradeDialogStyle.cupertino,
            durationUntilAlertAgain: const Duration(days: 1),
          ),
          child: Scaffold(
            key: controller.keyScaffold,
            drawer: const SideDrawer(),
            backgroundColor: controller.themeProvider.darkTheme
                ? Colors.black
                : const Color.fromARGB(255, 239, 242, 248),
            body: Column(
              children: [
                ImageAppBar(
                  onDrwaerTap: () {
                    controller.keyScaffold.currentState!.openDrawer();
                  },
                  showDrawer: true,
                  showBack: false,
                ),
                if (controller.popularRaagsModel == null)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: controller.themeProvider.darkTheme
                            ? Colors.white
                            : darkBlueColor,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 15, right: 15),
                              child: Text(
                                'Featured',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: poppinsBold,
                                    fontWeight: FontWeight.w600,
                                    color: controller.themeProvider.darkTheme
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: widthOfScreen,
                              height: 200,
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.featuredList.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      child: SlideAnimation(
                                        horizontalOffset: 50.0,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        child: FadeInAnimation(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (index == 0) {
                                                tabController.jumpToTab(1);
                                              } else if (index == 1) {
                                                tabController.jumpToTab(2);
                                              } else if (index == 2) {
                                                goToTheKirtanisPage(context);
                                              }
                                            },
                                            child: FeaturedItem(
                                              index: index,
                                              featuredModel: controller
                                                  .featuredList[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (controller.recentData.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 15, right: 15, bottom: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      'Recently Played',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: poppinsBold,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            controller.themeProvider.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        goToRecentPage(
                                          context,
                                          controller.recentData,
                                        );
                                      },
                                      child: Text(
                                        'See more',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: poppinsBold,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              controller.themeProvider.darkTheme
                                                  ? Colors.white
                                                  : const Color(0XFF876600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (controller.recentData.isNotEmpty)
                              SizedBox(
                                width: screenWidth,
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.recentData.length > 3
                                        ? 3
                                        : controller.recentData.length,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () {
                                                goToMusicPlayerPage(
                                                    context,
                                                    controller
                                                        .recentData[index],
                                                    controller.recentData[index]
                                                            .title ??
                                                        '',
                                                    controller.recentData);
                                              },
                                              child: RecentItem(
                                                index: index,
                                                recentListShabad:
                                                    controller.recentData,
                                                shabadData: controller
                                                    .recentData[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            if (controller.popularRaagsList.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 15, right: 15, bottom: 15),
                                child: Text(
                                  'Raags',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: poppinsBold,
                                      fontWeight: FontWeight.w600,
                                      color: controller.themeProvider.darkTheme
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            if (controller.popularRaagsList.isNotEmpty)
                              SizedBox(
                                width: screenWidth,
                                child: AnimationLimiter(
                                  child: GridView.count(
                                    childAspectRatio: screenWidth > 600 ? 5 : 3,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(8.0),
                                    crossAxisCount: screenWidth > 800 ? 3 : 2,
                                    mainAxisSpacing: 15,
                                    shrinkWrap: true,
                                    crossAxisSpacing: 10,
                                    children: List.generate(
                                      controller.popularRaagsList.length,
                                      (int i) {
                                        return AnimationConfiguration
                                            .staggeredGrid(
                                          columnCount: 2,
                                          position: i,
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            duration: const Duration(
                                                milliseconds: 1500),
                                            child: FadeInAnimation(
                                              child: GestureDetector(
                                                onTap: () {
                                                  goToShabadHomePage(
                                                      context,
                                                      controller
                                                          .popularRaagsList[i]
                                                          .categories![0]
                                                          .id
                                                          .toString(),
                                                      controller
                                                          .popularRaagsList[i]
                                                          .id
                                                          .toString(),
                                                      controller
                                                              .popularRaagsList[
                                                                  i]
                                                              .name ??
                                                          '');
                                                },
                                                child: PopularRaagItem(
                                                  raagData: controller
                                                      .popularRaagsList[i],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
