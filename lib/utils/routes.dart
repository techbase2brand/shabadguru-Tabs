import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
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

goToMusicPlayerPage(context, ShabadData shabadData, String title,
    List<ShabadData> listOfShabads) {
  if (audioHandler != null) {
    if (playingShabadData != null) {
      if (playingShabadData != shabadData) {
        playingLyricModel = null;
        playingTitle = title;
        playingSubtitle = shabadData.song ?? '';
        playingListOfShabad = listOfShabads;
        playingShabadData = shabadData;
        audioHandler!.pause();
        audioHandler!.stop();
        audioHandler = null;
      } else {
        playingTitle = title;
        playingSubtitle = shabadData.song ?? '';
        playingListOfShabad = listOfShabads;
        playingShabadData = shabadData;
      }
    } else {
      playingTitle = title;
      playingSubtitle = shabadData.song ?? '';
      playingListOfShabad = listOfShabads;
      playingShabadData = shabadData;
    }
  }
  pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'music_player_page'),
    screen: MusicPlayerScreen(
      shabadData: shabadData,
      title: title,
      listOfShabads: listOfShabads,
    ),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}

goToTheKirtanisPage(context) {
  pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'the_kirtanis_page'),
    screen: const TheKirtanisScreen(),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}

goToShabadHomePage(context, String categoryId, String id, String title) {
  pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'shabad_page_home'),
    screen: ShabadScreen(
      categoryId: categoryId,
      id: id,
      title: title,
    ),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}

goToShabadBanisPage(context, String categoryId, String id, String title) {
  pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'shabad_page_banis'),
    screen: ShabadScreenBanis(
      categoryId: categoryId,
      id: id,
      title: title,
    ),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}

goToShabadRaagPage(context, String categoryId, String id, String title) {
  pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'shabad_page_raag'),
    screen: ShabadScreenRaags(
      categoryId: categoryId,
      id: id,
      title: title,
    ),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}

Future<dynamic> goToRecentPage(context, List<ShabadData> listOfShabads,) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'recent'),
    screen: RecentScreen(
      listOfShabads: listOfShabads,
    ),
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}


Future<dynamic> goToLibraryPage(context,bool isSelectForPlaylist,ShabadData? shabadData) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'library'),
    screen: LibraryScreen(isSelectedPlaylist: isSelectForPlaylist, shabadData: shabadData),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}


Future<dynamic> goToSelectRaagsScreen(context,indexOfList) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'select_raags'),
    screen: RaagSelectPage(indexOfList: indexOfList,),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}

Future<dynamic> goToSelectShabadScreen(context, int indexOfList,String title) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'select_shabad'),
    screen: SelectShabadPage(indexOfList: indexOfList, title: title,),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}
Future<dynamic> goToSettingScreen(context) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'settings'),
    screen: const SettingsScreen(),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}

Future<dynamic> goToLibraryDetailsScreen(context,String title,int index) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'library_details'),
    screen:  LibraryDetails(title: title,libraryIndex: index,),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}

Future<dynamic> goToMyFavoriteScreen(context) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'my_favorite'),
    screen:  const MyFavoriteShabadScreen(),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}

Future<dynamic> goToMySelectPlaylistScreen(context,ShabadData shabadData) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'select_playlist'),
    screen:   SelectPlaylistScreen(shabadData: shabadData ,),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}

Future<dynamic> goToEmailSubscribeScreen(context) async {
  final result = await pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: 'email_subscribe'),
    screen: const EmailSubscribeScreen(),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
  return result;
}