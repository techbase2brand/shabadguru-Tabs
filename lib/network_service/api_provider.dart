// API provider for handling all network requests and data fetching
import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shabadguru/network_service/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:shabadguru/network_service/models/popular_bannis.dart';
import 'package:shabadguru/network_service/models/popular_raags_model.dart';
import 'package:shabadguru/network_service/models/punjabi_lyrics_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/network_service/models/the_kirtanis_model.dart';

// Provider class for making HTTP requests to ShabadGuru API endpoints
class ApiProvider {
  var logger = Logger(); // Logger for debugging and error tracking

  // Fetch popular Raags data from API
  Future<PopularRaagsModel> getPopularRaags() async {
    try {
      logger.i("URL:- ${ApiUrl.popularRaagsUrl}"); // Log the API URL

      // Make HTTP GET request to popular Raags endpoint
      final response = await http.get(Uri.parse(ApiUrl.popularRaagsUrl),
          headers: {
            'Content-Type': 'application/json' // Set content type header
          }).timeout(const Duration(seconds: 50)); // Set 50 second timeout
      logger.i("Popular raags data ${response.body}"); // Log response body
      
      // Check if request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body); // Parse JSON response
        return PopularRaagsModel.fromJson(data); // Convert to model
      } else {
        return PopularRaagsModel.withError(response.body.toString()); // Return error model
      }
    } on TimeoutException catch (_) {
      logger.e("Time out exception in popular raags"); // Log timeout error
      return PopularRaagsModel.withError("Timeout exception"); // Return timeout error
    } catch (error, stacktrace) {
      logger.e(
          "Exception occured in popular raags: $error stackTrace: $stacktrace"); // Log general error
      return PopularRaagsModel.withError("Data not found / Connection issue"); // Return connection error
    }
  }

  // Fetch popular Banis data from API
  Future<PopularBannisModel> getBannisRaags() async {
    try {
      logger.i("URL:- ${ApiUrl.popularBannisUrl}"); // Log the API URL
      
      // Make HTTP GET request to popular Banis endpoint
      final response = await http.get(Uri.parse(ApiUrl.popularBannisUrl),
          headers: {
            'Content-Type': 'application/json' // Set content type header
          }).timeout(const Duration(seconds: 50)); // Set 50 second timeout
      logger.i("Bannis Raags data ${response.body}"); // Log response body
      
      // Check if request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body); // Parse JSON response
        return PopularBannisModel.fromJson(data); // Convert to model
      } else {
        return PopularBannisModel.withError(response.body.toString()); // Return error model
      }
    } on TimeoutException catch (_) {
      logger.e("Time out exception in bannis raags"); // Log timeout error
      return PopularBannisModel.withError("Timeout exception"); // Return timeout error
    } catch (error, stacktrace) {
      logger.e(
          "Exception occured in bannis raags: $error stackTrace: $stacktrace"); // Log general error
      return PopularBannisModel.withError("Data not found / Connection issue"); // Return connection error
    }
  }

  // Fetch specific Shabad data by category ID and Shabad ID
  Future<ShabadRaagModel> getShabad(String categoryId, String id) async {
    try {
      logger.i("URL:- ${ApiUrl.shabadUrl}$categoryId/$id"); // Log the API URL with parameters
      
      // Make HTTP GET request to specific Shabad endpoint
      final response = await http
          .get(Uri.parse('${ApiUrl.shabadUrl}$categoryId/$id'), headers: {
        'Content-Type': 'application/json' // Set content type header
      }).timeout(const Duration(seconds: 50)); // Set 50 second timeout
      logger.i("Shabad data ${response.body}"); // Log response body
      
      // Check if request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body); // Parse JSON response
        return ShabadRaagModel.fromJson(data); // Convert to model
      } else {
        return ShabadRaagModel.withError(response.body.toString()); // Return error model
      }
    } on TimeoutException catch (_) {
      logger.e("Time out exception in shabad"); // Log timeout error
      return ShabadRaagModel.withError("Timeout exception"); // Return timeout error
    } catch (error, stacktrace) {
      logger.e("Exception occured in shabad: $error stackTrace: $stacktrace"); // Log general error
      return ShabadRaagModel.withError("Data not found / Connection issue"); // Return connection error
    }
  }

  Future<PunjabiLyricsModel> getPunjabiLyrics(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json'
      }).timeout(const Duration(seconds: 50));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        return PunjabiLyricsModel.fromJson(data);
      } else {
        return PunjabiLyricsModel.withError(response.body.toString());
      }
    } on TimeoutException catch (_) {
      return PunjabiLyricsModel.withError("Timeout exception");
    } catch (error) {
      return PunjabiLyricsModel.withError("Data not found / Connection issue");
    }
  }

  Future<bool> contactUs(body) async {
    try {
      logger.i("URL:- ${ApiUrl.contactUsUrl}");
      final response = await http.post(Uri.parse(ApiUrl.contactUsUrl),
          body: body,
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 20));
      logger.i("Contact US ${response.body}");
      return true;
    } on TimeoutException catch (_) {
      logger.e("Time out exception in punjabi lyrics");
      return false;
    } catch (error, stacktrace) {
      logger
          .e("Exception occured in contact us: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<bool> emailSubscribe(body) async {
    try {
      logger.i("URL:- ${ApiUrl.emailSubscribeUrl}");
      final response = await http.post(Uri.parse(ApiUrl.emailSubscribeUrl),
          body: body,
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 20));
      logger.i("Email subscribe ${response.body}");
      return true;
    } on TimeoutException catch (_) {
      logger.e("Time out exception in email");
      return false;
    } catch (error, stacktrace) {
      logger.e("Exception occured in email: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<bool> uploadPushNotificationToken(body) async {
    try {
      final response = await http.post(
          Uri.parse(ApiUrl.uploadPushNotificationToken),
          body: body,
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 20));
      logger.i("Push token api ${response.body}");
      return true;
    } on TimeoutException catch (_) {
      logger.e("Time out exception in Push token api");
      return false;
    } catch (error, stacktrace) {
      logger.e(
          "Exception occured in Push token api: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<bool> updateNotificationStatus(body) async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.updatePermission),
          body: body,
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 20));
      logger.i("Push token api ${response.body}");
      return true;
    } on TimeoutException catch (_) {
      logger.e("Time out exception in Push token api");
      return false;
    } catch (error, stacktrace) {
      logger.e(
          "Exception occured in Push token api: $error stackTrace: $stacktrace");
      return false;
    }
  }

  Future<List<TheKirtanisModel>> getKirtanis() async {
    try {
      logger.i("URL:- ${ApiUrl.theKirtanisUrl}");
      final response = await http.get(Uri.parse(ApiUrl.theKirtanisUrl),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(const Duration(seconds: 50));
      logger.i("Kirtanis data ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        List<TheKirtanisModel> kiratinsList = [];
        for (var i = 0; i < data.length; i++) {
          kiratinsList.add(TheKirtanisModel.fromJson(data[i]));
        }
        return kiratinsList;
      } else {
        return [];
      }
    } on TimeoutException catch (_) {
      logger.e("Time out exception in Kirtanis");
      return [];
    } catch (error, stacktrace) {
      logger.e("Exception occured in Kirtanis: $error stackTrace: $stacktrace");
      return [];
    }
  }
}
