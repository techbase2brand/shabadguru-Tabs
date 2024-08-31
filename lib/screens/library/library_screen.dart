// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/library/library_controller.dart';
import 'package:shabadguru/screens/library/widgets/library_item.dart';
import 'package:shabadguru/screens/select_playlist/playlist_item.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:shabadguru/utils/shared_pref.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen(
      {super.key, required this.isSelectedPlaylist, required this.shabadData});

  final bool isSelectedPlaylist;
  final ShabadData? shabadData;

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
    return GetBuilder<LibraryController>(
      init: LibraryController(),
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
              'My playlist',
              style: TextStyle(color: Colors.white),
            ),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(
                bottom: isSelectedPlaylist
                    ? (controller.myPlaylist != null &&
                            controller.myPlaylist!.isNotEmpty)
                        ? 80
                        : 0
                    : 0),
            child: GestureDetector(
              onTap: () {
                controller.showNewPlaylistDialog(
                    context, false, null, 0, isSelectedPlaylist);
              },
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: EdgeInsets.zero,
                child: const SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        Icons.add_circle,
                        color: secondPrimaryColor,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'New playlist',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              if (controller.myPlaylist == null ||
                  controller.myPlaylist!.isEmpty)
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
                          'No playlist found',
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.myPlaylist!.length,
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
                                  if (isSelectedPlaylist) {
                                    if (controller.selectedPlaylistList
                                        .contains(
                                            controller.myPlaylist![index])) {
                                      controller.selectedPlaylistList.remove(
                                          controller.myPlaylist![index]);
                                    } else {
                                      controller.selectedPlaylistList
                                          .add(controller.myPlaylist![index]);
                                    }
                                    controller.myPlaylist![index].isSelected =
                                        !controller
                                            .myPlaylist![index].isSelected;
                                    controller.update();
                                  } else {
                                    controller.shabadListOfLibrary = controller
                                        .myPlaylist![index].shabadList!;
                                    goToLibraryDetailsScreen(
                                        context,
                                        controller
                                                .myPlaylist![index].playlistName
                                                .toString()
                                                .capitalizeFirst ??
                                            '',
                                        index);
                                  }
                                },
                                child: isSelectedPlaylist
                                    ? PlayListItem(
                                        myPlaylistModel:
                                            controller.myPlaylist![index],
                                        isSelectedPlaylist: controller
                                            .myPlaylist![index].isSelected,
                                        onMenuTaped: () {
                                          if (controller.selectedPlaylistList
                                              .contains(controller
                                                  .myPlaylist![index])) {
                                            controller.selectedPlaylistList
                                                .remove(controller
                                                    .myPlaylist![index]);
                                          } else {
                                            controller.selectedPlaylistList.add(
                                                controller.myPlaylist![index]);
                                          }
                                          controller.myPlaylist![index]
                                                  .isSelected =
                                              !controller.myPlaylist![index]
                                                  .isSelected;
                                          controller.update();
                                        },
                                      )
                                    : LibraryItem(
                                        myPlaylistModel:
                                            controller.myPlaylist![index],
                                        onMenuTaped: () {
                                          controller.onMenuTaped(
                                              context,
                                              controller.myPlaylist![index],
                                              index);
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
              if (controller.myPlaylist != null &&
                  controller.myPlaylist!.isNotEmpty &&
                  isSelectedPlaylist)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 100,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(darkBlueColor)),
                        onPressed: () async {
                          if (controller.selectedPlaylistList.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Please select at least one playlist",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: darkBlueColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            for (var i = 0;
                                i < controller.myPlaylist!.length;
                                i++) {
                              if (controller.myPlaylist![i].isSelected) {
                                bool isFind = false;
                                for (var j = 0;
                                    j <
                                        controller
                                            .myPlaylist![i].shabadList!.length;
                                    j++) {
                                  if (controller.myPlaylist![i].shabadList![j]
                                          .audio ==
                                      shabadData!.audio) {
                                    isFind = true;
                                    break;
                                  } else {
                                    isFind = false;
                                  }
                                }
                                if (!isFind) {
                                  controller.myPlaylist![i].shabadList!
                                      .add(shabadData!);
                                }
                              }
                            }
                            await SharedPref.savePlaylist(
                                controller.myPlaylist!);
                            controller.getMyPlaylistFromLocal();
                            Fluttertoast.showToast(
                              msg: "Shabad added to your playlist",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: darkBlueColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Center(
                          child: Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                  ],
                ),
              if (controller.myPlaylist != null &&
                  controller.myPlaylist!.isNotEmpty &&
                  isSelectedPlaylist)
                const SizedBox(
                  height: 35,
                ),
            ],
          ),
        );
      },
    );
  }
}
