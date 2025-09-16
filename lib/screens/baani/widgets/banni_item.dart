// Widget for displaying individual Bani item in the list
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/popular_raags_model.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'dart:math' as math;

// Widget for displaying a single Bani item with play button and colored icon
class BanniItem extends StatelessWidget {
  const BanniItem({super.key, required this.banniData});

  final RaagData? banniData; // Bani data model

  // Build the Bani item widget UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10), // Container margins
      child: Card(
        elevation: 0.4, // Card shadow elevation
        color:
            themeProvider.darkTheme ? Colors.blueGrey.shade900 : Colors.white, // Card background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Container(
          width: widthOfScreen, // Full screen width
          height: 70, // Fixed height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10, // Left spacing
              ),
              // Play button container
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: themeProvider.darkTheme ? Colors.black : Colors.white, // Button background
                  shape: BoxShape.circle, // Circular shape
                  border: Border.all(
                      width: 1.5,
                      color: themeProvider.darkTheme
                          ? Colors.white // White border for dark theme
                          : Colors.grey.shade400), // Grey border for light theme
                ),
                child: Center(
                  child: Icon(
                    Icons.play_arrow, // Play arrow icon
                    color: themeProvider.darkTheme
                        ? Colors.white // White icon for dark theme
                        : Colors.grey.shade400, // Grey icon for light theme
                  ),
                ),
              ),
              const SizedBox(
                width: 10, // Spacing between play button and colored icon
              ),
              // Colored icon card with Bani initial
              Card(
                elevation: 2, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()) // Random color generation
                            .withOpacity(1.0),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Center(
                    child: Builder(builder: (context) {
                      // Get short name for Bani initial
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
                        name, // Display Bani initial
                        style: TextStyle(
                          color: Colors.white, // White text on colored background
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
                width: 10, // Spacing between icon and text
              ),
              // Bani name text section
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banniData!.name ?? '', // Bani name
                      maxLines: 2, // Maximum 2 lines
                      overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                      style: TextStyle(
                          fontFamily: poppinsRegular,
                          color: themeProvider.darkTheme
                              ? Colors.white // White text for dark theme
                              : Colors.black, // Black text for light theme
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10, // Right spacing
              ),
            ],
          ),
        ),
      ),
    );
  }
}
