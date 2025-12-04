// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/colors.dart';
import 'package:shabadguru/utils/font.dart';
import 'package:shabadguru/utils/shared_pref.dart';

// Controller for managing favorite shabads functionality and state
class MyFavoriteShabadController extends GetxController {
  List<ShabadData> myFavoriteShabad = []; // List of favorite shabads

  RxBool isSearchEnable = false.obs; // Search functionality toggle
  String searchValue = ''; // Current search query

  // Initialize controller and load favorite shabads
  @override
  void onInit() {
    super.onInit();
    getMyFavoriteShabad(); // Load favorite shabads from storage
  }

  // Load favorite shabads from local storage
  Future<void> getMyFavoriteShabad() async {
    myFavoriteShabad = await SharedPref.getMyFavoriteList(); // Get favorite list from shared preferences
    update(); // Update UI
    return;
  }

  // Show bottom sheet menu for favorite shabad options
  void onMenuTapped(ShabadData myFavoriteShabad, context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false, // Not scroll controlled
         constraints: const BoxConstraints(
        maxWidth: double.infinity, // Full width
      ),
        useRootNavigator: false, // Use current navigator
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 180, // Fixed height
              color: secondPrimaryColor.withOpacity(0), // Transparent background
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Container padding
              child: Column(
                children: [
                  // Remove from favorites option
                  GestureDetector(
                    onTap: () async {
                      final myFavoriteList =
                          await SharedPref.getMyFavoriteList(); // Get current favorite list
                      if (myFavoriteList.isNotEmpty) {
                        // Find and remove the shabad from favorites
                        for (var i = 0; i < myFavoriteList.length; i++) {
                          if (myFavoriteList[i].audio ==
                              myFavoriteShabad.audio) {
                            myFavoriteList.removeAt(i); // Remove from list
                            break;
                          }
                        }
                      }
                      await SharedPref.saveMyFavoriteList(myFavoriteList); // Save updated list
                      // Show success message
                      Fluttertoast.showToast(
                        msg: 'Shabad removed from your favorite', // Removal message
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: darkBlueColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      await getMyFavoriteShabad(); // Refresh favorite list
                      setState(() {}); // Update bottom sheet state
                      Navigator.of(context).pop(); // Close bottom sheet
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15), // Vertical padding
                      color: secondPrimaryColor.withOpacity(0), // Transparent background
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite, // Heart icon
                            color: secondPrimaryColor, // Icon color
                            size: 18, // Icon size
                          ),
                          const SizedBox(
                            width: 10, // Spacing between icon and text
                          ),
                          Text(
                            'Remove from favorite', // Remove option text
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
                    color: Colors.grey.withOpacity(0.2), // Divider line
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
                                  WidgetStateProperty.all(darkBlueColor)), // Button background
                          onPressed: () {
                            Navigator.of(context).pop(); // Close bottom sheet
                          },
                          child: const Center(
                            child: Text(
                              'Cancel', // Cancel button text
                              style: TextStyle(color: Colors.white), // White text
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 15, // Bottom spacing
                  ),
                ],
              ),
            );
          });
        });
  }

  // Handle search functionality
  void onSearch(String value) {
    searchValue = value; // Update search query
    update(); // Update UI to reflect search results
  }
}
