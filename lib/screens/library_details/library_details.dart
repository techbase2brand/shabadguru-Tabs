import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/library/library_controller.dart';
import 'package:shabadguru/screens/library_details/library_details_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';

class LibraryDetails extends StatelessWidget {
  const LibraryDetails(
      {super.key, required this.title, required this.libraryIndex});

  final String title;
  final int libraryIndex;

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
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            leading: GestureDetector(
              onTap: () {
                controller.isSearchEnable.value = false;
                controller.searchValue = '';
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            actions: [
              Obx(
                () => !controller.isSearchEnable.value
                    ? IconButton(
                        onPressed: () {
                          controller.isSearchEnable.value = true;
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
              if (controller.shabadListOfLibrary.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/empty_search.png',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'No Shabad Found',
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
              else if (controller.shabadListOfLibrary.isNotEmpty)
                Expanded(
                  child: AnimationLimiter(
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.shabadListOfLibrary.length,
                        padding: EdgeInsets.only(
                            top: !controller.isSearchEnable.value ? 30 : 0,
                            bottom: 60),
                        itemBuilder: (context, index) {
                          if (controller.isSearchEnable.value &&
                              controller.searchValue.isNotEmpty) {
                            if (controller.shabadListOfLibrary[index].song
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
                                          controller.shabadListOfLibrary[index],
                                      onMenuTaped: () {
                                        controller.showPopupForShabadMenu(
                                            context,
                                            controller
                                                .shabadListOfLibrary[index],
                                            libraryIndex,
                                            index);
                                      },
                                      onTaped: () {
                                        goToMusicPlayerPage(
                                          context,
                                          controller.shabadListOfLibrary[index],
                                          controller.shabadListOfLibrary[index]
                                                  .title ??
                                              '',
                                          controller.shabadListOfLibrary,
                                        );
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
                                        controller.shabadListOfLibrary[index],
                                    onMenuTaped: () {
                                      controller.showPopupForShabadMenu(
                                          context,
                                          controller.shabadListOfLibrary[index],
                                          libraryIndex,
                                          index);
                                    },
                                    onTaped: () {
                                      goToMusicPlayerPage(
                                          context,
                                          controller.shabadListOfLibrary[index],
                                          controller.shabadListOfLibrary[index]
                                                  .title ??
                                              '',
                                          controller.shabadListOfLibrary);
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
