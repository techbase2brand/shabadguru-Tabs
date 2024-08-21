import 'package:shabadguru/network_service/api_provider.dart';
import 'package:shabadguru/network_service/models/popular_bannis.dart';
import 'package:shabadguru/network_service/models/popular_raags_model.dart';
import 'package:shabadguru/network_service/models/punjabi_lyrics_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/network_service/models/the_kirtanis_model.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<PopularRaagsModel> getPopularRaags() {
    return _provider.getPopularRaags();
  }

  Future<PopularBannisModel> getBannisRaags() {
    return _provider.getBannisRaags();
  }

  Future<ShabadRaagModel> getShabad(String categoryId, String id) {
    return _provider.getShabad(categoryId, id);
  }

  Future<PunjabiLyricsModel> getPunjabiLyrics(String url) {
    return _provider.getPunjabiLyrics(url);
  }

  Future<bool> contactUs(body) {
    return _provider.contactUs(body);
  }

  Future<bool> emailSubscribe(body) {
    return _provider.emailSubscribe(body);
  }

  Future<List<TheKirtanisModel>> getKirtanis() {
    return _provider.getKirtanis();
  }

  Future<bool> uploadPushNotificationToken(body) {
    return _provider.uploadPushNotificationToken(body);
  }


  Future<bool> updateNotificationStatus(body) {
    return _provider.updateNotificationStatus(body);
  }
}
