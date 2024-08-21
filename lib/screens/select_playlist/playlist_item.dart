import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/my_playlist_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'dart:math' as math;

import 'package:shabadguru/utils/font.dart';

class PlayListItem extends StatelessWidget {
  const PlayListItem(
      {super.key,
      required this.onMenuTaped,
      required this.myPlaylistModel,
      required this.isSelectedPlaylist});

  final Function onMenuTaped;
  final MyPlaylistModel myPlaylistModel;
  final bool isSelectedPlaylist;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
      color: themeProvider.darkTheme
          ? Colors.black
          : const Color.fromARGB(255, 239, 242, 248),
      child: Column(
        children: [
          Row(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: themeProvider.darkTheme
                    ? Colors.blueGrey.shade900
                    : Colors.white,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      myPlaylistModel.playlistName?[0]
                              .toString()
                              .capitalizeFirst ??
                          'S',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: poppinsExtraBold,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myPlaylistModel.playlistName.toString().capitalizeFirst ??
                          '',
                      style: TextStyle(
                        color: themeProvider.darkTheme
                            ? Colors.white
                            : Colors.black,
                        fontFamily: poppinsExtraBold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${myPlaylistModel.shabadList!.length} ${myPlaylistModel.shabadList!.length > 1 ? "Shabads" : "Shabad"}',
                      style: TextStyle(
                        color: themeProvider.darkTheme
                            ? Colors.white
                            : Colors.black,
                        fontFamily: poppinsMedium,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                activeColor: secondPrimaryColor,
                value: isSelectedPlaylist,
                onChanged: (value) {
                  onMenuTaped();
                },
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
