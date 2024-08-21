// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/contact_us/contact_us_controller.dart';
import 'package:shabadguru/screens/home/widgets/side_drawer.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/global.dart';
import 'package:shabadguru/utils/image_app_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ContactUsController>(
      init: ContactUsController(),
      builder: (controller) {
        return Scaffold(
          key: controller.keyScaffold,
          drawer: const SideDrawer(),
          backgroundColor: themeProvider.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          body: Column(
            children: [
              ImageAppBar(
                onDrwaerTap: () {
                  controller.keyScaffold.currentState!.openDrawer();
                },
                showDrawer: true,
                showBack: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Get In Touch With Us!',
                        style: TextStyle(
                          fontFamily: poppinsRegular,
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                          color: themeProvider.darkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "We’re here to assist you, How can we be of help?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: poppinsRegular,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: themeProvider.darkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Form(
                      //     key: controller.formKey,
                      //     child: Column(
                      //       children: [
                      //         TextFormField(
                      //           controller: controller.firstNameController,
                      //           style: TextStyle(
                      //               fontFamily: poppinsRegular,
                      //               color: themeProvider.darkTheme
                      //                   ? Colors.white
                      //                   : Colors.black),
                      //           cursorColor: themeProvider.darkTheme
                      //               ? Colors.white
                      //               : const Color(0XFF24163A),
                      //           validator: (value) {
                      //             if (value!.isEmpty) {
                      //               return 'Please enter first name';
                      //             }
                      //             if (value.length < 2) {
                      //               return 'Please enter valid first name';
                      //             }
                      //             return null;
                      //           },
                      //           decoration: InputDecoration(
                      //             label: Text(
                      //               'First name',
                      //               style: TextStyle(
                      //                 fontFamily: poppinsRegular,
                      //                 color: themeProvider.darkTheme
                      //                     ? Colors.white
                      //                     : Colors.black,
                      //               ),
                      //             ),
                      //             floatingLabelStyle: TextStyle(
                      //               color: const Color(0XFF24163A),
                      //               fontFamily: poppinsRegular,
                      //             ),
                      //             focusedBorder: UnderlineInputBorder(
                      //               borderSide: BorderSide(
                      //                 color: themeProvider.darkTheme
                      //                     ? Colors.white
                      //                     : const Color(0XFF24163A),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 30,
                      //         ),
                      //         TextFormField(
                      //           controller: controller.lastNameController,
                      //           style: TextStyle(
                      //               fontFamily: poppinsRegular,
                      //               color: themeProvider.darkTheme
                      //                   ? Colors.white
                      //                   : Colors.black),
                      //           cursorColor: themeProvider.darkTheme
                      //               ? Colors.white
                      //               : const Color(0XFF24163A),
                      //           validator: (value) {
                      //             if (value!.isEmpty) {
                      //               return 'Please enter last name';
                      //             }
                      //             if (value.length < 2) {
                      //               return 'Please enter valid last name';
                      //             }
                      //             return null;
                      //           },
                      //           decoration: InputDecoration(
                      //             label: Text(
                      //               'Last name',
                      //               style: TextStyle(
                      //                 fontFamily: poppinsRegular,
                      //                 color: themeProvider.darkTheme
                      //                     ? Colors.white
                      //                     : Colors.black,
                      //               ),
                      //             ),
                      //             floatingLabelStyle: TextStyle(
                      //               color: const Color(0XFF24163A),
                      //               fontFamily: poppinsRegular,
                      //             ),
                      //             focusedBorder: UnderlineInputBorder(
                      //               borderSide: BorderSide(
                      //                 color: themeProvider.darkTheme
                      //                     ? Colors.white
                      //                     : const Color(0XFF24163A),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 30,
                      //         ),
                      //         TextFormField(
                      //           controller: controller.emailController,
                      //           style: TextStyle(
                      //             fontFamily: poppinsRegular,
                      //             color: themeProvider.darkTheme
                      //                 ? Colors.white
                      //                 : Colors.black,
                      //           ),
                      //           cursorColor: themeProvider.darkTheme
                      //               ? Colors.white
                      //               : const Color(0XFF24163A),
                      //           validator: (value) {
                      //             if (value!.isEmpty) {
                      //               return 'Please enter email';
                      //             }
                      //             final bool emailValid = RegExp(
                      //                     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      //                 .hasMatch(value);
                      //             if (!emailValid) {
                      //               return 'Please enter valid email';
                      //             }
                      //             return null;
                      //           },
                      //           decoration: InputDecoration(
                      //             label: Text(
                      //               'Email',
                      //               style: TextStyle(
                      //                 fontFamily: poppinsRegular,
                      //                 color: themeProvider.darkTheme
                      //                     ? Colors.white
                      //                     : Colors.black,
                      //               ),
                      //             ),
                      //             floatingLabelStyle: TextStyle(
                      //               color: const Color(0XFF24163A),
                      //               fontFamily: poppinsRegular,
                      //             ),
                      //             focusedBorder: UnderlineInputBorder(
                      //               borderSide: BorderSide(
                      //                 color: themeProvider.darkTheme
                      //                     ? Colors.white
                      //                     : const Color(0XFF24163A),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 30,
                      //         ),
                      //         TextFormField(
                      //           controller: controller.messageController,
                      //           style: TextStyle(
                      //             fontFamily: poppinsRegular,
                      //             color: themeProvider.darkTheme
                      //                 ? Colors.white
                      //                 : Colors.black,
                      //           ),
                      //           cursorColor: themeProvider.darkTheme
                      //               ? Colors.white
                      //               : const Color(0XFF24163A),
                      //           validator: (value) {
                      //             if (value!.isEmpty) {
                      //               return 'Please enter message';
                      //             }
                      //             return null;
                      //           },
                      //           decoration: InputDecoration(
                      //             label: Text(
                      //               'Message',
                      //               style: TextStyle(
                      //                 fontFamily: poppinsRegular,
                      //                 color: themeProvider.darkTheme
                      //                     ? Colors.white
                      //                     : Colors.black,
                      //               ),
                      //             ),
                      //             floatingLabelStyle: TextStyle(
                      //               color: const Color(0XFF24163A),
                      //               fontFamily: poppinsRegular,
                      //             ),
                      //             focusedBorder: UnderlineInputBorder(
                      //               borderSide: BorderSide(
                      //                 color: themeProvider.darkTheme
                      //                     ? Colors.white
                      //                     : const Color(0XFF24163A),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 60,
                      //         ),
                      //         if (controller.showLoading)
                      //           Center(
                      //             child: CircularProgressIndicator(
                      //               color: themeProvider.darkTheme
                      //                   ? Colors.white
                      //                   : darkBlueColor,
                      //             ),
                      //           )
                      //         else
                      //           Row(
                      //             children: [
                      //               Expanded(
                      //                 child: ElevatedButton(
                      //                   onPressed: () {
                      //                     FocusScope.of(context).unfocus();
                      //                     controller.sendMessage();
                      //                   },
                      //                   style: ButtonStyle(
                      //                     backgroundColor: MaterialStateProperty
                      //                         .all(themeProvider.darkTheme
                      //                             ? Colors.white
                      //                             : const Color(0XFF24163A)),
                      //                     shape: MaterialStateProperty.all(
                      //                       RoundedRectangleBorder(
                      //                         borderRadius:
                      //                             BorderRadius.circular(15),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.symmetric(
                      //                         vertical: 15.0),
                      //                     child: Text(
                      //                       'Send',
                      //                       style: TextStyle(
                      //                         color: themeProvider.darkTheme
                      //                             ? Colors.black
                      //                             : Colors.white,
                      //                         fontFamily: poppinsExtraBold,
                      //                         fontSize: 16,
                      //                         fontWeight: FontWeight.w700,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         const SizedBox(
                      //           height: 30,
                      //         ),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             GestureDetector(
                      //               onTap: () {
                      //                 launchUrlString(
                      //                     'https://in.pinterest.com/shabadguruorg/',
                      //                     mode: LaunchMode.externalApplication);
                      //               },
                      //               child: Container(
                      //                 height: 50,
                      //                 width: 50,
                      //                 padding: const EdgeInsets.all(10),
                      //                 decoration: BoxDecoration(
                      //                   color: themeProvider.darkTheme
                      //                       ? Colors.white
                      //                       : darkBlueColor,
                      //                   borderRadius: BorderRadius.circular(5),
                      //                 ),
                      //                 child: SvgPicture.asset(
                      //                   pinterestSvg,
                      //                   color: themeProvider.darkTheme
                      //                       ? Colors.black
                      //                       : Colors.white,
                      //                 ),
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               width: 10,
                      //             ),
                      //             GestureDetector(
                      //               onTap: () {
                      //                 launchUrlString(
                      //                     'https://www.instagram.com/shabadguru_official/',
                      //                     mode: LaunchMode.externalApplication);
                      //               },
                      //               child: Container(
                      //                 height: 50,
                      //                 width: 50,
                      //                 padding: const EdgeInsets.all(10),
                      //                 decoration: BoxDecoration(
                      //                   color: themeProvider.darkTheme
                      //                       ? Colors.white
                      //                       : darkBlueColor,
                      //                   borderRadius: BorderRadius.circular(5),
                      //                 ),
                      //                 child: SvgPicture.asset(
                      //                   instagramSvg,
                      //                   color: themeProvider.darkTheme
                      //                       ? Colors.black
                      //                       : Colors.white,
                      //                 ),
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               width: 10,
                      //             ),
                      //             GestureDetector(
                      //               onTap: () {
                      //                 launchUrlString(
                      //                     'https://www.youtube.com/channel/UCdxMJWYl3N5nCB7dghN7GEA',
                      //                     mode: LaunchMode.externalApplication);
                      //               },
                      //               child: Container(
                      //                 height: 50,
                      //                 width: 50,
                      //                 padding: const EdgeInsets.all(5),
                      //                 decoration: BoxDecoration(
                      //                   color: themeProvider.darkTheme
                      //                       ? Colors.white
                      //                       : darkBlueColor,
                      //                   borderRadius: BorderRadius.circular(5),
                      //                 ),
                      //                 child: SvgPicture.asset(
                      //                   youtubeSvg,
                      //                   color: themeProvider.darkTheme
                      //                       ? Colors.black
                      //                       : Colors.white,
                      //                 ),
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               width: 10,
                      //             ),
                      //             GestureDetector(
                      //               onTap: () {
                      //                 launchUrlString(
                      //                     'https://www.facebook.com/shabadguruofficial',
                      //                     mode: LaunchMode.externalApplication);
                      //               },
                      //               child: Container(
                      //                 height: 50,
                      //                 width: 50,
                      //                 padding: const EdgeInsets.all(10),
                      //                 decoration: BoxDecoration(
                      //                   color: themeProvider.darkTheme
                      //                       ? Colors.white
                      //                       : darkBlueColor,
                      //                   borderRadius: BorderRadius.circular(5),
                      //                 ),
                      //                 child: SvgPicture.asset(
                      //                   facebookSvg,
                      //                   color: themeProvider.darkTheme
                      //                       ? Colors.black
                      //                       : Colors.white,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         const SizedBox(
                      //           height: 80,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth > 800 ? 100 : 20),
                        child: Form(
                          key: controller.formKey,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth > 800) {
                                // Adjust the width threshold as needed
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.firstNameController,
                                            style: TextStyle(
                                                fontFamily: poppinsRegular,
                                                color: themeProvider.darkTheme
                                                    ? Colors.white
                                                    : Colors.black),
                                            cursorColor: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter first name';
                                              }
                                              if (value.length < 2) {
                                                return 'Please enter valid first name';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              label: Text(
                                                'First name',
                                                style: TextStyle(
                                                  fontFamily: poppinsRegular,
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              floatingLabelStyle: TextStyle(
                                                color: const Color(0XFF24163A),
                                                fontFamily: poppinsRegular,
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white
                                                      : const Color(0XFF24163A),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 100),
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.lastNameController,
                                            style: TextStyle(
                                                fontFamily: poppinsRegular,
                                                color: themeProvider.darkTheme
                                                    ? Colors.white
                                                    : Colors.black),
                                            cursorColor: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter last name';
                                              }
                                              if (value.length < 2) {
                                                return 'Please enter valid last name';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              label: Text(
                                                'Last name',
                                                style: TextStyle(
                                                  fontFamily: poppinsRegular,
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              floatingLabelStyle: TextStyle(
                                                color: const Color(0XFF24163A),
                                                fontFamily: poppinsRegular,
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white
                                                      : const Color(0XFF24163A),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.emailController,
                                            style: TextStyle(
                                              fontFamily: poppinsRegular,
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            cursorColor: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter email';
                                              }
                                              final bool emailValid = RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(value);
                                              if (!emailValid) {
                                                return 'Please enter valid email';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              label: Text(
                                                'Email',
                                                style: TextStyle(
                                                  fontFamily: poppinsRegular,
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              floatingLabelStyle: TextStyle(
                                                color: const Color(0XFF24163A),
                                                fontFamily: poppinsRegular,
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white
                                                      : const Color(0XFF24163A),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 100),
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.messageController,
                                            style: TextStyle(
                                              fontFamily: poppinsRegular,
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            cursorColor: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter message';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              label: Text(
                                                'Message',
                                                style: TextStyle(
                                                  fontFamily: poppinsRegular,
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              floatingLabelStyle: TextStyle(
                                                color: const Color(0XFF24163A),
                                                fontFamily: poppinsRegular,
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white
                                                      : const Color(0XFF24163A),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 60),
                                    if (controller.showLoading)
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: themeProvider.darkTheme
                                              ? Colors.white
                                              : darkBlueColor,
                                        ),
                                      )
                                    else
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 400.00,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                controller.sendMessage();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  themeProvider.darkTheme
                                                      ? Colors.white
                                                      : const Color(0XFF24163A),
                                                ),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0),
                                                child: Text(
                                                  'Send',
                                                  style: TextStyle(
                                                    color:
                                                        themeProvider.darkTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontFamily:
                                                        poppinsExtraBold,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString(
                                                'https://in.pinterest.com/shabadguruorg/',
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : darkBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              pinterestSvg,
                                              color: themeProvider.darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString(
                                                'https://www.instagram.com/shabadguru_official/',
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : darkBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              instagramSvg,
                                              color: themeProvider.darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString(
                                                'https://www.youtube.com/channel/UCdxMJWYl3N5nCB7dghN7GEA',
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : darkBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              youtubeSvg,
                                              color: themeProvider.darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString(
                                                'https://www.facebook.com/shabadguruofficial',
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : darkBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              facebookSvg,
                                              color: themeProvider.darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    TextFormField(
                                      controller:
                                          controller.firstNameController,
                                      style: TextStyle(
                                          fontFamily: poppinsRegular,
                                          color: themeProvider.darkTheme
                                              ? Colors.white
                                              : Colors.black),
                                      cursorColor: themeProvider.darkTheme
                                          ? Colors.white
                                          : const Color(0XFF24163A),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter first name';
                                        }
                                        if (value.length < 2) {
                                          return 'Please enter valid first name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'First name',
                                          style: TextStyle(
                                            fontFamily: poppinsRegular,
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        floatingLabelStyle: TextStyle(
                                          color: const Color(0XFF24163A),
                                          fontFamily: poppinsRegular,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: controller.lastNameController,
                                      style: TextStyle(
                                          fontFamily: poppinsRegular,
                                          color: themeProvider.darkTheme
                                              ? Colors.white
                                              : Colors.black),
                                      cursorColor: themeProvider.darkTheme
                                          ? Colors.white
                                          : const Color(0XFF24163A),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter last name';
                                        }
                                        if (value.length < 2) {
                                          return 'Please enter valid last name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Last name',
                                          style: TextStyle(
                                            fontFamily: poppinsRegular,
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        floatingLabelStyle: TextStyle(
                                          color: const Color(0XFF24163A),
                                          fontFamily: poppinsRegular,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: controller.emailController,
                                      style: TextStyle(
                                        fontFamily: poppinsRegular,
                                        color: themeProvider.darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      cursorColor: themeProvider.darkTheme
                                          ? Colors.white
                                          : const Color(0XFF24163A),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter email';
                                        }
                                        final bool emailValid = RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value);
                                        if (!emailValid) {
                                          return 'Please enter valid email';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Email',
                                          style: TextStyle(
                                            fontFamily: poppinsRegular,
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        floatingLabelStyle: TextStyle(
                                          color: const Color(0XFF24163A),
                                          fontFamily: poppinsRegular,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: controller.messageController,
                                      style: TextStyle(
                                        fontFamily: poppinsRegular,
                                        color: themeProvider.darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      cursorColor: themeProvider.darkTheme
                                          ? Colors.white
                                          : const Color(0XFF24163A),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter message';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: Text(
                                          'Message',
                                          style: TextStyle(
                                            fontFamily: poppinsRegular,
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        floatingLabelStyle: TextStyle(
                                          color: const Color(0XFF24163A),
                                          fontFamily: poppinsRegular,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 60),
                                    if (controller.showLoading)
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: themeProvider.darkTheme
                                              ? Colors.white
                                              : darkBlueColor,
                                        ),
                                      )
                                    else
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                controller.sendMessage();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  themeProvider.darkTheme
                                                      ? Colors.white
                                                      : const Color(0XFF24163A),
                                                ),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0),
                                                child: Text(
                                                  'Send',
                                                  style: TextStyle(
                                                    color:
                                                        themeProvider.darkTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontFamily:
                                                        poppinsExtraBold,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString(
                                                'https://in.pinterest.com/shabadguruorg/',
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : darkBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              pinterestSvg,
                                              color: themeProvider.darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString(
                                                'https://www.instagram.com/shabadguru_official/',
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : darkBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              instagramSvg,
                                              color: themeProvider.darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString(
                                                'https://www.youtube.com/channel/UCdxMJWYl3N5nCB7dghN7GEA',
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : darkBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              youtubeSvg,
                                              color: themeProvider.darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString(
                                                'https://www.facebook.com/shabadguruofficial',
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : darkBlueColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                              facebookSvg,
                                              color: themeProvider.darkTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
