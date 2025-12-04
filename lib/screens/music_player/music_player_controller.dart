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

// Controller for managing music player functionality and state
class MusicPlayerController extends GetxController {
  MusicPlayerController(
      {required this.shabadData,
      required this.title,
      required this.context,
      required this.listOfShabads});
  
  int playProgress = 0; // Current playback progress in milliseconds

  List<ShabadData> listOfShabads; // List of all shabads in current playlist

  // Lyrics UI configuration with inline gap
  var lyricUI = UINetease(
    inlineGap: 5, // Gap between lyrics lines
  );
  bool playing = false; // Current playing state
  bool playerLoading = true; // Player initialization loading state
  bool lyricsLoading = true; // Lyrics loading state

  LyricsReaderModel? lyricModel; // Model for lyrics display
  String title; // Current shabad title

  List<MediaItem> mediaItems = []; // Media items for audio service

  // Lyrics language selection states
  RxBool isEnglishLyricsSelected = true.obs; // English lyrics toggle
  RxBool isSpanishLyricsSelected = false.obs; // Spanish lyrics toggle
  RxBool isHindiLyricsSelected = false.obs; // Hindi lyrics toggle

  ApiRepository apiRepository = ApiRepository(); // API service for lyrics

  ShabadData shabadData; // Current playing shabad data

  // Lyrics text in different languages
  String normalLyrics = ''; // Punjabi/Gurmukhi lyrics
  String englishLyrics = ''; // English translation lyrics
  String translationLyrics = ''; // English translation lyrics

  String spanishLyrics = ''; // Spanish translation lyrics
  String hindiLyrics = ''; // Hindi translation lyrics

  CustomPopupMenuController? controller = CustomPopupMenuController(); // Popup menu controller
  ScrollController scrollController = ScrollController(); // Scroll controller for lyrics

  StreamSubscription<MediaState>? subscription; // Media state subscription

  DraggableScrollableController dragController =
      DraggableScrollableController(); // Draggable sheet controller

  double sheetHeight = 0.1; // Height of draggable sheet (0.1 = collapsed, 1.0 = expanded)

  BuildContext? draggableSheetContext; // Context for draggable sheet
  BuildContext? context; // Main context
  Duration? duration; // Current audio duration

  // Font sizes for different lyrics languages
  double fontSizeOfLyricsMain = 25.0; // Main lyrics font size
  double fontSizeOfLyricsExit = 20.0; // Exit lyrics font size
  double fontSizeOfLyricsMid = 20.0; // Mid lyrics font size

  double fontSizeOfLyricsSpanish = 20.0; // Spanish lyrics font size
  double fontSizeOfLyricsHindi = 20.0; // Hindi lyrics font size

  // Initialize controller and set up music player
  @override
  void onInit() {
    super.onInit();
    isMusicPlayerPageOpen = true; // Mark music player page as open
    getPunjabiLyrics(); // Load lyrics for current shabad
    initPlayer(); // Initialize audio player
    saveRecentShabad(); // Save current shabad to recent list
  }

  // Show bottom sheet menu with options for shabad (favorite, playlist)
  Future<void> showMenuOptions(
    context,
    ShabadData shabadData,
  ) async {
    final myFavoriteListShabad = await SharedPref.getMyFavoriteList(); // Get favorite list
    bool isFindShabad = false; // Check if shabad is already in favorites
    // Check if current shabad is already in favorites
    for (var i = 0; i < myFavoriteListShabad.length; i++) {
      if (myFavoriteListShabad[i].audio == shabadData.audio) {
        isFindShabad = true; // Found in favorites
        break;
      }
    }
    // Show modal bottom sheet with menu options
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, // Not scroll controlled
      constraints: const BoxConstraints(
        maxWidth: double.infinity, // Full width
      ),
      useRootNavigator: false, // Use current navigator
      builder: (context) {
        return Container(
          height: 260, // Fixed height
          color: secondPrimaryColor.withOpacity(0), // Transparent background
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Container padding
          child: Column(
            children: [
              // Add/Remove from favorites option
              GestureDetector(
                onTap: () async {
                  bool isFind = false; // Track if shabad is found in favorites
                  shabadData.title = title; // Set shabad title
                  final myFavoriteList = await SharedPref.getMyFavoriteList(); // Get current favorites
                  if (myFavoriteList.isNotEmpty) {
                    // Check if shabad is already in favorites
                    for (var i = 0; i < myFavoriteList.length; i++) {
                      if (myFavoriteList[i].audio == shabadData.audio) {
                        isFind = true; // Found in favorites
                        myFavoriteList.removeAt(i); // Remove from favorites
                        break;
                      }
                    }
                    if (!isFind) {
                      myFavoriteList.add(shabadData); // Add to favorites
                    }
                  } else {
                    myFavoriteList.add(shabadData); // Add to empty favorites list
                  }
                  await SharedPref.saveMyFavoriteList(myFavoriteList); // Save updated favorites
                  // Show success message
                  Fluttertoast.showToast(
                    msg: isFind
                        ? 'Shabad removed from your favorite' // Removal message
                        : "Shabad added to your favorite", // Addition message
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: darkBlueColor,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.of(context).pop(); // Close bottom sheet
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding
                  color: secondPrimaryColor.withOpacity(0), // Transparent background
                  child: Row(
                    children: [
                      Icon(
                        isFindShabad ? Icons.favorite : Icons.favorite_border, // Heart icon based on favorite status
                        color: secondPrimaryColor, // Icon color
                        size: 18, // Icon size
                      ),
                      const SizedBox(
                        width: 10, // Spacing between icon and text
                      ),
                      Text(
                        isFindShabad
                            ? 'Remove from favorite' // Remove text if already favorite
                            : 'Add to favorite', // Add text if not favorite
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
                color: Colors.grey.withOpacity(0.2), // Divider line
              ),
              // Add to playlist option
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close bottom sheet
                  goToLibraryPage(context, true, shabadData); // Navigate to library page
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding
                  color: secondPrimaryColor.withOpacity(0), // Transparent background
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline_sharp, // Playlist icon
                        color: secondPrimaryColor, // Icon color
                        size: 18, // Icon size
                      ),
                      const SizedBox(
                        width: 10, // Spacing between icon and text
                      ),
                      Text(
                        'Add to playlist', // Playlist option text
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
                color: Colors.grey.withOpacity(0.2), // Divider line
              ),
              const SizedBox(
                height: 15, // Spacing before cancel button
              ),
              // Cancel button row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(darkBlueColor)), // Button background
                    onPressed: () {
                      Navigator.of(context).pop(); // Close bottom sheet
                    },
                    child: const Center(
                      child: Text(
                        'Cancel', // Cancel button text
                        style: TextStyle(color: Colors.white), // White text
                      ),
                    ),
                  ),
                ],
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

  // Save current shabad to recent played list
  Future<void> saveRecentShabad() async {
    final List<ShabadData> savedDownloadList = await SharedPref.getList(); // Get recent list
    bool alreadyContains = false; // Track if shabad already exists
    if (savedDownloadList.isNotEmpty) {
      // Check if current shabad is already in recent list
      for (var i = 0; i < savedDownloadList.length; i++) {
        if (savedDownloadList[i].audio.toString().trim() ==
            shabadData.audio.toString().trim()) {
          alreadyContains = true; // Found in recent list
          break;
        } else {
          alreadyContains = false; // Not found
        }
      }
    }
    if (!alreadyContains) {
      shabadData.title = title; // Set shabad title
      savedDownloadList.insert(0, shabadData); // Add to beginning of list
    }
    SharedPref.saveList(savedDownloadList); // Save updated recent list
    final controller = Get.put(HomeController(buildContext: context)); // Get home controller
    controller.getRecentData(); // Refresh recent data in home screen
  }

  // Load lyrics for current shabad in multiple languages
  Future<void> getPunjabiLyrics() async {
    try {
      final fontSize = await SharedPref.getFontSizePref(); // Get saved font size preference
      // Set font sizes based on user preference
      if (fontSize == '1x') {
        fontSizeOfLyricsMain = 25.0; // Main lyrics font size
        fontSizeOfLyricsExit = 20.0; // Exit lyrics font size
        fontSizeOfLyricsMid = 20.0; // Mid lyrics font size
        fontSizeOfLyricsSpanish = 20.0; // Spanish lyrics font size
        fontSizeOfLyricsHindi = 20.0; // Hindi lyrics font size
      } else if (fontSize == '2x') {
        fontSizeOfLyricsMain = 26.0; // Increased main lyrics font size
        fontSizeOfLyricsExit = 21.0; // Increased exit lyrics font size
        fontSizeOfLyricsMid = 21.0; // Increased mid lyrics font size
        fontSizeOfLyricsSpanish = 21.0; // Increased Spanish lyrics font size
        fontSizeOfLyricsHindi = 21.0; // Increased Hindi lyrics font size
      } else if (fontSize == '3x') {
        fontSizeOfLyricsMain = 27.0; // Larger main lyrics font size
        fontSizeOfLyricsExit = 22.0; // Larger exit lyrics font size
        fontSizeOfLyricsMid = 22.0; // Larger mid lyrics font size
        fontSizeOfLyricsSpanish = 22.0; // Larger Spanish lyrics font size
        fontSizeOfLyricsHindi = 22.0; // Larger Hindi lyrics font size
      } else {
        fontSizeOfLyricsMain = 28.0; // Largest main lyrics font size
        fontSizeOfLyricsExit = 23.0; // Largest exit lyrics font size
        fontSizeOfLyricsMid = 23.0; // Largest mid lyrics font size
        fontSizeOfLyricsSpanish = 23.0; // Largest Spanish lyrics font size
        fontSizeOfLyricsHindi = 23.0; // Largest Hindi lyrics font size
      }
      update(); // Update UI with new font sizes

      // Load lyrics if not already loaded
      if (playingLyricModel == null) {
        normalLyrics = ''; // Reset normal lyrics
        // Fetch Punjabi lyrics from API
        apiRepository
            .getPunjabiLyrics(shabadData.jsonData ?? '')
            .then((punjabiLyricsModel) {
          if (punjabiLyricsModel.error == null) {
            if (punjabiLyricsModel.lyrics != null) {
              if (punjabiLyricsModel.lyrics!.isNotEmpty) {
                // Process each lyric line with timestamp
                for (var i = 0; i < punjabiLyricsModel.lyrics!.length; i++) {
                  String lyrics =
                      '[${printDuration(Duration(milliseconds: punjabiLyricsModel.lyrics![i].time))}] ${punjabiLyricsModel.lyrics![i].line}';

                  normalLyrics = '$normalLyrics\n$lyrics'; // Append to normal lyrics
                }
              }
            }
          }
          translationLyrics = '';
          // Check shabadData for lyrics (loaded from local JSON for Nitnem)
          if (shabadData.englishTransLyrics != null && shabadData.englishTransLyrics!.isNotEmpty) {
            for (var i = 0; i < shabadData.englishTransLyrics!.length; i++) {
              String lyrics =
                  '[${printDuration(Duration(milliseconds: shabadData.englishTransLyrics![i].time))}] ${shabadData.englishTransLyrics![i].line}';

              translationLyrics = '$translationLyrics\n$lyrics';
            }
          }

          englishLyrics = '';
          // Check shabadData for lyrics (loaded from local JSON for Nitnem)
          if (shabadData.englishLyrics != null && shabadData.englishLyrics!.isNotEmpty) {
            for (var i = 0; i < shabadData.englishLyrics!.length; i++) {
              String lyrics =
                  '[${printDuration(Duration(milliseconds: shabadData.englishLyrics![i].time))}] ${shabadData.englishLyrics![i].line}';

              englishLyrics = '$englishLyrics\n$lyrics';
            }
          }

          spanishLyrics = '';
          // Check shabadData for lyrics (loaded from local JSON for Nitnem)
          if (shabadData.spanishLyrics != null && shabadData.spanishLyrics!.isNotEmpty) {
            for (var i = 0; i < shabadData.spanishLyrics!.length; i++) {
              String lyrics =
                  '[${printDuration(Duration(milliseconds: shabadData.spanishLyrics![i].time))}] ${shabadData.spanishLyrics![i].line}';

              spanishLyrics = '$spanishLyrics\n$lyrics';
            }
          }

          hindiLyrics = '';
          // Check shabadData for lyrics (loaded from local JSON for Nitnem)
          if (shabadData.hindiLyrics != null && shabadData.hindiLyrics!.isNotEmpty) {
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

          // Build lyrics model - use any available lyrics, even if normalLyrics is empty
          LyricsModelBuilder modelBuilder = LyricsModelBuilder.create();
          
          // Use normalLyrics (Punjabi) as main if available, otherwise use first available language
          if (normalLyrics.isNotEmpty) {
            modelBuilder.bindLyricToMain(normalLyrics);
          } else if (translationLyrics.isNotEmpty) {
            modelBuilder.bindLyricToMain(translationLyrics);
          } else if (englishLyrics.isNotEmpty) {
            modelBuilder.bindLyricToMain(englishLyrics);
          } else if (spanishLyrics.isNotEmpty) {
            modelBuilder.bindLyricToMain(spanishLyrics);
          } else if (hindiLyrics.isNotEmpty) {
            String correctedHindiLyrics = correctHindiLyrics(hindiLyrics);
            modelBuilder.bindLyricToMain(correctedHindiLyrics);
          }

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

  // Format single digit numbers with leading zero
  String twoDigits(int n) {
    if (n >= 10) return "$n"; // Return as is if double digit
    return "0$n"; // Add leading zero for single digit
  }

  // Format duration to MM:SS.00 or HH:MM:SS.00 format
  String printDuration(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60)); // Minutes with leading zero
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60)); // Seconds with leading zero
    if (duration.inHours > 0) {
      String twoDigitHours = twoDigits(duration.inMinutes.remainder(300)); // Hours with leading zero
      return "$twoDigitHours:$twoDigitSeconds.00"; // HH:SS.00 format
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds.00"; // MM:SS.00 format
    }
  }

  // Initialize audio player and set up media items
  Future<void> initPlayer() async {
    bool addItems = false; // Track if items need to be added

    if (audioHandler == null) {
      addItems = true; // Mark that items need to be added
      final player = AudioPlayer(); // Create audio player instance
      duration = await player.setUrl(shabadData.audio ?? ''); // Get audio duration
      mediaItems = []; // Initialize media items list
      // Add current shabad as first media item
      mediaItems.add(
        MediaItem(
          id: shabadData.audio ?? '', // Audio URL as ID
          album: shabadData.albumart ?? '', // Album art URL
          title: title, // Shabad title
          artist: shabadData.song ?? '', // Song name as artist
          duration: duration ?? const Duration(milliseconds: 100000), // Audio duration
          // duration: null,
          artUri: Uri.parse(''), // Empty art URI
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

  // Correct Hindi lyrics encoding issues
  String correctHindiLyrics(String input) {
    // Check if the text already contains valid Hindi (Devanagari) characters
    // Hindi/Devanagari script range: U+0900 to U+097F
    bool hasValidHindi = false;
    for (int i = 0; i < input.length; i++) {
      int codeUnit = input.codeUnitAt(i);
      // Check for Devanagari script range (U+0900 to U+097F) or common Hindi characters
      if ((codeUnit >= 0x0900 && codeUnit <= 0x097F) || 
          (codeUnit >= 0x0980 && codeUnit <= 0x09FF)) { // Bengali/Assamese (similar)
        hasValidHindi = true;
        break;
      }
    }
    
    // If text already contains valid Hindi characters, return as is (for Nitnem)
    if (hasValidHindi) {
      return input;
    }
    
    // Otherwise, apply correction for Banis/Raags with encoding issues
    // Assuming the input string contains improperly rendered Unicode
    try {
      List<int> bytes = input.codeUnits; // Convert the string to UTF-16 code units
      return utf8.decode(bytes); // Decode it to proper UTF-8 string
    } catch (e) {
      // If decoding fails, return original text
      return input;
    }
  }

  // Change lyrics language selection and rebuild lyrics model
  void changeLyrics(bool englishLyricsSelected, bool spanishLyricsSelected,
      bool hindiLyricSelected) {
    isEnglishLyricsSelected.value = englishLyricsSelected; // Set English lyrics selection
    isSpanishLyricsSelected.value = spanishLyricsSelected; // Set Spanish lyrics selection
    isHindiLyricsSelected.value = hindiLyricSelected; // Set Hindi lyrics selection

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

  // Toggle draggable sheet height between collapsed and expanded
  void changeSheetHeight() {
    if (sheetHeight == 0.1) {
      sheetHeight = 1.0; // Expand sheet to full height
    } else {
      sheetHeight = 0.1; // Collapse sheet to minimal height
    }
    update(); // Update UI
  }

  // Clean up resources when controller is disposed
  @override
  void onClose() {
    super.onClose();
    isMusicPlayerPageOpen = false; // Mark music player page as closed
    if (subscription != null) {
      subscription!.cancel(); // Cancel media state subscription
    }
  }
}
