import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

class UpNextItem extends StatelessWidget {
  const UpNextItem(
      {super.key,
      required this.shabadData,
      required this.isPlaying, required this.onMenuTaped});

  final ShabadData shabadData;
  final bool isPlaying;
  final Function onMenuTaped;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Card(
        elevation: 2,
        color: themeProvider.darkTheme?Colors.black:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: widthOfScreen,
          height: 70,
          decoration: BoxDecoration(
            color: isPlaying ? const Color(0XFFFFF8EA) : themeProvider.darkTheme?Colors.blueGrey.shade900: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              if (isPlaying)
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: secondPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pause,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color:themeProvider.darkTheme?Colors.black: Colors.white,
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 1.5, color:themeProvider.darkTheme?Colors.white: Colors.grey.shade400),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color:themeProvider.darkTheme?Colors.white: Colors.grey.shade400,
                    ),
                  ),
                ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shabadData.song ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: poppinsRegular,
                          color:
                              isPlaying ? secondPrimaryColor :  themeProvider.darkTheme?Colors.white: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  onMenuTaped();
                },
                icon: Icon(
                  Icons.more_vert_outlined,
                  color:isPlaying?Colors.black: themeProvider.darkTheme ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
