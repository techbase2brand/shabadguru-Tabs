// Controller for managing contact us form functionality
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/utils/colors.dart';

// Controller class for managing contact us form state and API calls
class ContactUsController extends GetxController {
  // Text controllers for form fields
  TextEditingController firstNameController = TextEditingController(); // First name input
  TextEditingController lastNameController = TextEditingController(); // Last name input
  TextEditingController emailController = TextEditingController(); // Email input
  TextEditingController messageController = TextEditingController(); // Message input

  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Form validation key
  final GlobalKey<ScaffoldState> keyScaffold = GlobalKey(); // Scaffold key for drawer

  bool showLoading = false; // Loading state indicator
  ApiRepository apiRepository = ApiRepository(); // API service for contact us

  // Send contact message to server
  sendMessage() async {
    if (formKey.currentState!.validate()) { // Validate form before sending
      showLoading = true; // Show loading indicator
      update(); // Update UI
      // Prepare JSON body for API call
      final body = jsonEncode({
        'firstname': firstNameController.text, // First name
        'lastname': lastNameController.text, // Last name
        'email': emailController.text, // Email address
        'subject': messageController.text, // Message content
      });
      await apiRepository.contactUs(body); // Send message via API
      // Clear all form fields after successful submission
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      messageController.clear();
      showLoading = false; // Hide loading indicator
      // Show success message
      Fluttertoast.showToast(
        msg: "Your message is sent sucessfully",
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

  // Clean up resources when controller is disposed
  @override
  void dispose() {
    super.dispose();
    // Dispose all text controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    messageController.dispose();
  }
}
