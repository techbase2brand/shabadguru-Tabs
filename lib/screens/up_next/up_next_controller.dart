// Controller for managing up next playlist functionality
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:shabadguru/utils/shared_pref.dart';

// Controller for managing up next playlist with menu options and favorites
class UpNextController extends GetxController {
  UpNextController({required this.listOfShabads});

  final List<ShabadData> listOfShabads; // List of Shabads in the up next playlist

  // Show bottom sheet menu with options for Shabad in up next playlist
  Future<void> showMenuOptions(
    context,
    ShabadData shabadData,
  ) async {
    final myFavoriteListShabad = await SharedPref.getMyFavoriteList(); // Get favorite list
    bool isFindShabad = false; // Check if Shabad is already in favorites
    for (var i = 0; i < myFavoriteListShabad.length; i++) {
      if (myFavoriteListShabad[i].audio == shabadData.audio) {
        isFindShabad = true; // Found in favorites
        break;
      }
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, // Not scroll controlled
      constraints: const BoxConstraints(
        maxWidth: double.infinity, // Full width
      ),
      useRootNavigator: false, // Use current navigator
      builder: (context) {
        return Container(
          height: audioHandler != null ? 390 : 260, // Dynamic height based on audio handler
          color: secondPrimaryColor.withOpacity(0), // Transparent background
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Container padding
          child: Column(
            children: [
              // Add/Remove from favorites option
              GestureDetector(
                onTap: () async {
                  bool isFind = false; // Track if Shabad was found in favorites
                  final myFavoriteList = await SharedPref.getMyFavoriteList(); // Get current favorites
                  if (myFavoriteList.isNotEmpty) {
                    // Check if Shabad already exists in favorites
                    for (var i = 0; i < myFavoriteList.length; i++) {
                      if (myFavoriteList[i].audio == shabadData.audio) {
                        isFind = true; // Found existing Shabad
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
                  await SharedPref.saveMyFavoriteList(myFavoriteList); // Save updated favorites
                  // Show success message
                  Fluttertoast.showToast(
                    msg: isFind
                        ? 'Shabad removed from your favorite' // Removal message
                        : "Shabad added to your favorite", // Addition message
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
                        isFindShabad ? Icons.favorite : Icons.favorite_border, // Heart icon based on favorite status
                        color: secondPrimaryColor, // Gold color
                        size: 18, // Icon size
                      ),
                      const SizedBox(
                        width: 10, // Spacing between icon and text
                      ),
                      Text(
                        isFindShabad
                            ? 'Remove from favorite' // Remove text
                            : 'Add to favorite', // Add text
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
                        Icons.play_circle_outline_sharp, // Playlist icon
                        color: secondPrimaryColor, // Gold color
                        size: 18, // Icon size
                      ),
                      const SizedBox(
                        width: 10, // Spacing between icon and text
                      ),
                      Text(
                        'Add to playlist', // Add to playlist text
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
                            WidgetStateProperty.all(darkBlueColor)), // Blue background
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
