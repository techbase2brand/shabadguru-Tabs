import 'package:shabadguru/network_service/models/my_playlist_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static void saveList(List<ShabadData> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = list.map((person) => person.toJson2()).toList();
    await prefs.setStringList('recentShabadData', encodedList);
  }

  static Future<List<ShabadData>> getList() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('recentShabadData');
    if (encodedList != null) {
      return encodedList
          .map((jsonString) => ShabadData.fromJson2(jsonString))
          .toList();
    }
    return [];
  }

  static Future<List<MyPlaylistModel>> getMyPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('myPlaylistData');
    if (encodedList != null) {
      return encodedList
          .map((jsonString) => MyPlaylistModel.fromJson2(jsonString))
          .toList();
    }
    return [];
  }

  static Future<void> savePlaylist(List<MyPlaylistModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = list.map((person) => person.toJson2()).toList();
    await prefs.setStringList('myPlaylistData', encodedList);
  }

  static saveFontPref(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontSizeValue', value);
  }

  static Future<String> getFontSizePref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fontSizeValue')?? '1x';    
  }


    static Future<List<ShabadData>> getMyFavoriteList() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList('myFavoriteList');
    if (encodedList != null) {
      return encodedList
          .map((jsonString) => ShabadData.fromJson2(jsonString))
          .toList();
    }
    return [];
  }

  static Future<void> saveMyFavoriteList(List<ShabadData> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = list.map((person) => person.toJson2()).toList();
    await prefs.setStringList('myFavoriteList', encodedList);
  }

   static void saveNotificationStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_status', status);
  }

  static Future<bool> getNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification_status')??true;
  }

}
