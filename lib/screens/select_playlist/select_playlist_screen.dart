// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/select_playlist/playlist_item.dart';
import 'package:shabadguru/screens/select_playlist/select_playlist_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/shared_pref.dart';

class SelectPlaylistScreen extends StatelessWidget {
  const SelectPlaylistScreen({super.key, required this.shabadData});

  final ShabadData shabadData;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<SelectPlaylistController>(
      init: SelectPlaylistController(),
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
              'Select Playlist',
              style: TextStyle(color: Colors.white),
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
                          'No Playlist found',
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
                                  if (controller.selectedPlaylistList.contains(
                                      controller.myPlaylist![index])) {
                                    controller.selectedPlaylistList
                                        .remove(controller.myPlaylist![index]);
                                  } else {
                                    controller.selectedPlaylistList
                                        .add(controller.myPlaylist![index]);
                                  }
                                  controller.myPlaylist![index].isSelected =
                                      !controller.myPlaylist![index].isSelected;
                                  controller.update();
                                },
                                child: PlayListItem(
                                  myPlaylistModel:
                                      controller.myPlaylist![index],
                                  isSelectedPlaylist:
                                      controller.myPlaylist![index].isSelected,
                                  onMenuTaped: () {
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
              const SizedBox(
                height: 15,
              ),
              if (controller.myPlaylist != null &&
                  controller.myPlaylist!.isNotEmpty)
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
                                controller.myPlaylist![i].shabadList!
                                    .add(shabadData);
                              }
                            }
                            await SharedPref.savePlaylist(
                                controller.myPlaylist!);
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
