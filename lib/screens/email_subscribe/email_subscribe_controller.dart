import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/utils/colors.dart';

class EmailSubscrieController extends GetxController {
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ApiRepository apiRepository = ApiRepository();
  bool showLoading = false;

  Future<void> subscribeEmail() async {
    if (formKey.currentState!.validate()) {
      showLoading = true;
      update();
      final body = jsonEncode({
        'email': emailController.text,
      });
      await apiRepository.emailSubscribe(body);
      emailController.clear();
      showLoading = false;
      Fluttertoast.showToast(
        msg: "Email subscribed successfully",
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
}
