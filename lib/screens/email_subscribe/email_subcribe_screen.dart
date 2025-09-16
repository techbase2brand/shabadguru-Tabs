// Email subscription screen for "Shabad of the day" feature
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/email_subscribe/email_subscribe_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/image_app_bar.dart';

// Screen for user email subscription to receive daily Shabads
class EmailSubscribeScreen extends StatelessWidget {
  const EmailSubscribeScreen({super.key});

  // Build the email subscription screen UI
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailSubscrieController>(
      init: EmailSubscrieController(), // Initialize email controller
      builder: (controller) {
        final themeProvider = Provider.of<DarkThemeProvider>(context); // Get theme provider
        final screenWidth = MediaQuery.of(context).size.width; // Get screen width for responsive design
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black // Dark theme background
              : const Color.fromARGB(255, 239, 242, 248), // Light theme background
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageAppBar(
                onDrwaerTap: () {}, // Empty drawer tap function
                showDrawer: false, // Hide drawer button
                showBack: true, // Show back button
              ),
              Expanded(
                child: SingleChildScrollView( // Scrollable content
                  child: Padding(
                    padding: const EdgeInsets.all(30.0), // Add padding around content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Main title text
                        Text(
                          'Sign up for "Shabad of the day"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeProvider.darkTheme
                                ? Colors.white // White text for dark theme
                                : darkBlueColor, // Blue text for light theme
                            fontFamily: poppinsBold,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 15, // Spacing after title
                        ),
                        // Decorative line under title
                        Container(
                          width: 100,
                          height: 1.5,
                          color: secondPrimaryColor,
                        ),
                        const SizedBox(
                          height: 15, // Spacing after line
                        ),
                        // Description text explaining the feature
                        Text(
                          'Please enter your email address to sign up for a "Shabad of the Day". You will be able to listen a new shabad daily in the original raag in which it was composed while simultaneously seeing its translation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeProvider.darkTheme
                                ? Colors.white // White text for dark theme
                                : darkBlueColor, // Blue text for light theme
                            fontFamily: poppinsRegular,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 60, // Large spacing before email input
                        ),
                        // Email input field with responsive width
                        SizedBox(
                          width: screenWidth > 800
                              ? 300.00 // Fixed width for large screens
                              : screenWidth / 1.2, // Responsive width for smaller screens
                          child: Form(
                            key: controller.formKey, // Form validation key
                            child: TextFormField(
                              controller: controller.emailController, // Email input controller
                              style: TextStyle(
                                  fontFamily: poppinsRegular,
                                  color: themeProvider.darkTheme
                                      ? Colors.white // White text for dark theme
                                      : Colors.black), // Black text for light theme
                              cursorColor: themeProvider.darkTheme
                                  ? Colors.white // White cursor for dark theme
                                  : const Color(0XFF24163A), // Dark cursor for light theme
                              // Email validation function
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter email'; // Empty email error
                                }
                                // Email format validation using regex
                                final bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'Please enter valid email'; // Invalid email format error
                                }
                                return null; // Valid email
                              },
                              // Input field decoration and styling
                              decoration: InputDecoration(
                                label: Text(
                                  'Enter your email',
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
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeProvider.darkTheme
                                        ? Colors.white // White border for dark theme
                                        : const Color(0XFF24163A), // Dark border for light theme
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60, // Spacing before button
                        ),
                        // Show loading indicator or subscribe button
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth > 800
                                    ? 300.00 // Fixed width for large screens
                                    : screenWidth / 1.2, // Responsive width for smaller screens
                                child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus(); // Hide keyboard
                                    controller.subscribeEmail(); // Call subscription function
                                  },
                                  // Button styling with theme support
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        themeProvider.darkTheme
                                            ? Colors.white // White background for dark theme
                                            : const Color(0XFF24163A)), // Dark background for light theme
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15), // Rounded corners
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0), // Vertical padding
                                    child: Text(
                                      'Subscribe',
                                      style: TextStyle(
                                        color: themeProvider.darkTheme
                                            ? Colors.black // Black text for dark theme
                                            : Colors.white, // White text for light theme
                                        fontFamily: poppinsExtraBold,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
