// ignore_for_file: avoid_print

import 'package:action_broadcast/action_broadcast.dart';
import 'package:audio_service/audio_service.dart';
import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_lyric/lyrics_reader.dart';
// import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shabadguru/audio_service/audio_player_handler.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader.dart';
import 'package:shabadguru/flutter_lyrics/lyrics_reader_model.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/home/home_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:shabadguru/utils/shared_pref.dart';
import 'dart:convert';

class MusicPlayerController extends GetxController {
  MusicPlayerController(
      {required this.shabadData,
      required this.title,
      required this.context,
      required this.listOfShabads});
  int playProgress = 0;

  List<ShabadData> listOfShabads;

  var lyricUI = UINetease(
    inlineGap: 5,
  );
  bool playing = false;
  bool playerLoading = true;
  bool lyricsLoading = true;

  LyricsReaderModel? lyricModel;
  String title;

  List<MediaItem> mediaItems = [];

  RxBool isEnglishLyricsSelected = true.obs;

  RxBool isSpanishLyricsSelected = false.obs;
  RxBool isHindiLyricsSelected = false.obs;

  ApiRepository apiRepository = ApiRepository();

  ShabadData shabadData;

  String normalLyrics = '';
  String englishLyrics = '';
  String translationLyrics = '';

  String spanishLyrics = '';
  String hindiLyrics = '';

  CustomPopupMenuController? controller = CustomPopupMenuController();
  ScrollController scrollController = ScrollController();

  StreamSubscription<MediaState>? subscription;

  DraggableScrollableController dragController =
      DraggableScrollableController();

  double sheetHeight = 0.1;

  BuildContext? draggableSheetContext;
  BuildContext? context;
  Duration? duration;

  double fontSizeOfLyricsMain = 25.0;
  double fontSizeOfLyricsExit = 20.0;
  double fontSizeOfLyricsMid = 20.0;

  double fontSizeOfLyricsSpanish = 20.0;
  double fontSizeOfLyricsHindi = 20.0;

  @override
  void onInit() {
    super.onInit();
    isMusicPlayerPageOpen = true;
    getPunjabiLyrics();
    initPlayer();
    saveRecentShabad();
  }

  Future<void> showMenuOptions(
    context,
    ShabadData shabadData,
  ) async {
    final myFavoriteListShabad = await SharedPref.getMyFavoriteList();
    bool isFindShabad = false;
    for (var i = 0; i < myFavoriteListShabad.length; i++) {
      if (myFavoriteListShabad[i].audio == shabadData.audio) {
        isFindShabad = true;
        break;
      }
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      useRootNavigator: false,
      builder: (context) {
        return Container(
          height: 260,
          color: secondPrimaryColor.withOpacity(0),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  bool isFind = false;
                  shabadData.title = title;
                  final myFavoriteList = await SharedPref.getMyFavoriteList();
                  if (myFavoriteList.isNotEmpty) {
                    for (var i = 0; i < myFavoriteList.length; i++) {
                      if (myFavoriteList[i].audio == shabadData.audio) {
                        isFind = true;
                        myFavoriteList.removeAt(i);
                        break;
                      }
                    }
                    if (!isFind) {
                      myFavoriteList.add(shabadData);
                    }
                  } else {
                    myFavoriteList.add(shabadData);
                  }
                  await SharedPref.saveMyFavoriteList(myFavoriteList);
                  Fluttertoast.showToast(
                    msg: isFind
                        ? 'Shabad removed from your favorite'
                        : "Shabad added to your favorite",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: darkBlueColor,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: secondPrimaryColor.withOpacity(0),
                  child: Row(
                    children: [
                      Icon(
                        isFindShabad ? Icons.favorite : Icons.favorite_border,
                        color: secondPrimaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        isFindShabad
                            ? 'Remove from favorite'
                            : 'Add to favorite',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: poppinsBold,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.withOpacity(0.2),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  goToLibraryPage(context, true, shabadData);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: secondPrimaryColor.withOpacity(0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline_sharp,
                        color: secondPrimaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add to playlist',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: poppinsBold,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.withOpacity(0.2),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(darkBlueColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
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

  Future<void> saveRecentShabad() async {
    final List<ShabadData> savedDownloadList = await SharedPref.getList();
    bool alreadyContains = false;
    if (savedDownloadList.isNotEmpty) {
      for (var i = 0; i < savedDownloadList.length; i++) {
        if (savedDownloadList[i].audio.toString().trim() ==
            shabadData.audio.toString().trim()) {
          alreadyContains = true;
          break;
        } else {
          alreadyContains = false;
        }
      }
    }
    if (!alreadyContains) {
      shabadData.title = title;
      savedDownloadList.insert(0, shabadData);
    }
    SharedPref.saveList(savedDownloadList);
    final controller = Get.put(HomeController(buildContext: context));
    controller.getRecentData();
  }

  Future<void> getPunjabiLyrics() async {
    try {
      final fontSize = await SharedPref.getFontSizePref();
      if (fontSize == '1x') {
        fontSizeOfLyricsMain = 25.0;
        fontSizeOfLyricsExit = 20.0;
        fontSizeOfLyricsMid = 20.0;
        fontSizeOfLyricsSpanish = 20.0;
        fontSizeOfLyricsHindi = 20.0;
      } else if (fontSize == '2x') {
        fontSizeOfLyricsMain = 26.0;
        fontSizeOfLyricsExit = 21.0;
        fontSizeOfLyricsMid = 21.0;
        fontSizeOfLyricsSpanish = 21.0;
        fontSizeOfLyricsHindi = 21.0;
      } else if (fontSize == '3x') {
        fontSizeOfLyricsMain = 27.0;
        fontSizeOfLyricsExit = 22.0;
        fontSizeOfLyricsMid = 22.0;
        fontSizeOfLyricsSpanish = 22.0;
        fontSizeOfLyricsHindi = 22.0;
      } else {
        fontSizeOfLyricsMain = 28.0;
        fontSizeOfLyricsExit = 23.0;
        fontSizeOfLyricsMid = 23.0;
        fontSizeOfLyricsSpanish = 23.0;
        fontSizeOfLyricsHindi = 23.0;
      }
      update();

      if (playingLyricModel == null) {
        normalLyrics = '';
        apiRepository
            .getPunjabiLyrics(shabadData.jsonData ?? '')
            .then((punjabiLyricsModel) {
          if (punjabiLyricsModel.error == null) {
            if (punjabiLyricsModel.lyrics != null) {
              if (punjabiLyricsModel.lyrics!.isNotEmpty) {
                for (var i = 0; i < punjabiLyricsModel.lyrics!.length; i++) {
                  String lyrics =
                      '[${printDuration(Duration(milliseconds: punjabiLyricsModel.lyrics![i].time))}] ${punjabiLyricsModel.lyrics![i].line}';

                  normalLyrics = '$normalLyrics\n$lyrics';
                }
              }
            }
          }
          translationLyrics = '';
          if (shabadData.englishTransLyrics != null) {
            for (var i = 0; i < shabadData.englishTransLyrics!.length; i++) {
              String lyrics =
                  '[${printDuration(Duration(milliseconds: shabadData.englishTransLyrics![i].time))}] ${shabadData.englishTransLyrics![i].line}';

              translationLyrics = '$translationLyrics\n$lyrics';
            }
          }

          englishLyrics = '';

          if (shabadData.englishLyrics != null) {
            for (var i = 0; i < shabadData.englishLyrics!.length; i++) {
              String lyrics =
                  '[${printDuration(Duration(milliseconds: shabadData.englishLyrics![i].time))}] ${shabadData.englishLyrics![i].line}';

              englishLyrics = '$englishLyrics\n$lyrics';
            }
          }

          spanishLyrics = '';
          if (shabadData.spanishLyrics != null) {
            for (var i = 0; i < shabadData.spanishLyrics!.length; i++) {
              String lyrics =
                  '[${printDuration(Duration(milliseconds: shabadData.spanishLyrics![i].time))}] ${shabadData.spanishLyrics![i].line}';

              spanishLyrics = '$spanishLyrics\n$lyrics';
            }
          }

          hindiLyrics = '';

          if (shabadData.hindiLyrics != null) {
            for (var i = 0; i < shabadData.hindiLyrics!.length; i++) {
              String lyrics =
                  '[${printDuration(Duration(milliseconds: shabadData.hindiLyrics![i].time))}] ${shabadData.hindiLyrics![i].line}';

              hindiLyrics = '$hindiLyrics\n$lyrics';
            }
          }

          playingNormalLyrics = normalLyrics;
          playingEnglishLyrics = englishLyrics;
          playingTranslationLyrics = translationLyrics;

          playingSpanishLyrics = spanishLyrics;
          playingHindiLyrics = hindiLyrics;

          if (normalLyrics.isNotEmpty) {
            LyricsModelBuilder modelBuilder =
                LyricsModelBuilder.create().bindLyricToMain(normalLyrics);

            if (isEnglishLyricsSelected.value && translationLyrics.isNotEmpty) {
              modelBuilder.bindLyricToMid(translationLyrics);
            }

            if (isEnglishLyricsSelected.value && englishLyrics.isNotEmpty) {
              modelBuilder.bindLyricToExt(englishLyrics);
            }

            if (isSpanishLyricsSelected.value && spanishLyrics.isNotEmpty) {
              modelBuilder.bindLyricToSpanish(spanishLyrics);
            }

            if (isHindiLyricsSelected.value && hindiLyrics.isNotEmpty) {
              // modelBuilder.bindLyricToHindi(hindiLyrics);
              String correctedHindiLyrics = correctHindiLyrics(hindiLyrics);
              modelBuilder.bindLyricToHindi(correctedHindiLyrics);
            }

            lyricModel = modelBuilder.getModel();
          } else {
            lyricModel = LyricsModelBuilder.create().getModel();
          }

          // if (isEnglishLyricsSelected.value &&isTranslationLyricsSelected.value &&englishLyrics.isNotEmpty &&translationLyrics.isNotEmpty) {
          //   if (normalLyrics.isNotEmpty) {
          //     lyricModel = LyricsModelBuilder.create()
          //         .bindLyricToMain(normalLyrics)
          //         .bindLyricToMid(translationLyrics)
          //         .bindLyricToExt(englishLyrics)
          //         .getModel();
          //   } else {
          //     lyricModel = LyricsModelBuilder.create()
          //         .bindLyricToMid(translationLyrics)
          //         .bindLyricToExt(englishLyrics)
          //         .getModel();
          //   }
          // } else if (isTranslationLyricsSelected.value &&
          //     translationLyrics.isNotEmpty) {
          //   if (normalLyrics.isNotEmpty) {
          //     lyricModel = LyricsModelBuilder.create()
          //         .bindLyricToMain(normalLyrics)
          //         .bindLyricToExt(translationLyrics)
          //         .getModel();
          //   } else {
          //     lyricModel = LyricsModelBuilder.create()
          //         .bindLyricToExt(translationLyrics)
          //         .getModel();
          //   }
          // } else if (isEnglishLyricsSelected.value &&
          //     englishLyrics.isNotEmpty) {
          //   if (normalLyrics.isNotEmpty) {
          //     lyricModel = LyricsModelBuilder.create()
          //         .bindLyricToMain(normalLyrics)
          //         .bindLyricToExt(englishLyrics)
          //         .getModel();
          //   } else {
          //     lyricModel = LyricsModelBuilder.create()
          //         .bindLyricToExt(englishLyrics)
          //         .getModel();
          //   }
          // } else {
          //   lyricModel = LyricsModelBuilder.create()
          //       .bindLyricToMain(normalLyrics)
          //       .getModel();
          // }
          playingLyricModel = lyricModel;
          lyricsLoading = false;
          update();
        });
      } else {
        lyricsLoading = false;
        englishLyrics = playingEnglishLyrics;
        normalLyrics = playingNormalLyrics;
        translationLyrics = playingTranslationLyrics;

        spanishLyrics = playingSpanishLyrics;
        hindiLyrics = playingHindiLyrics;

        lyricModel = playingLyricModel;
        update();
      }
    } catch (e) {
      print("Exception $e");
    }
  }

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String printDuration(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      String twoDigitHours = twoDigits(duration.inMinutes.remainder(300));
      return "$twoDigitHours:$twoDigitSeconds.00";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds.00";
    }
  }

  Future<void> initPlayer() async {
    bool addItems = false;

    if (audioHandler == null) {
      addItems = true;
      final player = AudioPlayer();
      duration = await player.setUrl(shabadData.audio ?? '');
      mediaItems = [];
      mediaItems.add(
        MediaItem(
          id: shabadData.audio ?? '',
          album: shabadData.albumart ?? '',
          title: title,
          artist: shabadData.song ?? '',
          duration: duration ?? const Duration(milliseconds: 100000),
          // duration: null,
          artUri: Uri.parse(''),
        ),
      );

      if (addItems) {
        for (var i = 0; i < listOfShabads.length; i++) {
          if (shabadData != listOfShabads[i]) {
            // duration = await player.setUrl(listOfShabads[i].audio ?? '');
            print("Duration of each episode ${duration!.inSeconds}");
            mediaItems.add(
              MediaItem(
                id: listOfShabads[i].audio ?? '',
                album: listOfShabads[i].albumart ?? '',
                title: title,
                artist: listOfShabads[i].song ?? '',
                // duration: duration ?? const Duration(milliseconds: 100000),
                duration: null,
                artUri: Uri.parse(''),
              ),
            );
          }
          // if (i + 1 == listOfShabads.length) {
          //   audioPlayerHandler.addQueueItems(mediaItems);
          // }
        }
      }

      audioPlayerHandler = AudioPlayerHandler(
        autoPlay: true,
        fromLocal: true,
        items: mediaItems,
      );

      audioHandler ??= await AudioService.init(
        cacheManager: null,
        builder: () => audioPlayerHandler,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
          androidNotificationChannelName: 'Audio playback',
          androidNotificationOngoing: true,
        ),
      );
    }

    playerLoading = false;
    update();

    final player = AudioPlayer();
    duration = await player.setUrl(shabadData.audio ?? '');
    subscription = mediaStateStream!.listen((event) async {
      playProgress = event.position.inMilliseconds;
      if (duration!.inSeconds > 0) {
        if (event.position.inSeconds > 0) {
          if (duration!.inSeconds == event.position.inSeconds) {
            if (playingListOfShabad!.length > 1) {
              int indexOfPlayingShabad = playingListOfShabad!
                  .indexWhere((element) => element == playingShabadData);

              if (indexOfPlayingShabad + 1 < playingListOfShabad!.length) {
                // if (!playerLoading) {
                //   playerLoading = true;
                if (audioHandler != null) {
                  // audioHandler!.pause();
                  // audioHandler!.stop();
                  // audioHandler = null;
                  playingLyricModel = null;
                  playingEnglishLyrics = '';
                  playingNormalLyrics = '';
                  playingTranslationLyrics = '';
                  playingSpanishLyrics = '';
                  playingHindiLyrics = '';
                  // if (shuffleOn) {
                  //   if (getRandomNumberFromList() < playingListOfShabad!.length) {
                  //     shabadData = playingListOfShabad![getRandomNumberFromList()];
                  //     playingShabadData =
                  //         playingListOfShabad![getRandomNumberFromList()];
                  //     playingSubtitle = playingShabadData!.song ?? '';
                  //     update();
                  //     onInit();
                  //   }
                  // } else {

                  shabadData = playingListOfShabad![indexOfPlayingShabad + 1];
                  playingShabadData =
                      playingListOfShabad![indexOfPlayingShabad + 1];
                  playingSubtitle = playingShabadData!.song ?? '';

                  isMusicPlayerPageOpen = true;
                  getPunjabiLyrics();
                  saveRecentShabad();
                  audioHandler!.skipToNext();
                  update();
                  sendBroadcast('actionMusicPlaying');

                  duration =
                      await player.setUrl(playingShabadData!.audio ?? '');
                  print("Duration of each episode ${duration!.inSeconds}");
                  final item = MediaItem(
                    id: playingShabadData!.audio ?? '',
                    album: playingShabadData!.albumart ?? '',
                    title: title,
                    artist: playingShabadData!.song ?? '',
                    duration: duration ?? const Duration(milliseconds: 100000),
                    artUri: Uri.parse(''),
                  );

                  audioPlayerHandler.mediaItem.add(item);
                  // onInit();
                  // }
                  // }
                }
              }
            }
          }
        }
      }
      update();
    });
    sendBroadcast('actionMusicPlaying');
  }

  String correctHindiLyrics(String input) {
    // Assuming the input string contains improperly rendered Unicode
    List<int> bytes =
        input.codeUnits; // Convert the string to UTF-16 code units
    return utf8.decode(bytes); // Decode it to proper UTF-8 string
  }

  void changeLyrics(bool englishLyricsSelected, bool spanishLyricsSelected,
      bool hindiLyricSelected) {
    isEnglishLyricsSelected.value = englishLyricsSelected;
    isSpanishLyricsSelected.value = spanishLyricsSelected;
    isHindiLyricsSelected.value = hindiLyricSelected;

    if (normalLyrics.isNotEmpty) {
      LyricsModelBuilder modelBuilder =
          LyricsModelBuilder.create().bindLyricToMain(normalLyrics);

      if (isEnglishLyricsSelected.value && translationLyrics.isNotEmpty) {
        modelBuilder.bindLyricToMid(translationLyrics);
      }

      if (isEnglishLyricsSelected.value && englishLyrics.isNotEmpty) {
        modelBuilder.bindLyricToExt(englishLyrics);
      }

      if (isSpanishLyricsSelected.value && spanishLyrics.isNotEmpty) {
        modelBuilder.bindLyricToSpanish(spanishLyrics);
      }

      if (isHindiLyricsSelected.value && hindiLyrics.isNotEmpty) {
        // print(hindiLyrics);
        String correctedHindiLyrics = correctHindiLyrics(hindiLyrics);
        // print(correctedHindiLyrics);
        modelBuilder.bindLyricToHindi(correctedHindiLyrics); 
      }

      lyricModel = modelBuilder.getModel();
    } else {
      lyricModel = LyricsModelBuilder.create().getModel();
    }

    // if (isEnglishLyricsSelected.value && isTranslationLyricsSelected.value && isSpanishLyricsSelected.value  && isHindiLyricsSelected.value  && englishLyrics.isNotEmpty && translationLyrics.isNotEmpty && spanishLyrics.isNotEmpty && hindiLyrics.isNotEmpty) {
    //   if (normalLyrics.isNotEmpty) {
    //     lyricModel = LyricsModelBuilder.create()
    //         .bindLyricToMain(normalLyrics)
    //         .bindLyricToMid(translationLyrics)
    //         .bindLyricToExt(englishLyrics)
    //         .bindLyricToSpanish(spanishLyrics)
    //         .bindLyricToHindi(hindiLyrics)
    //         .getModel();
    //   } else {
    //     lyricModel = LyricsModelBuilder.create()
    //         .bindLyricToMid(translationLyrics)
    //         .bindLyricToExt(englishLyrics)
    //         .getModel();
    //   }
    // } else if (isTranslationLyricsSelected.value && translationLyrics.isNotEmpty) {
    //   if (normalLyrics.isNotEmpty) {
    //     lyricModel = LyricsModelBuilder.create()
    //         .bindLyricToMain(normalLyrics)
    //         .bindLyricToExt(translationLyrics)
    //         .getModel();
    //   } else {
    //     lyricModel = LyricsModelBuilder.create()
    //         .bindLyricToExt(translationLyrics)
    //         .getModel();
    //   }
    // } else if (isEnglishLyricsSelected.value && englishLyrics.isNotEmpty) {
    //   if (normalLyrics.isNotEmpty) {
    //     lyricModel = LyricsModelBuilder.create()
    //         .bindLyricToMain(normalLyrics)
    //         .bindLyricToExt(englishLyrics)
    //         .getModel();
    //   } else {
    //     lyricModel = LyricsModelBuilder.create()
    //         .bindLyricToExt(englishLyrics)
    //         .getModel();
    //   }
    // } else {
    //   lyricModel =
    //       LyricsModelBuilder.create().bindLyricToMain(normalLyrics).getModel();
    // }
    update();
  }

  void changeSheetHeight() {
    if (sheetHeight == 0.1) {
      sheetHeight = 1.0;
    } else {
      sheetHeight = 0.1;
    }
    update();
  }

  @override
  void onClose() {
    super.onClose();
    isMusicPlayerPageOpen = false;
    if (subscription != null) {
      subscription!.cancel();
    }
  }
}
