import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/baani/widgets/banni_item.dart';
import 'package:shabadguru/screens/library/library_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

class RaagSelectPage extends StatelessWidget {
  const RaagSelectPage({super.key, required this.indexOfList});

  final int indexOfList;

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
            backgroundColor: themeProvider.darkTheme
                ? Colors.black
                : const Color(0XFF24163A),
            title: const Text(
              'Select Raags',
              style: TextStyle(color: Colors.white),
            ),
            leading: GestureDetector(
              onTap: () {
                controller.isRaagSearchEnable.value = false;
                controller.raagSearchValue = '';
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            actions: [
              Obx(
                () => !controller.isRaagSearchEnable.value
                    ? IconButton(
                        onPressed: () {
                          controller.isRaagSearchEnable.value = true;
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
              Obx(() => controller.isRaagSearchEnable.value
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
                                  controller.onSearchRaags(value);
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
                              controller.isRaagSearchEnable.value = false;
                              controller.raagSearchValue = '';
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
              Expanded(
                child: AnimationLimiter(
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.playlistRaagslist.length,
                      padding: EdgeInsets.only(
                          top: !controller.isRaagSearchEnable.value ? 30 : 0,
                          bottom: 60),
                      itemBuilder: (context, index) {
                        if (controller.isRaagSearchEnable.value &&
                            controller.raagSearchValue.isNotEmpty) {
                          if (controller.playlistRaagslist[index].name
                              .toString()
                              .toLowerCase()
                              .contains(
                                  controller.raagSearchValue.toLowerCase())) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 1000),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                duration: const Duration(milliseconds: 1000),
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.readJson(controller
                                          .playlistRaagslist[index].id
                                          .toString());
                                      goToSelectShabadScreen(
                                          context,
                                          indexOfList,
                                          controller
                                              .playlistRaagslist[index].name);
                                    },
                                    child: BanniItem(
                                      banniData:
                                          controller.playlistRaagslist[index],
                                    ),
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
                                child: GestureDetector(
                                  onTap: () {
                                    controller.readJson(controller
                                        .playlistRaagslist[index].id
                                        .toString());
                                    goToSelectShabadScreen(
                                        context,
                                        indexOfList,
                                        controller
                                            .playlistRaagslist[index].name);
                                  },
                                  child: BanniItem(
                                    banniData:
                                        controller.playlistRaagslist[index],
                                  ),
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
