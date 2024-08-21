import 'dart:convert';

import 'package:shabadguru/network_service/models/shabad_raag_model.dart';

class MyPlaylistModel {
  String? playlistName;
  List<ShabadData>? shabadList;
  bool isSelected = false;
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
