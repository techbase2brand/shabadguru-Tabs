import 'package:get/get.dart';
import 'package:shabadguru/network_service/models/my_playlist_model.dart';
import 'package:shabadguru/utils/shared_pref.dart';

// Controller for managing playlist selection functionality and state
class SelectPlaylistController extends GetxController {
  List<MyPlaylistModel>? myPlaylist; // List of user's playlists
  List<MyPlaylistModel> selectedPlaylistList = []; // List of selected playlists

  // Initialize controller and load playlists
  @override
  void onInit() {
    super.onInit();
    getMyPlaylistFromLocal(); // Load playlists from local storage
  }

  // Load user's playlists from local storage
  Future<void> getMyPlaylistFromLocal() async {
    myPlaylist = await SharedPref.getMyPlaylist(); // Get playlists from shared preferences
    update(); // Update UI
  }
}
