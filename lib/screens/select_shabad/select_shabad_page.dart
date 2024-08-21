import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/library/library_controller.dart';
import 'package:shabadguru/screens/select_shabad/select_shabad_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

class SelectShabadPage extends StatelessWidget {
  const SelectShabadPage(
      {super.key, required this.indexOfList, required this.title});

  final int indexOfList;
  final String title;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LibraryController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: widthOfScreen * 0.15,
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor,
            title: const Text(
              'Select Shabad',
              style: TextStyle(color: Colors.white),
            ),
            leading: GestureDetector(
              onTap: () {
                controller.isShabadSearchEnable.value = false;
                controller.shabadSearchValue = '';
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            actions: [
              Obx(
                () => !controller.isShabadSearchEnable.value
                    ? IconButton(
                        onPressed: () {
                          controller.isShabadSearchEnable.value = true;
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      )
                    : const IgnorePointer(),
              ),
            ],
          ),
          body: Column(
            children: [
              Obx(() => controller.isShabadSearchEnable.value
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
                                  controller.onSearchShabad(value);
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
                              controller.isShabadSearchEnable.value = false;
                              controller.shabadSearchValue = '';
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
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.shabadRaagModel!.data!.length,
                        padding: EdgeInsets.only(
                            top:
                                !controller.isShabadSearchEnable.value ? 30 : 0,
                            bottom: 60),
                        itemBuilder: (context, index) {
                          if (controller.isShabadSearchEnable.value &&
                              controller.shabadSearchValue.isNotEmpty) {
                            if (controller.shabadRaagModel!.data![index].song
                                .toString()
                                .toLowerCase()
                                .contains(controller.shabadSearchValue
                                    .toLowerCase())) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 1000),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  duration: const Duration(milliseconds: 1000),
                                  child: FadeInAnimation(
                                    child: SelectShabadItem(
                                      shabadData: controller
                                          .shabadRaagModel!.data![index],
                                      isSelectedForPlaylist: () {
                                        controller.shabadRaagModel!.data![index]
                                                .isSelectedForPlaylist =
                                            !controller
                                                .shabadRaagModel!
                                                .data![index]
                                                .isSelectedForPlaylist;
                                        controller.update();
                                        if (controller
                                            .shabadRaagModel!
                                            .data![index]
                                            .isSelectedForPlaylist) {
                                          if (!controller.selectedShabadList
                                              .contains(controller
                                                  .shabadRaagModel!
                                                  .data![index])) {
                                            controller.selectedShabadList.add(
                                                controller.shabadRaagModel!
                                                    .data![index]);
                                          }
                                        } else {
                                          controller.selectedShabadList
                                              .removeWhere((element) =>
                                                  element.audio ==
                                                  controller.shabadRaagModel!
                                                      .data![index].audio);
                                        }
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
                                  child: SelectShabadItem(
                                    shabadData: controller
                                        .shabadRaagModel!.data![index],
                                    isSelectedForPlaylist: () {
                                      controller.shabadRaagModel!.data![index]
                                              .isSelectedForPlaylist =
                                          !controller
                                              .shabadRaagModel!
                                              .data![index]
                                              .isSelectedForPlaylist;
                                      controller.update();
                                      if (controller.shabadRaagModel!
                                          .data![index].isSelectedForPlaylist) {
                                        if (!controller.selectedShabadList
                                            .contains(controller
                                                .shabadRaagModel!
                                                .data![index])) {
                                          controller.shabadRaagModel!
                                              .data![index].title = title;
                                          controller.selectedShabadList.add(
                                              controller.shabadRaagModel!
                                                  .data![index]);
                                        }
                                      } else {
                                        controller.selectedShabadList
                                            .removeWhere((element) =>
                                                element.audio ==
                                                controller.shabadRaagModel!
                                                    .data![index].audio);
                                      }
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
              Container(
                width: Get.width,
                color: themeProvider.darkTheme
                    ? Colors.blueGrey.shade900
                    : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            themeProvider.darkTheme
                                ? Colors.white
                                : darkBlueColor)),
                    onPressed: () {
                      controller.savePlaylist(indexOfList);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Save Playlist',
                        style: TextStyle(
                            color: themeProvider.darkTheme
                                ? Colors.black
                                : Colors.white,
                            fontFamily: poppinsBold,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
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
