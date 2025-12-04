// ignore_for_file: deprecated_member_use

// Contact us screen for user support and social media links
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
import 'package:shabadguru/utils/image_app_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Screen for displaying contact information and social media links
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // Build the contact us screen UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive design
    return GetBuilder<ContactUsController>(
      init: ContactUsController(), // Initialize contact us controller
      builder: (controller) {
        return Scaffold(
          key: controller.keyScaffold, // Scaffold key for drawer control
          drawer: const SideDrawer(), // Side navigation drawer
          backgroundColor: themeProvider.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          body: Column(
            children: [
              // App bar with drawer functionality
              ImageAppBar(
                onDrwaerTap: () {
                  controller.keyScaffold.currentState!.openDrawer(); // Open drawer on tap
                },
                showDrawer: true, // Show drawer button
                showBack: false, // Hide back button
              ),
              Expanded(
                child: SingleChildScrollView( // Scrollable content
                  physics: const BouncingScrollPhysics(), // Bouncing scroll effect
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50, // Top spacing
                      ),
                      // Main title text
                      Text(
                        'Get In Touch With Us!',
                        style: TextStyle(
                          fontFamily: poppinsRegular,
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                          color: themeProvider.darkTheme
                              ? Colors.white // White text for dark theme
                              : Colors.black, // Black text for light theme
                        ),
                      ),
                      const SizedBox(
                        height: 10, // Spacing after title
                      ),
                      // Subtitle text
                      Text(
                        "We're here to assist you, How can we be of help?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: poppinsRegular,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: themeProvider.darkTheme
                              ? Colors.white // White text for dark theme
                              : Colors.black, // Black text for light theme
                        ),
                      ),
                      const SizedBox(
                        height: 30, // Spacing before form
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
                      // Contact form with responsive padding
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth > 800 ? 100 : 20), // Responsive horizontal padding
                        child: Form(
                          key: controller.formKey, // Form validation key
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth > 800) {
                                // Desktop/tablet layout
                                return Column(
                                  children: [
                                    // First name and last name row for desktop
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.firstNameController, // First name controller
                                            style: TextStyle(
                                                fontFamily: poppinsRegular,
                                                color: themeProvider.darkTheme
                                                    ? Colors.white // White text for dark theme
                                                    : Colors.black), // Black text for light theme
                                            cursorColor: themeProvider.darkTheme
                                                ? Colors.white // White cursor for dark theme
                                                : const Color(0XFF24163A), // Dark cursor for light theme
                                            // First name validation
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter first name'; // Empty field error
                                              }
                                              if (value.length < 2) {
                                                return 'Please enter valid first name'; // Too short error
                                              }
                                              return null; // Valid input
                                            },
                                            // First name input decoration
                                            decoration: InputDecoration(
                                              label: Text(
                                                'First name',
                                                style: TextStyle(
                                                  fontFamily: poppinsRegular,
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white // White label for dark theme
                                                      : Colors.black, // Black label for light theme
                                                ),
                                              ),
                                              floatingLabelStyle: TextStyle(
                                                color: const Color(0XFF24163A), // Floating label color
                                                fontFamily: poppinsRegular,
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: themeProvider.darkTheme
                                                      ? Colors.white // White border for dark theme
                                                      : const Color(0XFF24163A), // Dark border for light theme
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 100), // Spacing between first and last name
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.lastNameController, // Last name controller
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
                                    const SizedBox(height: 30), // Spacing after name fields
                                    // Email field row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.emailController, // Email controller
                                            style: TextStyle(
                                              fontFamily: poppinsRegular,
                                              color: themeProvider.darkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            cursorColor: themeProvider.darkTheme
                                                ? Colors.white
                                                : const Color(0XFF24163A),
                                            // Email validation
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter email'; // Empty email error
                                              }
                                              // Email format validation using regex
                                              final bool emailValid = RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(value);
                                              if (!emailValid) {
                                                return 'Please enter valid email'; // Invalid email format error
                                              }
                                              return null; // Valid email
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
                                        const SizedBox(width: 100), // Spacing between email and message
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.messageController, // Message controller
                                            style: TextStyle(
                                              fontFamily: poppinsRegular,
                                              color: themeProvider.darkTheme
                                                  ? Colors.white // White text for dark theme
                                                  : Colors.black, // Black text for light theme
                                            ),
                                            cursorColor: themeProvider.darkTheme
                                                ? Colors.white // White cursor for dark theme
                                                : const Color(0XFF24163A), // Dark cursor for light theme
                                            // Message validation
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter message'; // Empty message error
                                              }
                                              return null; // Valid message
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
                                    const SizedBox(height: 60), // Spacing before submit button
                                    // Show loading indicator or submit button
                                    if (controller.showLoading)
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: themeProvider.darkTheme
                                              ? Colors.white // White loading indicator for dark theme
                                              : darkBlueColor, // Blue loading indicator for light theme
                                        ),
                                      )
                                    else
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 400.00, // Fixed width for desktop
                                            child: ElevatedButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus(); // Hide keyboard
                                                controller.sendMessage(); // Send message
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
