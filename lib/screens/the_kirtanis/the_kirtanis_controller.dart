import 'package:get/get.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/network_service/models/the_kirtanis_model.dart';

class TheKirtanisController extends GetxController {
  
  ApiRepository apiRepository = ApiRepository();
  List<TheKirtanisModel> list = [];
  
  @override
  void onInit() {
    super.onInit();
    getRaagsData();
  }

  void getRaagsData() {
    apiRepository.getKirtanis().then((value) {
      list = value;
      update();
    });
  }
}
