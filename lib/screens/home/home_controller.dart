// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/main.dart';
import 'package:shabadguru/network_service/api.dart';
import 'package:shabadguru/network_service/models/popular_bannis.dart';
import 'package:shabadguru/network_service/models/popular_raags_model.dart';
import 'package:shabadguru/network_service/models/shabad_raag_model.dart';
import 'package:shabadguru/utils/assets.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';
import 'package:shabadguru/utils/routes.dart';
import 'package:shabadguru/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomeController extends GetxController {
  HomeController({required this.buildContext});
  late DarkThemeProvider themeProvider;
  List<FeaturedModel> featuredList = [];
  ApiRepository apiRepository = ApiRepository();

  PopularRaagsModel? popularRaagsModel;
  List<ShabadData> recentData = [];

  PopularBannisModel? popularBannisModel;

  final String homePageData = 'home_page_data';
  final String banisData = 'banis_data';

  List<RaagData> popularRaagsList = [];

  RxBool raagsSelected = true.obs;
  RxBool preRaagsSelected = false.obs;
  RxBool postRaagsSelected = false.obs;

  final GlobalKey<ScaffoldState> keyScaffold = GlobalKey();
  final GlobalKey<ScaffoldState> keyScaffoldBanis = GlobalKey();
  final GlobalKey<ScaffoldState> keyScaffoldRags = GlobalKey();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  BuildContext? buildContext;

  // List<Time> notificationTimesAlot = [];
  final random = Random();
  int randomIndex = 0;

  @override
  void onInit() {
    super.onInit();
    featuredList.add(FeaturedModel(title: 'All Raags', image: raagsSvg));
    featuredList.add(FeaturedModel(title: 'Popular Banis', image: banisSvg));
    featuredList
        .add(FeaturedModel(title: 'The Kirtanis', image: theKirtanisSvg));
    getHomeLocalData();
    // getHomeData();
    getRecentData();
    requestNotificationPermission();
    // getBannisData();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("sdasdjaskdasldksadlaskkdjasldkasd");
      openMusicPlayerPage(message);
    });

    if (remoteMessageGlobal != null) {
      openMusicPlayerPage(remoteMessageGlobal!);
    }
  }

  Future<void> openMusicPlayerPage(RemoteMessage message) async {
    final String response =
        await rootBundle.loadString('assets/home_data/home_banis_data.json');
    final data = await json.decode(response);
    final popularBannisModel = PopularBannisModel.fromJson(data);
    final String responseHomeData =
        await rootBundle.loadString('assets/home_data/home_data.json');
    final dataHome = await json.decode(responseHomeData);
    final popularRaagsModel = PopularRaagsModel.fromJson(dataHome);

    print("onMessageOpenedApp: ${message.data}");
    String raagId = message.data['id'].toString();

    String title = '';

    for (var i = 0; i < popularRaagsModel.data!.length; i++) {
      if (popularRaagsModel.data![i].id.toString() == raagId) {
        title = popularRaagsModel.data![i].name;
        break;
      }
    }

    if (title.isEmpty) {
      for (var i = 0; i < popularBannisModel.data!.length; i++) {
        if (popularBannisModel.data![i].id.toString() == raagId) {
          title = popularBannisModel.data![i].name;
          break;
        }
      }
    }

    String body = message.notification?.body ?? 'abc';

    try {
      print("sadasdsadsadsad $body");
      final String response =
          await rootBundle.loadString('assets/raags_shabad/shabad$raagId.json');
      final data = await json.decode(response);

      final shabadRaagModel = ShabadRaagModel.fromJson(data);

      for (var i = 0; i < shabadRaagModel.data!.length; i++) {
        if (shabadRaagModel.data![i].song == body) {
          if (audioHandler != null) {
            if (isMusicPlayerPageOpen) {
              audioHandler!.pause();
              audioHandler!.stop();
              audioHandler = null;
              playingLyricModel = null;
              musicPlayerController!.shabadData = shabadRaagModel.data![i];
              musicPlayerController!.listOfShabads = shabadRaagModel.data!;
              musicPlayerController!.title = title;
              musicPlayerController!.playerLoading = true;
              musicPlayerController!.sheetHeight = 0.1;
              musicPlayerController!.update();
              musicPlayerController!.onInit();
            } else {
              goToMusicPlayerPage(buildContext, shabadRaagModel.data![i], title,
                  shabadRaagModel.data!);
            }
          } else {
            goToMusicPlayerPage(buildContext, shabadRaagModel.data![i], title,
                shabadRaagModel.data!);
          }
          break;
        }
      }
    } catch (e) {
      print("sadasdsadsadsad dsdsd $body");
      final String response =
          await rootBundle.loadString('assets/raags_banis/shabad$raagId.json');
      final data = await json.decode(response);

      final shabadRaagModel = ShabadRaagModel.fromJson(data);

      for (var i = 0; i < shabadRaagModel.data!.length; i++) {
        if (shabadRaagModel.data![i].song == body) {
          if (audioHandler != null) {
            if (isMusicPlayerPageOpen) {
              audioHandler!.pause();
              audioHandler!.stop();
              audioHandler = null;
              playingLyricModel = null;
              musicPlayerController!.shabadData = shabadRaagModel.data![i];
              musicPlayerController!.title = title;
              musicPlayerController!.listOfShabads = shabadRaagModel.data!;
              musicPlayerController!.playerLoading = true;
              musicPlayerController!.sheetHeight = 0.1;
              musicPlayerController!.update();
              musicPlayerController!.onInit();
            } else {
              goToMusicPlayerPage(buildContext, shabadRaagModel.data![i], title,
                  shabadRaagModel.data!);
            }
          } else {
            goToMusicPlayerPage(buildContext, shabadRaagModel.data![i], title,
                shabadRaagModel.data!);
          }
          break;
        }
      }
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  Future<void> getHomeLocalData() async {
    final String response =
        await rootBundle.loadString('assets/home_data/home_banis_data.json');
    final data = await json.decode(response);
    popularBannisModel = PopularBannisModel.fromJson(data);
    update();
    final String responseHomeData =
        await rootBundle.loadString('assets/home_data/home_data.json');
    final dataHome = await json.decode(responseHomeData);
    popularRaagsModel = PopularRaagsModel.fromJson(dataHome);

    popularRaagsList = getRandomItems(popularRaagsModel!.data!, 10);
    randomIndex = random.nextInt(popularRaagsModel!.data!.length);
    update();

    // initializeNotifications();
  }

  void getBannisData() {
    apiRepository.getBannisRaags().then((value) {
      if (value.error == null) {
        popularBannisModel = value;
        String rawJson = jsonEncode(popularBannisModel!.toJson());
        update();
        saveHomeBanisData(rawJson);
        update();
      }
    });
    getHomeBanisData().then((value) {
      if (value != null) {
        final data = jsonDecode(value);
        popularBannisModel = PopularBannisModel.fromJson(data);
        update();
      }
    });
  }

  Future<void> getRecentData() async {
    recentData = await SharedPref.getList();
    update();
  }

  void getHomeData() {
    apiRepository.getPopularRaags().then((value) {
      if (value.error == null) {
        popularRaagsModel = value;
        String rawJson = jsonEncode(popularRaagsModel!.toJson());
        popularRaagsList = getRandomItems(popularRaagsModel!.data!, 10);
        update();
        saveHomePageData(rawJson);
      }
    });
    getHomePageData().then((value) {
      if (value != null) {
        final data = jsonDecode(value);
        popularRaagsModel = PopularRaagsModel.fromJson(data);
        popularRaagsList = getRandomItems(popularRaagsModel!.data!, 10);
        update();
      }
    });
  }

  List<RaagData> getRandomItems<T>(List<RaagData> list, int count) {
    final random = Random();
    final length = list.length;
    final indices = <int>{};

    while (indices.length < count) {
      final index = random.nextInt(length);
      indices.add(index);
    }

    return indices.map((index) => list[index]).toList();
  }

  List<ShabadRaagModel> getRandomShabadData<T>(
      List<ShabadRaagModel> list, int count) {
    final random = Random();
    final length = list.length;
    final indices = <int>{};

    while (indices.length < count) {
      final index = random.nextInt(length);
      indices.add(index);
    }

    return indices.map((index) => list[index]).toList();
  }

  Future<String?> getHomePageData() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(homePageData);
  }

  Future<bool> saveHomePageData(String homeData) async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.setString(homePageData, homeData);
  }

  Future<String?> getHomeBanisData() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(banisData);
  }

  Future<bool> saveHomeBanisData(String baniData) async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.setString(banisData, baniData);
  }

  void updatePostRaags() {
    postRaagsSelected.value = true;
    preRaagsSelected.value = false;
    raagsSelected.value = false;
    update();
  }

  void updateRaags() {
    postRaagsSelected.value = false;
    preRaagsSelected.value = false;
    raagsSelected.value = true;
    update();
  }

  void updatePreRaags() {
    postRaagsSelected.value = false;
    preRaagsSelected.value = true;
    raagsSelected.value = false;
    update();
  }

  void initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: backgroundHandler,
      onDidReceiveNotificationResponse: (details) async {
        final data = jsonDecode(details.payload ?? '');

        String raagId = data['raagId'];
        String raagName = data['raagName'];

        // print("Sunny ID $raagId");
        // print("Sunny name $raagName");

        final String response = await rootBundle
            .loadString('assets/raags_shabad/shabad$raagId.json');
        final dataOfRaag = await json.decode(response);
        final shabadRaagModel = ShabadRaagModel.fromJson(dataOfRaag);

        final random = Random();

        int randomIndex = random.nextInt(shabadRaagModel.data!.length);
        goToMusicPlayerPage(buildContext, shabadRaagModel.data![randomIndex],
            raagName, shabadRaagModel.data!);
      },
    );

    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission();
    }

    final notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails != null) {
      if (notificationAppLaunchDetails.notificationResponse != null) {
        final data = jsonDecode(
            notificationAppLaunchDetails.notificationResponse!.payload ?? '');

        String raagId = data['raagId'];
        String raagName = data['raagName'];

        // print("Sunny ID $raagId");
        // print("Sunny name $raagName");

        final String response = await rootBundle
            .loadString('assets/raags_shabad/shabad$raagId.json');
        final dataOfRaag = await json.decode(response);
        final shabadRaagModel = ShabadRaagModel.fromJson(dataOfRaag);

        final random = Random();

        int randomIndex = random.nextInt(shabadRaagModel.data!.length);
        goToMusicPlayerPage(buildContext, shabadRaagModel.data![randomIndex],
            raagName, shabadRaagModel.data!);
      }
    }

    scheduleDailyNotification();
  }

  Future<void> scheduleDailyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'shabad_guru_notification',
      'shabad_guru',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      categoryIdentifier: 'myNotificationCategory',
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.cancelAll();

    tz.initializeTimeZones();

    for (var i = 0; i < 5; i++) {
      randomIndex = random.nextInt(popularRaagsModel!.data!.length);
      var now1 = tz.TZDateTime.now(tz.local);
      var tomorrow = now1.add(Duration(days: 1 + i));
      // var tomorrow = now1;
      var scheduledTime1 = tz.TZDateTime(
        tz.local,
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        23,
        59,
        0,
      );

      // var time = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

      // print("dsklfsdjf $scheduledTime1");
      // print("dsklfsdjfNEw $time");

      await flutterLocalNotificationsPlugin.zonedSchedule(
          i,
          'Shabadguru',
          getRandomName(),
          scheduledTime1,
          // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          platformChannelSpecifics,
          payload:
              '{"raagId": "${getRandomId()}", "raagName": "${getRandomName()}"}',
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   0, // Notification ID
    //   'Daily Notification',
    //   'It\'s time for your daily notification!',
    //   tz.TZDateTime.from(
    //       scheduledTime, tz.local), // Replace 'tz' with your time zone instance
    //   platformChannelSpecifics,
    //   payload: 'Daily notification payload',
    //   androidAllowWhileIdle: true,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );
  }

  String getRandomId() {
    String randomItem = popularRaagsModel!.data![randomIndex].id.toString();
    return randomItem;
  }

  String getRandomName() {
    String randomTitle = popularRaagsModel!.data![randomIndex].name.toString();
    return randomTitle;
  }

  Future<void> requestNotificationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String? token = await messaging.getToken();
    print("Push notification token $token");
    String deviceId = '123456789';
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor ?? '';
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    }
    final body = jsonEncode(
      {'device': deviceId, "fcm_token": token},
    );

    print("Body $body");
    apiRepository.uploadPushNotificationToken(body);
  }
}

class FeaturedModel {
  late String title;
  late String image;
  FeaturedModel({required this.title, required this.image});
}
