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
import 'dart:io' show Platform;

// Main music player screen with lyrics display and controls
class MusicPlayerScreen extends StatelessWidget {
  MusicPlayerScreen({
    super.key,
    required this.shabadData,
    required this.title,
    required this.listOfShabads,
  });

  ShabadData shabadData; // Current playing shabad data
  final String title; // Shabad title
  final List<ShabadData> listOfShabads; // List of all shabads in playlist

  // Build the music player screen UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive design
    return GetBuilder<MusicPlayerController>(
      init: MusicPlayerController(
          shabadData: shabadData,
          title: title,
          context: context,
          listOfShabads: listOfShabads), // Initialize music player controller
      builder: (controller) {
        musicPlayerController = controller; // Set global controller reference
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                themeProvider.darkTheme ? Colors.black : darkBlueColor, // App bar background
            toolbarHeight: 0, // Hide app bar
          ),
          backgroundColor:
              themeProvider.darkTheme ? Colors.black : Colors.white, // Screen background
          body: controller.playerLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color:
                        themeProvider.darkTheme ? Colors.white : darkBlueColor, // Loading indicator color
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              // Top header container with back button and title
                              Container(
                                height: 72, // Fixed header height
                                width: screenWidth, // Full screen width
                                color: themeProvider.darkTheme
                                    ? Colors.black // Dark theme background
                                    : const Color(0XFFFFF8EA), // Light theme background
                                child: Row(
                                  children: [
                                    // Back button section
                                    Expanded(
                                      flex: screenWidth > 600 ? 1 : 2, // Responsive flex for tablets/phones
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop(); // Navigate back
                                        },
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_back_ios, // Back arrow icon
                                            color: themeProvider.darkTheme
                                                ? Colors.white // White for dark theme
                                                : Colors.black, // Black for light theme
                                            size: 24, // Icon size
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Title section
                                    Expanded(
                                      flex: screenWidth > 600 ? 8 : 6, // Responsive flex for tablets/phones
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center, // Center vertically
                                        children: [
                                          Text(
                                            controller.title, // Display shabad title
                                            style: TextStyle(
                                              fontFamily: poppinsBold,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 24,
                                              color: themeProvider.darkTheme
                                                  ? Colors.white // White for dark theme
                                                  : const Color(0XFF130726), // Dark blue for light theme
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
                                            height: 180,
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
                                                Obx(() {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      // print('Hindi Lyrics clicked');
                                                      controller.changeLyrics(
                                                          controller
                                                              .isEnglishLyricsSelected
                                                              .value,
                                                          controller
                                                              .isSpanishLyricsSelected
                                                              .value,
                                                          !controller
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
                                                                .isHindiLyricsSelected
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
                                                            'Hindi',
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
                                                              .isHindiLyricsSelected
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
                              // Lyrics display section
                              if (controller.lyricsLoading)
                                const Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: darkBlueColor, // Loading indicator color
                                    ),
                                  ),
                                )
                              else
                                const Expanded(
                                  child: LyricsWidget(), // Display lyrics widget
                                ),
                              const SizedBox(
                                height: 15, // Spacing after lyrics
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
                          // Draggable sheet for "Up Next" playlist
                          DraggableScrollableSheet(
                            initialChildSize: controller.sheetHeight, // Initial sheet height
                            minChildSize: controller.sheetHeight, // Minimum sheet height
                            snap: true, // Snap to positions
                            maxChildSize: controller.sheetHeight, // Maximum sheet height
                            expand: true, // Expand to fill available space
                            controller: controller.dragController, // Drag controller
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return Container(
                                color: themeProvider.darkTheme
                                    ? Colors.black // Dark theme background
                                    : Colors.white, // Light theme background
                                child: Column(
                                  children: [
                                    // Top spacing based on device type
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? Platform.isIOS
                                                  ? 40 // iPad spacing
                                                  : 28 // Android tablet spacing
                                              : 17, // Phone spacing
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
                     const SizedBox(
                      height: 15, // Spacing before player controls
                    ),
                    // Player controls section with play/pause, skip, and seek bar
                    PlayerControls(
                      subTitle: controller.shabadData.song ?? '', // Song subtitle
                      title: controller.title, // Shabad title
                      listOfShabads: controller.listOfShabads, // Playlist
                      shabadData: controller.shabadData, // Current shabad data
                    ),
                    const SizedBox(
                      height: 15, // Bottom spacing
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
