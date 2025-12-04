// Shared preferences utility for local data storage
import 'package:shabadguru/network_service/models/my_playlist_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Utility class for managing local data storage using SharedPreferences
class SharedPref {
  // Save recent Shabads list to local storage
  static void saveList(List<ShabadData> list) async {
    final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    final encodedList = list.map((person) => person.toJson2()).toList(); // Convert to JSON strings
    await prefs.setStringList('recentShabadData', encodedList); // Save to local storage
  }

  // Get recent Shabads list from local storage
  static Future<List<ShabadData>> getList() async {
    final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    final encodedList = prefs.getStringList('recentShabadData'); // Get saved list
    if (encodedList != null) {
      return encodedList
          .map((jsonString) => ShabadData.fromJson2(jsonString)) // Convert from JSON strings
          .toList();
    }
    return []; // Return empty list if no data found
  }

  // Get user's custom playlists from local storage
  static Future<List<MyPlaylistModel>> getMyPlaylist() async {
    final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    final encodedList = prefs.getStringList('myPlaylistData'); // Get saved playlist data
    if (encodedList != null) {
      return encodedList
          .map((jsonString) => MyPlaylistModel.fromJson2(jsonString)) // Convert from JSON strings
          .toList();
    }
    return []; // Return empty list if no data found
  }

  // Save user's custom playlists to local storage
  static Future<void> savePlaylist(List<MyPlaylistModel> list) async {
    final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    final encodedList = list.map((person) => person.toJson2()).toList(); // Convert to JSON strings
    await prefs.setStringList('myPlaylistData', encodedList); // Save to local storage
  }

  static Future<void> saveFontPref(String value) async {
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
