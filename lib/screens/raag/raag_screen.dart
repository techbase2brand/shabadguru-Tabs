import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/home/home_controller.dart';
import 'package:shabadguru/screens/home/widgets/side_drawer.dart';
import 'package:shabadguru/screens/raag/widgets/raag_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

class RaagScreen extends StatelessWidget {
  const RaagScreen({super.key});

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
          key: controller.keyScaffoldRags,
          drawer: const SideDrawer(),
          backgroundColor: themeProvider.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          appBar: AppBar(
            centerTitle: true,
            // toolbarHeight: 68,
            toolbarHeight: appBarHeight,
            leading: GestureDetector(
              onTap: () {
                controller.keyScaffoldRags.currentState!.openDrawer();
              },
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor,
            title: const Text(
              'All Raags',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.updatePreRaags();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: controller.preRaagsSelected.value
                              ? const Color(0XFFB57F12)
                              : Colors.white,
                          border: Border.all(
                            color: const Color(0XFFB57F12),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Pre Raags',
                          style: TextStyle(
                              fontFamily: poppinsRegular,
                              color: controller.preRaagsSelected.value
                                  ? Colors.white
                                  : const Color(0XFFB57F12)),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.updateRaags();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                            color: controller.raagsSelected.value
                                ? const Color(0XFFB57F12)
                                : Colors.white,
                            border: Border.all(
                              color: const Color(
                                0XFFB57F12,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'Raags',
                          style: TextStyle(
                            fontFamily: poppinsRegular,
                            color: controller.raagsSelected.value
                                ? Colors.white
                                : const Color(0XFFB57F12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.updatePostRaags();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: controller.postRaagsSelected.value
                                ? const Color(0XFFB57F12)
                                : Colors.white,
                            border: Border.all(
                              color: const Color(
                                0XFFB57F12,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'Post Raags',
                          style: TextStyle(
                              fontFamily: poppinsRegular,
                              color: controller.postRaagsSelected.value
                                  ? Colors.white
                                  : const Color(0XFFB57F12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              if (controller.popularRaagsModel == null)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: darkBlueColor,
                    ),
                  ),
                )
              else if (controller.popularRaagsModel!.data != null)
                // Expanded(
                //   child: AnimationLimiter(
                //     child: ListView.builder(
                //       shrinkWrap: true,
                //       physics: const BouncingScrollPhysics(),
                //       itemCount: controller.raagsSelected.value
                //           ? controller.popularRaagsModel!.data!.length
                //           : controller.preRaagsSelected.value
                //               ? controller.popularRaagsModel!.preRaags!.length
                //               : controller.popularRaagsModel!.postRaags!.length,
                //       padding: const EdgeInsets.only(top: 0, bottom: 60),
                //       itemBuilder: (context, index) {
                //         return AnimationConfiguration.staggeredList(
                //           position: index,
                //           duration: const Duration(milliseconds: 1000),
                //           child: SlideAnimation(
                //             verticalOffset: 50.0,
                //             duration: const Duration(milliseconds: 1000),
                //             child: FadeInAnimation(
                //               child: GestureDetector(
                //                 onTap: () {
                //                   if (controller.raagsSelected.value) {
                //                     goToShabadRaagPage(
                //                         context,
                //                         controller.popularRaagsModel!
                //                             .data![index].categories![0].id
                //                             .toString(),
                //                         controller
                //                             .popularRaagsModel!.data![index].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                                 .data![index].name ??
                //                             '');
                //                   } else if (controller
                //                       .preRaagsSelected.value) {
                //                     goToShabadRaagPage(
                //                         context,
                //                         controller.popularRaagsModel!
                //                             .preRaags![index].categories![0].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                             .preRaags![index].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                                 .preRaags![index].name ??
                //                             '');
                //                   } else {
                //                     goToShabadRaagPage(
                //                         context,
                //                         controller.popularRaagsModel!
                //                             .postRaags![index].categories![0].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                             .postRaags![index].id
                //                             .toString(),
                //                         controller.popularRaagsModel!
                //                                 .postRaags![index].name ??
                //                             '');
                //                   }
                //                 },
                //                 child: RaagItem(
                //                   raagData: controller.raagsSelected.value
                //                       ? controller
                //                           .popularRaagsModel!.data![index]
                //                       : controller.preRaagsSelected.value
                //                           ? controller.popularRaagsModel!
                //                               .preRaags![index]
                //                           : controller.popularRaagsModel!
                //                               .postRaags![index],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
                Expanded(
                  child: MediaQuery.of(context).size.width > 800
                      // Tablet view
                      ? GridView.count(
                          crossAxisCount: 2, // Two items per row
                          childAspectRatio: 5, // Aspect ratio of the grid items
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(8.0),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 1,
                          children: List.generate(
                            controller.raagsSelected.value
                                ? controller.popularRaagsModel!.data!.length
                                : controller.preRaagsSelected.value
                                    ? controller
                                        .popularRaagsModel!.preRaags!.length
                                    : controller
                                        .popularRaagsModel!.postRaags!.length,
                            (int i) {
                              var raagData = controller.raagsSelected.value
                                  ? controller.popularRaagsModel!.data![i]
                                  : controller.preRaagsSelected.value
                                      ? controller
                                          .popularRaagsModel!.preRaags![i]
                                      : controller
                                          .popularRaagsModel!.postRaags![i];

                              return AnimationConfiguration.staggeredGrid(
                                columnCount: 2,
                                position: i,
                                duration: const Duration(milliseconds: 1500),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  duration: const Duration(milliseconds: 1500),
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        goToShabadRaagPage(
                                          context,
                                          raagData.categories![0].id.toString(),
                                          raagData.id.toString(),
                                          raagData.name ?? '',
                                        );
                                      },
                                      child: RaagItem(
                                        raagData: raagData,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      // Mobile view
                      : AnimationLimiter(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.raagsSelected.value
                                ? controller.popularRaagsModel!.data!.length
                                : controller.preRaagsSelected.value
                                    ? controller
                                        .popularRaagsModel!.preRaags!.length
                                    : controller
                                        .popularRaagsModel!.postRaags!.length,
                            padding: const EdgeInsets.only(top: 0, bottom: 60),
                            itemBuilder: (context, index) {
                              var raagData = controller.raagsSelected.value
                                  ? controller.popularRaagsModel!.data![index]
                                  : controller.preRaagsSelected.value
                                      ? controller
                                          .popularRaagsModel!.preRaags![index]
                                      : controller
                                          .popularRaagsModel!.postRaags![index];

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 1000),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  duration: const Duration(milliseconds: 1000),
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () {
                                        goToShabadRaagPage(
                                          context,
                                          raagData.categories![0].id.toString(),
                                          raagData.id.toString(),
                                          raagData.name ?? '',
                                        );
                                      },
                                      child: RaagItem(
                                        raagData: raagData,
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
