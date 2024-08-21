import 'package:get/get.dart';
import 'package:shabadguru/network_service/models/my_playlist_model.dart';
import 'package:shabadguru/utils/shared_pref.dart';

class SelectPlaylistController extends GetxController {
  List<MyPlaylistModel>? myPlaylist;
  List<MyPlaylistModel> selectedPlaylistList = [];

  @override
  void onInit() {
    super.onInit();
    getMyPlaylistFromLocal();
  }

  Future<void> getMyPlaylistFromLocal() async {
    myPlaylist = await SharedPref.getMyPlaylist();
    update();
  }
}
