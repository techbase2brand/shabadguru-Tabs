import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/screens/email_subscribe/email_subscribe_controller.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/image_app_bar.dart';

class EmailSubscribeScreen extends StatelessWidget {
  const EmailSubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailSubscrieController>(
      init: EmailSubscrieController(),
      builder: (controller) {
        final themeProvider = Provider.of<DarkThemeProvider>(context);
        final screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
          backgroundColor: themeProvider.darkTheme
              ? Colors.black
              : const Color.fromARGB(255, 239, 242, 248),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageAppBar(
                onDrwaerTap: () {},
                showDrawer: false,
                showBack: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Sign up for "Shabad of the day"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeProvider.darkTheme
                                ? Colors.white
                                : darkBlueColor,
                            fontFamily: poppinsBold,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 100,
                          height: 1.5,
                          color: secondPrimaryColor,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Please enter your email address to sign up for a "Shabad of the Day". You will be able to listen a new shabad daily in the original raag in which it was composed while simultaneously seeing its translation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeProvider.darkTheme
                                ? Colors.white
                                : darkBlueColor,
                            fontFamily: poppinsRegular,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        SizedBox(
                          width: screenWidth > 800
                              ? 300.00
                              : screenWidth / 1.2, // Desired width
                          child: Form(
                            key: controller.formKey,
                            child: TextFormField(
                              controller: controller.emailController,
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
                                  return 'Please enter email';
                                }
                                final bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: Text(
                                  'Enter your email',
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
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth > 800
                                    ? 300.00
                                    : screenWidth / 1.2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    controller.subscribeEmail();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        themeProvider.darkTheme
                                            ? Colors.white
                                            : const Color(0XFF24163A)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Text(
                                      'Subscribe',
                                      style: TextStyle(
                                        color: themeProvider.darkTheme
                                            ? Colors.black
                                            : Colors.white,
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
