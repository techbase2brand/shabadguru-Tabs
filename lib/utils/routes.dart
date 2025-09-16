// Navigation route functions for the ShabadGuru app
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/screens/email_subscribe/email_subcribe_screen.dart';
import 'package:shabadguru/screens/library/library_screen.dart';
import 'package:shabadguru/screens/library_details/library_details.dart';
import 'package:shabadguru/screens/music_player/music_player_screen.dart';
import 'package:shabadguru/screens/my_favorite_shabad/my_favorite_shabad_screen.dart';
import 'package:shabadguru/screens/raag_select/raag_select_page.dart';
import 'package:shabadguru/screens/recent_played/recent_played_screen.dart';
import 'package:shabadguru/screens/select_playlist/select_playlist_screen.dart';
import 'package:shabadguru/screens/select_shabad/select_shabad_page.dart';
import 'package:shabadguru/screens/settings/settings_screen.dart';
import 'package:shabadguru/screens/shabad_banis/shabad_screen_banis.dart';
import 'package:shabadguru/screens/shabad_home/shabad_screen.dart';
import 'package:shabadguru/screens/shabad_raags/shabad_screen_raags.dart';
import 'package:shabadguru/screens/the_kirtanis/the_kirtanis_screen.dart';

// Navigate to music player page with audio state management
goToMusicPlayerPage(context, ShabadData shabadData, String title,
    List<ShabadData> listOfShabads) {
  if (audioHandler != null) {
    if (playingShabadData != null) {
      if (playingShabadData != shabadData) {
        // Different Shabad selected - reset audio state
        playingLyricModel = null; // Clear lyrics model
        playingTitle = title; // Set new title
        playingSubtitle = shabadData.song ?? ''; // Set new subtitle
        playingListOfShabad = listOfShabads; // Set new playlist
        playingShabadData = shabadData; // Set new Shabad data
        audioHandler!.pause(); // Pause current audio
        audioHandler!.stop(); // Stop current audio
        audioHandler = null; // Clear audio handler
      } else {
        // Same Shabad selected - update state without stopping audio
        playingTitle = title; // Update title
        playingSubtitle = shabadData.song ?? ''; // Update subtitle
        playingListOfShabad = listOfShabads; // Update playlist
        playingShabadData = shabadData; // Update Shabad data
      }
    } else {
      // No audio currently playing - set new state
      playingTitle = title; // Set title
      playingSubtitle = shabadData.song ?? ''; // Set subtitle
      playingListOfShabad = listOfShabads; // Set playlist
      playingShabadData = shabadData; // Set Shabad data
    }
  }
  // Navigate to music player screen
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: MusicPlayerScreen(
      shabadData: shabadData, // Pass Shabad data
      title: title, // Pass title
      listOfShabads: listOfShabads, // Pass playlist
    ),
    withNavBar: false, // Hide bottom navigation bar
    pageTransitionAnimation: PageTransitionAnimation.cupertino, // iOS-style transition
    // routeSettings: const RouteSettings(name: 'music_player_page'),
  );
}

// Navigate to The Kirtanis page
goToTheKirtanisPage(context) {
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const TheKirtanisScreen(), // The Kirtanis screen
    withNavBar: true, // Show bottom navigation bar
    pageTransitionAnimation: PageTransitionAnimation.cupertino, // iOS-style transition
    // routeSettings: const RouteSettings(name: 'the_kirtanis_page'),
  );
}

goToShabadHomePage(context, String categoryId, String id, String title) {
 PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: ShabadScreen(
      categoryId: categoryId,
      id: id,
      title: title,
    ),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'shabad_page_home'),
  );
}

goToShabadBanisPage(context, String categoryId, String id, String title) {
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: ShabadScreenBanis(
      categoryId: categoryId,
      id: id,
      title: title,
    ),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'shabad_page_banis'),
  );
}

goToShabadRaagPage(context, String categoryId, String id, String title) {
PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: ShabadScreenRaags(
      categoryId: categoryId,
      id: id,
      title: title,
    ),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'shabad_page_raag'),
  );
}

Future<dynamic> goToRecentPage(context, List<ShabadData> listOfShabads) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: RecentScreen(
      listOfShabads: listOfShabads,
    ),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'recent'),
  );
  return result;
}

Future<dynamic> goToLibraryPage(
    context, bool isSelectForPlaylist, ShabadData? shabadData) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: LibraryScreen(
        isSelectedPlaylist: isSelectForPlaylist, shabadData: shabadData),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'library'),
  );
  return result;
}

Future<dynamic> goToSelectRaagsScreen(context, indexOfList) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: RaagSelectPage(indexOfList: indexOfList),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'select_raags'),
  );
  return result;
}

Future<dynamic> goToSelectShabadScreen(
    context, int indexOfList, String title) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: SelectShabadPage(indexOfList: indexOfList, title: title),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'select_shabad'),
  );
  return result;
}

Future<dynamic> goToSettingScreen(context) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const SettingsScreen(),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'settings'),
  );
  return result;
}

Future<dynamic> goToLibraryDetailsScreen(
    context, String title, int index) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: LibraryDetails(title: title, libraryIndex: index),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'library_details'),
  );
  return result;
}

Future<dynamic> goToMyFavoriteScreen(context) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const MyFavoriteShabadScreen(),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'my_favorite'),
  );
  return result;
}

Future<dynamic> goToMySelectPlaylistScreen(context, ShabadData shabadData) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: SelectPlaylistScreen(shabadData: shabadData),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'select_playlist'),
  );
  return result;
}

Future<dynamic> goToEmailSubscribeScreen(context) async {
  final result = await PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const EmailSubscribeScreen(),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
    // routeSettings: const RouteSettings(name: 'email_subscribe'),
  );
  return result;
}
