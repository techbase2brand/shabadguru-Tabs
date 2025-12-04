// Controller for managing Nitnem Shabad playback directly
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/routes.dart';

// Controller for managing Nitnem playback - directly plays audio
class NitnemShabadController extends GetxController {
  NitnemShabadController({
    required this.audioUrl,
    required this.lyricsUrl,
    required this.title,
  });

  final String audioUrl; // Direct audio MP3 URL from API
  final String lyricsUrl; // Lyrics JSON URL from API
  final String title; // Nitnem title


  // Play Nitnem directly - creates a single ShabadData and plays it
  void playNitnem(BuildContext context) {
    // Create a ShabadData object for music player
    final shabadData = ShabadData(
      title: title,
      song: title,
      author: 'Nitnem',
      audio: audioUrl, // Direct audio URL from API
      jsonData: lyricsUrl, // Lyrics URL from API
      albumart: '', // No album art for Nitnem
    );

    // Create a single-item list for playlist
    final listOfShabads = [shabadData];

    // Navigate to music player (this will handle stopping previous audio)
    goToMusicPlayerPage(
      context,
      shabadData,
      title,
      listOfShabads,
    );
  }
}
