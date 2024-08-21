// ignore_for_file: equal_elements_in_set

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/the_kirtanis/the_kirtanis_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';

class TheKirtanisScreen extends StatelessWidget {
  const TheKirtanisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    double appBarHeight;
    if (screenWidth > 600) {
      // Example breakpoint for tablets
      appBarHeight = 99;
    } else {
      appBarHeight = widthOfScreen * 0.15;
    }
    return GetBuilder<TheKirtanisController>(
        init: TheKirtanisController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeProvider.darkTheme
                ? Colors.black
                : const Color.fromARGB(255, 239, 242, 248),
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: appBarHeight,
              backgroundColor:
                  themeProvider.darkTheme ? Colors.black : darkBlueColor,
              title: const Text(
                'The Kirtanis',
                style: TextStyle(color: Colors.white),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            body: controller.list.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: themeProvider.darkTheme
                          ? Colors.white
                          : darkBlueColor,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'The Kirtanis',
                          style: TextStyle(
                              fontFamily: poppinsBold,
                              fontSize: 22,
                              color: themeProvider.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 100,
                          height: 1.5,
                          color: secondPrimaryColor,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'The Kirtan on this website has been sung by the students of Baru Sahib (Kalgidhar Society). These young students have been trained in Raags by dozens of accomplished Professors of Raagas (Music).Anahad BaniwithTantiSaaz has been undertaken by these students for the first time in the history of Sikh television. It is a mesmerizing Raag Aadharit rendition of the complete Guru Granth Sahib Ji. All the Kirtan you hear on this website is the audio files of the Kirtan they sung on television. More information on the Kalgidhar Society is available on https://barusahib.org/. You can also see the Baru Sahib students doing Kirtan on the youtube link below.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: poppinsMedium,
                                fontSize: 15,
                                height: 1.4,
                                color: themeProvider.darkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: 100,
                          height: 1.5,
                          color: secondPrimaryColor,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Baru Sahib Kids doing Kirtan',
                          style: TextStyle(
                              fontFamily: poppinsBold,
                              fontSize: 22,
                              color: themeProvider.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 100,
                          height: 1.5,
                          color: secondPrimaryColor,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AnimationLimiter(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.list.length,
                            padding: const EdgeInsets.only(top: 0),
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 1000),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  duration: const Duration(milliseconds: 1000),
                                  child: FadeInAnimation(
                                    child: Container(
                                      height: screenWidth > 600 ? 400 : 200,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      width: widthOfScreen,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          fit: screenWidth > 600
                                              ? BoxFit.cover
                                              : BoxFit.cover,
                                          image: NetworkImage(
                                            controller.list[index].url,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
