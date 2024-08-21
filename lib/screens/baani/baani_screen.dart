import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/baani/widgets/banni_item.dart';
import 'package:shabadguru/screens/home/home_controller.dart';
import 'package:shabadguru/screens/home/widgets/side_drawer.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

class BaaniScreen extends StatelessWidget {
  const BaaniScreen({super.key});

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
    return GetBuilder<HomeController>(
      init: HomeController(buildContext: context),
      builder: (controller) {
        return Scaffold(
          key: controller.keyScaffoldBanis,
          drawer: const SideDrawer(),
          backgroundColor: themeProvider.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          appBar: AppBar(
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                controller.keyScaffoldBanis.currentState!.openDrawer();
              },
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            // toolbarHeight: 68,
            toolbarHeight: appBarHeight,
            backgroundColor: themeProvider.darkTheme
                ? Colors.black
                : const Color(0XFF24163A),
            title: const Text(
              'Popular Banis',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              if (controller.popularBannisModel == null)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.darkTheme
                          ? Colors.white
                          : darkBlueColor,
                    ),
                  ),
                )
              else if (controller.popularBannisModel!.data != null)
                Expanded(
                  child: AnimationLimiter(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isTablet = constraints.maxWidth > 800;
                        return isTablet
                            ? GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 5,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(8.0),
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 1,
                                children: List.generate(
                                  controller.popularBannisModel!.data!.length,
                                  (int i) {
                                    return AnimationConfiguration.staggeredGrid(
                                      columnCount: 2,
                                      position: i,
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        child: FadeInAnimation(
                                          child: GestureDetector(
                                            onTap: () {
                                              goToShabadBanisPage(
                                                context,
                                                controller.popularBannisModel!
                                                    .data![i].categories![0].id
                                                    .toString(),
                                                controller.popularBannisModel!
                                                    .data![i].id
                                                    .toString(),
                                                controller.popularBannisModel!
                                                        .data![i].name ??
                                                    '',
                                              );
                                            },
                                            child: BanniItem(
                                              banniData: controller
                                                  .popularBannisModel!.data![i],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    controller.popularBannisModel!.data!.length,
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 60),
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      child: FadeInAnimation(
                                        child: GestureDetector(
                                          onTap: () {
                                            goToShabadBanisPage(
                                              context,
                                              controller
                                                  .popularBannisModel!
                                                  .data![index]
                                                  .categories![0]
                                                  .id
                                                  .toString(),
                                              controller.popularBannisModel!
                                                  .data![index].id
                                                  .toString(),
                                              controller.popularBannisModel!
                                                      .data![index].name ??
                                                  '',
                                            );
                                          },
                                          child: BanniItem(
                                            banniData: controller
                                                .popularBannisModel!
                                                .data![index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
