// ignore_for_file: avoid_print, deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shabadguru/audio_service/audio_service.dart';
import 'package:shabadguru/screens/splash/splash_screen.dart';
import 'package:shabadguru/utils/dark_mode/app_state_notifier.dart';

/*
Change the code in lyrics_reader_widget.dart at line number 188


var drawInfo = LyricDrawInfo()
        ..playingExtTextPainter = getTextPaint(
            element.extText,
            widget.ui.getPlayingExtTextStyle().copyWith(
                  color: Color(0XFFB68A1E),
                  fontSize: 20,
                ),
            size: size)
        ..otherExtTextPainter = getTextPaint(element.extText,
            widget.ui.getOtherExtTextStyle().copyWith(color: Colors.grey),
            size: size)
        ..playingMainTextPainter = getTextPaint(
            element.mainText,
            widget.ui.getPlayingMainTextStyle().copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
            size: size)
        ..otherMainTextPainter = getTextPaint(element.mainText,
            widget.ui.getOtherMainTextStyle().copyWith(color: Colors.grey),
            size: size);


Change Color at line number:- 65, file name:- lyric_ui.dart , Color = Color(0XFFB68A1E) from this package
'package:flutter_lyric/lyric_ui/lyric_ui.dart' in above file

Hide the line in audio player initialization cache manager == null


FLoating action button remove padding in persistance-tab-view.widget.dart in persistance tab bar line number 445
*/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ),
  );

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  remoteMessageGlobal = initialMessage;
  runApp(const MyApp());
}

backgroundHandler(NotificationResponse details) {
  // Put handling code here.
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with WidgetsBindingObserver
    implements DarkModeChangeListener {
  ThemeData? darkThemeData;

  bool? systemDarkMode;

  late DarkThemeProvider themeChangeProvider;

  _MyAppState() {
    themeChangeProvider = DarkThemeProvider(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getCurrentAppTheme();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      final systemBrightness =
          WidgetsBinding.instance.window.platformBrightness;
      if ("Brightness.light" == systemBrightness.toString()) {
        themeChangeProvider.darkTheme = false;
      } else {
        themeChangeProvider.darkTheme = true;
      }
      super.didChangePlatformBrightness();
    });
  }

  Future<void> getCurrentAppTheme() async {
    try {
      themeChangeProvider.darkTheme =
          await themeChangeProvider.darkThemePreference.getTheme();
      systemDarkMode =
          await themeChangeProvider.darkThemePreference.getSystemDarkTheme();

      if (systemDarkMode != null) {
        if (!systemDarkMode!) {
          darkThemeData = ThemeData.dark();
          if (themeChangeProvider.darkTheme == false) {
            final systemBrightness =
                WidgetsBinding.instance.window.platformBrightness;
            if ("Brightness.light" == systemBrightness.toString()) {
              themeChangeProvider.darkTheme = false;
            } else {
              themeChangeProvider.darkTheme = true;
            }
          }
        } else {
          darkThemeData = null;
        }
      } else {
        final systemBrightness =
            WidgetsBinding.instance.window.platformBrightness;
        if ("Brightness.light" == systemBrightness.toString()) {
          themeChangeProvider.darkTheme = false;
        } else {
          themeChangeProvider.darkTheme = true;
        }
      }
    } catch (exception) {
      print("Exception in dark mode $exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
      return GetMaterialApp(
        title: 'Shabadguru',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      );
    }));
  }

  @override
  void onChanged(bool value) {
    if (value == true) {
      darkThemeData = null;
    } else {
      darkThemeData = ThemeData.dark();
    }
  }
}
