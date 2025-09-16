// Model class for user's custom playlists
import 'dart:convert';

import 'package:shabadguru/network_service/models/shabad_raag_model.dart';

// Model class for managing user's custom playlists
class MyPlaylistModel {
  String? playlistName; // Name of the playlist
  List<ShabadData>? shabadList; // List of Shabads in the playlist
  bool isSelected = false; // Selection state for UI
  MyPlaylistModel({required this.shabadList, required this.playlistName});

  MyPlaylistModel.fromJson(Map<String, dynamic> json) {
    playlistName = json['playlistName'];

    if (json['shabadList'] != null) {
      shabadList = <ShabadData>[];
      json['shabadList'].forEach((v) {
        shabadList!.add(ShabadData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['playlistName'] = playlistName;
    data['shabadList'] = shabadList;
    return data;
  }

   String toJson2() => json.encode(toJson());

  factory MyPlaylistModel.fromJson2(String source) =>
      MyPlaylistModel.fromJson(json.decode(source));
}
