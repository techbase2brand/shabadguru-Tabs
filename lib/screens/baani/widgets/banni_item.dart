import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/popular_raags_model.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'dart:math' as math;

class BanniItem extends StatelessWidget {
  const BanniItem({super.key, required this.banniData});

  final RaagData? banniData;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Card(
        elevation: 0.4,
        color:
            themeProvider.darkTheme ? Colors.blueGrey.shade900 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
                  color: themeProvider.darkTheme ? Colors.black : Colors.white,
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
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                    child: Builder(builder: (context) {
                      // String name = '';
                      String name =
                          getShortNameOfRaag(banniData!.name.toString());
                      //   if (banniData!.name.toString().contains("Japji Sahib")) {
                      //   name = 'J';
                      // } else if (banniData!.name.toString().contains("Aasa Di Vaar")) {
                      //   name = 'A';
                      // } else if (banniData!.name.toString().trim() == "Anand Sahib") {
                      //   name = 'A';
                      // }else if (banniData!.name.toString().contains("Phuney - Mehla 5")) {
                      //   name = 'P';
                      // } else if (banniData!.name.toString().contains("Chauboley - Mehla 5")) {
                      //   name = 'C';
                      // } else
                      //   if(banniData!.name.toString().contains("Gatha")){
                      //     name = 'G';
                      //   }else if(banniData!.name.toString().contains("Mehla 5")){
                      //     name = 'M';
                      //   }else
                      //   if(banniData!.name.toString().trim() == "Laavan"){
                      //     name = 'L';
                      //   }else if(banniData!.name.toString().contains(" ")){
                      //     List<String> listOfBanis = banniData!.name.toString().split(" ");
                      //     if(listOfBanis.length>1){
                      //       name = listOfBanis[1][0];
                      //     }else{
                      //       name = listOfBanis[0][0];
                      //     }
                      //   }else{
                      //     name = banniData!.name.toString()[0];
                      //   }
                      return Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: poppinsExtraBold,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
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
                      banniData!.name ?? '',
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
