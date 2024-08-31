import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/library_details/library_details_item.dart';
import 'package:shabadguru/screens/my_favorite_shabad/my_favorite_shabad_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

class MyFavoriteShabadScreen extends StatelessWidget {
  const MyFavoriteShabadScreen({super.key});

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
    return GetBuilder<MyFavoriteShabadController>(
      init: MyFavoriteShabadController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: appBarHeight,
            backgroundColor: themeProvider.darkTheme
                ? Colors.black
                : const Color(0XFF24163A),
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'My favorite',
              style: TextStyle(color: Colors.white),
            ),
            // actions: [
            //   Obx(
            //     () => !controller.isSearchEnable.value &&
            //             controller.myFavoriteShabad.isNotEmpty
            //         ? IconButton(
            //             onPressed: () {
            //               controller.isSearchEnable.value = true;
            //             },
            //             icon: const Icon(
            //               Icons.search,
            //               color: Colors.white,
            //             ),
            //           )
            //         : const IgnorePointer(),
            //   ),
            // ],
          ),
          body: Column(
            children: [
              Obx(() => controller.isSearchEnable.value
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 30, bottom: 30),
                      width: Get.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  controller.onSearch(value);
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Search...',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.isSearchEnable.value = false;
                              controller.searchValue = '';
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: themeProvider.darkTheme
                                  ? Colors.white
                                  : darkBlueColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const IgnorePointer()),
              if (controller.myFavoriteShabad.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image.asset(
                        //   'assets/images/empty_search.png',
                        //   width: 150,
                        //   height: 150,
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'No favorite shabad found',
                          style: TextStyle(
                              color: themeProvider.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18,
                              fontFamily: poppinsRegular,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: AnimationLimiter(
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.myFavoriteShabad.length,
                        padding: EdgeInsets.only(
                            top: !controller.isSearchEnable.value ? 30 : 0,
                            bottom: 60),
                        itemBuilder: (context, index) {
                          if (controller.isSearchEnable.value &&
                              controller.searchValue.isNotEmpty) {
                            if (controller.myFavoriteShabad[index].song
                                .toString()
                                .toLowerCase()
                                .contains(
                                    controller.searchValue.toLowerCase())) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 1000),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  duration: const Duration(milliseconds: 1000),
                                  child: FadeInAnimation(
                                    child: LibraryDetailsItem(
                                      shabadData:
                                          controller.myFavoriteShabad[index],
                                      onMenuTaped: () {
                                        controller.onMenuTapped(
                                            controller.myFavoriteShabad[index],
                                            context);
                                      },
                                      onTaped: () {
                                        goToMusicPlayerPage(
                                            context,
                                            controller.myFavoriteShabad[index],
                                            controller.myFavoriteShabad[index]
                                                    .title ??
                                                '',
                                            controller.myFavoriteShabad);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const IgnorePointer();
                            }
                          } else {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 1000),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                duration: const Duration(milliseconds: 1000),
                                child: FadeInAnimation(
                                  child: LibraryDetailsItem(
                                    shabadData:
                                        controller.myFavoriteShabad[index],
                                    onMenuTaped: () {
                                      controller.onMenuTapped(
                                          controller.myFavoriteShabad[index],
                                          context);
                                    },
                                    onTaped: () {
                                      goToMusicPlayerPage(
                                          context,
                                          controller.myFavoriteShabad[index],
                                          controller.myFavoriteShabad[index]
                                                  .title ??
                                              '',
                                          controller.myFavoriteShabad);
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                        },
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
