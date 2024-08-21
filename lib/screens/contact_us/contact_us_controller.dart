import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/utils/colors.dart';

class ContactUsController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> keyScaffold = GlobalKey();

  bool showLoading = false;
  ApiRepository apiRepository = ApiRepository();

  sendMessage() async {
    if (formKey.currentState!.validate()) {
      showLoading = true;
      update();
      final body = jsonEncode({
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'email': emailController.text,
        'subject': messageController.text,
      });
      await apiRepository.contactUs(body);
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      messageController.clear();
      showLoading = false;
      Fluttertoast.showToast(
        msg: "Your message is sent sucessfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: darkBlueColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      update();
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    messageController.dispose();
  }
}
