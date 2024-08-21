// ignore_for_file: must_be_immutable

import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/music_player/music_player_controller.dart';
import 'package:shabadguru/screens/music_player/widgets/lyrics.dart';
import 'package:shabadguru/screens/music_player/widgets/player_controls.dart';
import 'package:shabadguru/screens/up_next/widget/up_next_item.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

class MusicPlayerScreen extends StatelessWidget {
  MusicPlayerScreen({
    super.key,
    required this.shabadData,
    required this.title,
    required this.listOfShabads,
  });

  ShabadData shabadData;
  final String title;
  final List<ShabadData> listOfShabads;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<MusicPlayerController>(
      init: MusicPlayerController(
          shabadData: shabadData,
          title: title,
          context: context,
          listOfShabads: listOfShabads),
      builder: (controller) {
        musicPlayerController = controller;
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor,
            toolbarHeight: 0,
          ),
          backgroundColor:
              themeProvider.darkTheme ? Colors.black : Colors.white,
          body: controller.playerLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color:
                        themeProvider.darkTheme ? Colors.white : darkBlueColor,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 72,
                                width: widthOfScreen,
                                color: themeProvider.darkTheme
                                    ? Colors.black
                                    : const Color(0XFFFFF8EA),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: screenWidth > 600 ? 1 : 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                    flex: screenWidth > 600 ? 8 : 6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller.title,
                                            style: TextStyle(
                                              fontFamily: poppinsBold,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 24,
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : const Color(0XFF130726),
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   height: 4,
                                          // ),
                                          // Text(
                                          //   // controller.shabadData.song ?? '',
                                          //   "",
                                          //   maxLines: 1,
                                          //   overflow: TextOverflow.ellipsis,
                                          //   style: TextStyle(
                                          //       fontFamily: poppinsBold,
                                          //       fontWeight: FontWeight.w500,
                                          //       fontSize: 15,
                                          //       color: secondPrimaryColor),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                    flex: screenWidth > 600 ? 1 : 2,
                                      child: CustomPopupMenu(
                                        menuBuilder: () {
                                          return Container(
                                            height: 120,
                                            width: 210,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: secondPrimaryColor,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Obx(
                                                  () {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        controller.changeLyrics(
                                                            !controller
                                                                .isEnglishLyricsSelected
                                                                .value,
                                                            controller
                                                                .isSpanishLyricsSelected
                                                                .value,
                                                            controller
                                                                .isHindiLyricsSelected
                                                                .value);
                                                        controller.update();
                                                        controller.controller!
                                                            .hideMenu();
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: controller
                                                                  .isEnglishLyricsSelected
                                                                  .value
                                                              ? Colors.white
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10,
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'English',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    poppinsRegular,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            if (controller
                                                                .isEnglishLyricsSelected
                                                                .value)
                                                              const Icon(
                                                                Icons
                                                                    .check_rounded,
                                                                color:
                                                                    secondPrimaryColor,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                Obx(() {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      controller.changeLyrics(
                                                          controller
                                                              .isEnglishLyricsSelected
                                                              .value,
                                                          !controller
                                                              .isSpanishLyricsSelected
                                                              .value,
                                                          controller
                                                              .isHindiLyricsSelected
                                                              .value);
                                                      controller.update();
                                                      controller.controller!
                                                          .hideMenu();
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                                .isSpanishLyricsSelected
                                                                .value
                                                            ? Colors.white
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Spanish',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  poppinsRegular,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          if (controller
                                                              .isSpanishLyricsSelected
                                                              .value)
                                                            const Icon(
                                                              Icons
                                                                  .check_rounded,
                                                              color:
                                                                  secondPrimaryColor,
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),

                                                // Obx(() {
                                                //   return GestureDetector(
                                                //     onTap: () {
                                                //       controller.changeLyrics(
                                                //           controller
                                                //               .isEnglishLyricsSelected
                                                //               .value,
                                                //           controller
                                                //               .isTranslationLyricsSelected
                                                //               .value,
                                                //                 controller.isSpanishLyricsSelected.value,
                                                //                 !controller.isHindiLyricsSelected.value);
                                                //       controller.update();
                                                //       controller.controller!
                                                //           .hideMenu();
                                                //     },
                                                //     child: Container(
                                                //       margin:
                                                //           const EdgeInsets.all(
                                                //               5),
                                                //       decoration: BoxDecoration(
                                                //         color: controller
                                                //                 .isHindiLyricsSelected
                                                //                 .value
                                                //             ? Colors.white
                                                //             : Colors
                                                //                 .transparent,
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(5),
                                                //       ),
                                                //       padding: const EdgeInsets
                                                //           .symmetric(
                                                //           vertical: 10,
                                                //           horizontal: 10),
                                                //       child: Row(
                                                //         children: [
                                                //           Text(
                                                //             'Hindi',
                                                //             style: TextStyle(
                                                //               color:
                                                //                   Colors.black,
                                                //               fontFamily:
                                                //                   poppinsRegular,
                                                //               fontSize: 16,
                                                //             ),
                                                //           ),
                                                //           const Spacer(),
                                                //           if (controller
                                                //               .isHindiLyricsSelected
                                                //               .value)
                                                //             const Icon(
                                                //               Icons
                                                //                   .check_rounded,
                                                //               color:
                                                //                   secondPrimaryColor,
                                                //             ),
                                                //         ],
                                                //       ),
                                                //     ),
                                                //   );
                                                // }),
                                              ],
                                            ),
                                          );
                                        },
                                        controller: controller.controller,
                                        barrierColor:
                                            Colors.grey.withOpacity(0.3),
                                        showArrow: true,
                                        arrowColor: secondPrimaryColor,
                                        arrowSize: 30,
                                        pressType: PressType.singleClick,
                                        verticalMargin: 0,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            translatorSvg,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (controller.lyricsLoading)
                                const Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: darkBlueColor,
                                    ),
                                  ),
                                )
                              else
                                const Expanded(
                                  child: LyricsWidget(),
                                ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                          // DraggableScrollableActuator(
                          //   child: DraggableScrollableSheet(
                          // initialChildSize: controller.sheetHeight,
                          // minChildSize: controller.sheetHeight,
                          // snap: true,
                          // maxChildSize: 1.0,
                          // expand: true,
                          // controller: controller.dragController, // Set the maximum height of the sheet
                          //     builder: (BuildContext context,
                          //         ScrollController scrollController) {
                          //       controller.draggableSheetContext = context;
                          // return Container(
                          //   color: Colors.white,
                          //   child: Column(
                          //     children: [
                          //       const SizedBox(
                          //         height: 17,
                          //       ),
                          //       Column(
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.only(
                          //                 left: 30, right: 30),
                          //             child: Row(
                          //               children: [
                          //                 Expanded(
                          //                   child: Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment
                          //                             .start,
                          //                     children: [
                          //                       Text(
                          //                         title,
                          //                         style: TextStyle(
                          //                           fontFamily:
                          //                               poppinsBold,
                          //                           fontWeight:
                          //                               FontWeight.w500,
                          //                           fontSize: 16,
                          //                           color: const Color(
                          //                               0XFF130726),
                          //                         ),
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 4,
                          //                       ),
                          //                       Text(
                          //                         controller.shabadData
                          //                                 .song ??
                          //                             '',
                          //                         maxLines: 1,
                          //                         overflow: TextOverflow
                          //                             .ellipsis,
                          //                         style: TextStyle(
                          //                             fontFamily:
                          //                                 poppinsBold,
                          //                             fontWeight:
                          //                                 FontWeight.w500,
                          //                             fontSize: 14,
                          //                             color:
                          //                                 secondPrimaryColor),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 GestureDetector(
                          //                   onTap: () {
                          //                     controller
                          //                         .changeSheetHeight();
                          //                   },
                          //                   child: Row(
                          //                     children: [
                          //                       Text(
                          //                         'Up Next ',
                          //                         style: TextStyle(
                          //                           fontFamily:
                          //                               poppinsBold,
                          //                           fontWeight:
                          //                               FontWeight.w500,
                          //                           fontSize: 15,
                          //                           color:
                          //                               secondPrimaryColor,
                          //                         ),
                          //                       ),
                          //                       Icon(
                          //                         controller.sheetHeight ==
                          //                                 1.0
                          //                             ? Icons
                          //                                 .keyboard_arrow_down_outlined
                          //                             : Icons
                          //                                 .keyboard_arrow_up_outlined,
                          //                         color:
                          //                             secondPrimaryColor,
                          //                         size: 24,
                          //                       )
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       Expanded(
                          //         child: ListView.builder(
                          //           shrinkWrap: true,
                          //           physics:
                          //               const BouncingScrollPhysics(),
                          //           itemCount: listOfShabads.length,
                          //           padding:
                          //               const EdgeInsets.only(top: 30),
                          //           itemBuilder: (context, index) {
                          //             bool isPlaying =
                          //                 listOfShabads[index] ==
                          //                     controller.shabadData;
                          //             return GestureDetector(
                          //               onTap: () {
                          //                 audioHandler!.pause();
                          //                 audioHandler!.stop();
                          //                 audioHandler = null;
                          //                 playingLyricModel = null;
                          //                 controller.shabadData =
                          //                     listOfShabads[index];
                          //                 controller.playerLoading = true;
                          //                 controller.sheetHeight = 0.1;
                          //                 controller.update();
                          //                 controller.onInit();
                          //               },
                          //               child: UpNextItem(
                          //                 shabadData:
                          //                     listOfShabads[index],
                          //                 isPlaying: isPlaying,
                          //               ),
                          //             );
                          //           },
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // );
                          //     },
                          //   ),
                          // )
                          DraggableScrollableSheet(
                            initialChildSize: controller.sheetHeight,
                            minChildSize: controller.sheetHeight,
                            snap: true,
                            maxChildSize: controller.sheetHeight,
                            expand: true,
                            controller: controller.dragController,
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return Container(
                                color: themeProvider.darkTheme
                                    ? Colors.black
                                    : Colors.white,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, right: 30),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller.title,
                                                      style: TextStyle(
                                                        fontFamily: poppinsBold,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        color: themeProvider
                                                                .darkTheme
                                                            ? Colors.white
                                                            : const Color(
                                                                0XFF130726),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      controller.shabadData
                                                              .song ??
                                                          '',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              poppinsBold,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          color:
                                                              secondPrimaryColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .changeSheetHeight();
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Up Next ',
                                                      style: TextStyle(
                                                        fontFamily: poppinsBold,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                        color:
                                                            secondPrimaryColor,
                                                      ),
                                                    ),
                                                    Icon(
                                                      controller
                                                                  .sheetHeight ==
                                                              1.0
                                                          ? Icons
                                                              .keyboard_arrow_down_outlined
                                                          : Icons
                                                              .keyboard_arrow_up_outlined,
                                                      color: secondPrimaryColor,
                                                      size: 24,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount:
                                            controller.listOfShabads.length,
                                        padding: const EdgeInsets.only(top: 30),
                                        itemBuilder: (context, index) {
                                          bool isPlaying =
                                              controller.listOfShabads[index] ==
                                                  controller.shabadData;
                                          return GestureDetector(
                                            onTap: () {
                                              audioHandler!.pause();
                                              audioHandler!.stop();
                                              audioHandler = null;
                                              playingLyricModel = null;
                                              controller.shabadData = controller
                                                  .listOfShabads[index];
                                              controller.playerLoading = true;
                                              controller.sheetHeight = 0.1;
                                              controller.update();
                                              controller.onInit();
                                            },
                                            child: UpNextItem(
                                              shabadData: controller
                                                  .listOfShabads[index],
                                              isPlaying: isPlaying,
                                              onMenuTaped: () {
                                                controller.showMenuOptions(
                                                    context,
                                                    controller
                                                        .listOfShabads[index]);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    PlayerControls(
                      subTitle: controller.shabadData.song ?? '',
                      title: controller.title,
                      listOfShabads: controller.listOfShabads,
                      shabadData: controller.shabadData,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

/// A draggable widget that accepts vertical drag gestures
/// and this is only visible on desktop and web platforms.
class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: colorScheme.onSurface,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
