import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

class RecentItem extends StatelessWidget {
  const RecentItem({
    super.key,
    required this.index,
    required this.recentListShabad,
    required this.shabadData,
  });

  final int index;
  final List<ShabadData> recentListShabad;
  final ShabadData shabadData;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return Container(
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
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(1.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Builder(builder: (context) {
                      //   String name = '';
                      //  if(shabadData.title == null || shabadData.title.isEmpty){
                      //   name = 'G';
                      //  }else
                      //   if (shabadData.title!.toString().contains("Japji Sahib")) {
                      //     name = 'J';
                      //   } else if (shabadData.title!.toString().contains("Aasa Di Vaar")) {
                      //     name = 'A';
                      //   } else if (shabadData.title!.toString().trim() == "Anand Sahib") {
                      //     name = 'A';
                      //   }else if (shabadData.title!.toString().contains("Phuney - Mehla 5")) {
                      //     name = 'P';
                      //   } else if (shabadData.title!.toString().contains("Chauboley - Mehla 5")) {
                      //     name = 'C';
                      //   } else if (shabadData.title!
                      //       .toString()
                      //       .contains("Mehla 5")) {
                      //     name = 'M';
                      //   } else if (shabadData.title!.toString().trim() ==
                      //       "Laavan") {
                      //     name = 'L';
                      //   } else if (shabadData.title!.toString().contains(" ")) {
                      //     List<String> listOfBanis =
                      //         shabadData.title!.toString().split(" ");
                      //     if (listOfBanis.length > 1) {
                      //       name = listOfBanis[1][0];
                      //     } else {
                      //       name = listOfBanis[0][0];
                      //     }
                      //   } else {
                      //     name = shabadData.title!.toString()[0];
                      //   }
                      String name =
                          getShortNameOfRaag(shabadData.title!.toString());
                      return Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: poppinsExtraBold,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    }),
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
                      shabadData.title.isEmpty
                          ? "Raag Gauri"
                          : shabadData.title ?? 'Raag Gauri',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: poppinsRegular,
                          color: themeProvider.darkTheme
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      shabadData.song ?? '',
                      maxLines: 1,
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
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.play_arrow_rounded,
                color: themeProvider.darkTheme ? Colors.white : Colors.black,
                size: 40,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
