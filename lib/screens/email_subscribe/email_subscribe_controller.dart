// Controller for managing email subscription functionality
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/utils/colors.dart';

// Controller class for managing email subscription form and API calls
class EmailSubscrieController extends GetxController {
  TextEditingController emailController = TextEditingController(); // Email input controller

  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form validation key
  ApiRepository apiRepository = ApiRepository(); // API service for email subscription
  bool showLoading = false; // Loading state indicator

  // Subscribe email for daily Shabad notifications
  Future<void> subscribeEmail() async {
    if (formKey.currentState!.validate()) { // Validate form before sending
      showLoading = true; // Show loading indicator
      update(); // Update UI
      // Prepare JSON body for API call
      final body = jsonEncode({
        'email': emailController.text, // User's email address
      });
     print('Sending data: $body'); // Debug log

      await apiRepository.emailSubscribe(body); // Send subscription request via API
      emailController.clear(); // Clear email field after successful submission
      showLoading = false; // Hide loading indicator
      // Show success message
      Fluttertoast.showToast(
        msg: "Email subscribed successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: darkBlueColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      update(); // Update UI
    }
  }
}
