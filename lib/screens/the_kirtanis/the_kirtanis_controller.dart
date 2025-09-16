// Controller for managing The Kirtanis data and API calls
import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/network_service/models/the_kirtanis_model.dart';

// Controller for managing The Kirtanis data including API calls and data loading
class TheKirtanisController extends GetxController {
  
  ApiRepository apiRepository = ApiRepository(); // API service for data fetching
  List<TheKirtanisModel> list = []; // List to store The Kirtanis data
  
  // Initialize controller and load data
  @override
  void onInit() {
    super.onInit();
    getRaagsData(); // Load The Kirtanis data
  }

  // Fetch The Kirtanis data from API
  void getRaagsData() {
    apiRepository.getKirtanis().then((value) {
      list = value; // Store fetched data
      update(); // Update UI
    });
  }
}
