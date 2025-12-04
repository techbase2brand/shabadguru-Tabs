// ignore_for_file: use_build_context_synchronously

// Controller for managing Shabad data, favorites, and menu options
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:shabadguru/utils/shared_pref.dart';

// Controller class for managing Shabad operations and state
class ShabadController extends GetxController {
  // Constructor with required parameters for Shabad identification
  ShabadController(
      {required this.categoryId, required this.id, required this.title});
  ApiRepository apiRepository = ApiRepository(); // API service for data fetching
  ShabadRaagModel? shabadRaagModel; // Model to store Shabad data

  String categoryId = ''; // Category identifier for the Shabad
  String id = ''; // Unique identifier for the Shabad
  final String title; // Title of the Shabad

  // Initialize controller and load Shabad data
  @override
  void onInit() {
    super.onInit();
    // getShabad(); // Commented out - using local JSON instead
    readJson(); // Load Shabad data from local JSON file
  }

  // Alternative method to fetch Shabad from API (currently commented out)
  // void getShabad() {
  //   apiRepository.getShabad(categoryId,id).then((value) {
  //     if (value.error == null) {
  //       shabadRaagModel = value;
  //       update();
  //     }
  //   });
  // }

  // Load Shabad data from local JSON file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/raags_shabad/shabad$id.json'); // Load JSON file
    final data = await json.decode(response); // Parse JSON data
    shabadRaagModel = ShabadRaagModel.fromJson(data); // Convert to model
    update(); // Update UI
  }

  // Show bottom sheet menu with options for Shabad
  Future<void> showMenuOptions(
    context,
    ShabadData shabadData,
  ) async {
    final myFavoriteListShabad = await SharedPref.getMyFavoriteList(); // Get favorite list
    bool isFindShabad = false; // Check if Shabad is already in favorites
    for (var i = 0; i < myFavoriteListShabad.length; i++) {
      if (myFavoriteListShabad[i].audio == shabadData.audio) {
        isFindShabad = true; // Shabad found in favorites
        break;
      }
    }
    // Display bottom sheet with menu options
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      constraints: const BoxConstraints(
        maxWidth: double.infinity, // Full width constraint
      ),
      useRootNavigator: false,
      builder: (context) {
        return Container(
          height: audioHandler != null ? 320 : 260, // Dynamic height based on audio handler
          color: secondPrimaryColor.withOpacity(0), // Transparent background
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Container padding
          child: Column(
            children: [
              // Favorite toggle option
              GestureDetector(
                onTap: () async {
                  bool isFind = false; // Track if Shabad is in favorites
                  shabadData.title = title; // Set Shabad title
                  final myFavoriteList = await SharedPref.getMyFavoriteList(); // Get current favorites
                  if (myFavoriteList.isNotEmpty) {
                    // Check if Shabad already exists in favorites
                    for (var i = 0; i < myFavoriteList.length; i++) {
                      if (myFavoriteList[i].audio == shabadData.audio) {
                        isFind = true;
                        myFavoriteList.removeAt(i); // Remove from favorites
                        break;
                      }
                    }
                    if (!isFind) {
                      myFavoriteList.add(shabadData); // Add to favorites
                    }
                  } else {
                    myFavoriteList.add(shabadData); // Add to empty favorites list
                  }
                  await SharedPref.saveMyFavoriteList(myFavoriteList); // Save updated list
                  // Show success message
                  Fluttertoast.showToast(
                    msg: isFind
                        ? 'Shabad removed from your favorite'
                        : "Shabad added to your favorite",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: darkBlueColor,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.of(context).pop(); // Close bottom sheet
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding
                  color: secondPrimaryColor.withOpacity(0), // Transparent background
                  child: Row(
                    children: [
                      Icon(
                        isFindShabad ? Icons.favorite : Icons.favorite_border, // Dynamic favorite icon
                        color: secondPrimaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10, // Spacing between icon and text
                      ),
                      Text(
                        isFindShabad
                            ? 'Remove from favorite' // Remove text if already favorite
                            : 'Add to favorite', // Add text if not favorite
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: poppinsBold,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider between menu options
              Divider(
                color: Colors.grey.withOpacity(0.2), // Light grey divider
              ),
              // Add to playlist option
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close bottom sheet
                  goToLibraryPage(context, true, shabadData); // Navigate to library page
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding
                  color: secondPrimaryColor.withOpacity(0), // Transparent background
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline_sharp, // Play icon
                        color: secondPrimaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10, // Spacing between icon and text
                      ),
                      Text(
                        'Add to playlist', // Playlist option text
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: poppinsBold,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider before cancel button
              Divider(
                color: Colors.grey.withOpacity(0.2), // Light grey divider
              ),
              const SizedBox(
                height: 15, // Spacing before cancel button
              ),
              // Cancel button row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(darkBlueColor)), // Dark blue background
                    onPressed: () {
                      Navigator.of(context).pop(); // Close bottom sheet
                    },
                    child: const Center(
                      child: Text(
                        'Cancel', // Cancel button text
                        style: TextStyle(color: Colors.white), // White text
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15, // Bottom spacing
              ),
            ],
          ),
        );
      },
    );
  }
}
