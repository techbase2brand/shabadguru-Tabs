// API repository for providing clean interface to API provider
import 'package:shabadguru/network_service/api_provider.dart';
import 'package:shabadguru/network_service/models/popular_bannis.dart';
import 'package:shabadguru/network_service/models/popular_raags_model.dart';
import 'package:shabadguru/network_service/models/punjabi_lyrics_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/network_service/models/the_kirtanis_model.dart';

// Repository class that provides a clean interface to the API provider
class ApiRepository {
  final _provider = ApiProvider(); // API provider instance for making HTTP requests

  // Get popular Raags data
  Future<PopularRaagsModel> getPopularRaags() {
    return _provider.getPopularRaags();
  }

  // Get popular Banis data
  Future<PopularBannisModel> getBannisRaags() {
    return _provider.getBannisRaags();
  }

  // Get specific Shabad data by category and ID
  Future<ShabadRaagModel> getShabad(String categoryId, String id) {
    return _provider.getShabad(categoryId, id);
  }

  // Get Punjabi lyrics from URL
  Future<PunjabiLyricsModel> getPunjabiLyrics(String url) {
    return _provider.getPunjabiLyrics(url);
  }

  // Submit contact us form
  Future<bool> contactUs(body) {
    return _provider.contactUs(body);
  }

  // Subscribe to email notifications
  Future<bool> emailSubscribe(body) {
    return _provider.emailSubscribe(body);
  }

  // Get The Kirtanis data
  Future<List<TheKirtanisModel>> getKirtanis() {
    return _provider.getKirtanis();
  }

  // Upload push notification token
  Future<bool> uploadPushNotificationToken(body) {
    return _provider.uploadPushNotificationToken(body);
  }

  // Update notification permission status
  Future<bool> updateNotificationStatus(body) {
    return _provider.updateNotificationStatus(body);
  }
}
