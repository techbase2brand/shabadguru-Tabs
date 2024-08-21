import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

class SelectShabadItem extends StatelessWidget {
  const SelectShabadItem(
      {super.key,
      required this.shabadData,
      required this.isSelectedForPlaylist});

  final ShabadData shabadData;
  final Function() isSelectedForPlaylist;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        isSelectedForPlaylist();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: Card(
          elevation: 0.4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color:
              themeProvider.darkTheme ? Colors.blueGrey.shade900 : Colors.white,
          child: Container(
            width: widthOfScreen,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color:
                        themeProvider.darkTheme ? Colors.black : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1.5,
                        color: themeProvider.darkTheme
                            ? Colors.white
                            : Colors.grey.shade400),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: themeProvider.darkTheme
                          ? Colors.white
                          : Colors.grey.shade400,
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
                            color: themeProvider.darkTheme
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  activeColor: secondPrimaryColor,
                  value: shabadData.isSelectedForPlaylist,
                  onChanged: (value) {
                    isSelectedForPlaylist();
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
