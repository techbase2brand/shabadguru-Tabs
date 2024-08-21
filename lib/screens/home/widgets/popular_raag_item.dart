import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/network_service/models/popular_raags_model.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'dart:math' as math;

class PopularRaagItem extends StatelessWidget {
  const PopularRaagItem({super.key, required this.raagData});

  final RaagData raagData;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 0.4,
      color: themeProvider.darkTheme ? Colors.blueGrey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            width:
                screenWidth > 600 ? widthOfScreen * 0.11 : widthOfScreen * 0.15,
            decoration: BoxDecoration(
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Builder(builder: (context) {
                String name = getShortNameOfRaag(raagData.name.toString());
                return Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: poppinsExtraBold,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                raagData.name ?? '',
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: poppinsRegular,
                    color:
                        themeProvider.darkTheme ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
