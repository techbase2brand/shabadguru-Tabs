// Controller for managing Nitnem screen data and state
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/network_service/models/nitnem_model.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controller for managing Nitnem operations including data loading from API
class NitnemController extends GetxController {
  NitnemController({required this.buildContext});
  
  BuildContext? buildContext; // Build context for navigation
  NitnemModel? nitnemModel; // Model to store Nitnem data
  ApiRepository apiRepository = ApiRepository(); // API service for data fetching
  final String nitnemDataKey = 'nitnem_cached_data'; // Cache key for SharedPreferences

  // Initialize controller and load Nitnem data
  @override
  void onInit() {
    super.onInit();
    getNitnemData(); // Load data from API (with cache fallback)
  }

  // Load Nitnem data from API with local cache fallback
  Future<void> getNitnemData() async {
    // First, try to load from cache for instant display
    await loadFromCache();
    
    // Then fetch fresh data from API
    apiRepository.getNitnem().then((value) {
      if (value.error == null) {
        nitnemModel = value;
        String rawJson = jsonEncode(nitnemModel!.toJson());
        saveToCache(rawJson); // Cache the data
        update(); // Update UI with fresh data
      } else {
        // If API fails and we don't have cached data, show error
        if (nitnemModel == null) {
          nitnemModel = NitnemModel.withError(value.error!);
          update();
        }
      }
    }).catchError((error) {
      print("Error fetching Nitnem from API: $error");
      // If API fails and we don't have cached data, show error
      if (nitnemModel == null) {
        nitnemModel = NitnemModel.withError("Failed to load Nitnem data");
        update();
      }
    });
  }

  // Load cached Nitnem data from SharedPreferences
  Future<void> loadFromCache() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final cachedData = sharedPref.getString(nitnemDataKey);
      if (cachedData != null) {
        final data = jsonDecode(cachedData);
        nitnemModel = NitnemModel.fromJson(data);
        update(); // Update UI with cached data
      }
    } catch (e) {
      print("Error loading cached Nitnem data: $e");
    }
  }

  // Save Nitnem data to cache
  Future<void> saveToCache(String data) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString(nitnemDataKey, data);
    } catch (e) {
      print("Error saving Nitnem data to cache: $e");
    }
  }

  // Navigate to Nitnem Shabad screen when user selects a Nitnem
  void navigateToNitnemShabad(NitnemData nitnemData) {
    // Pass audio URL and lyrics URL directly
    goToNitnemShabadPage(
      buildContext, 
      nitnemData.file?.toString() ?? '', // Audio URL
      nitnemData.lyricsFile?.toString() ?? '', // Lyrics JSON URL
      nitnemData.name?.toString() ?? 'Nitnem'
    );
  }
}
