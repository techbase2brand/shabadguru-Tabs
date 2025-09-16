// ignore_for_file: avoid_print, deprecated_member_use

// Main entry point for ShabadGuru app - manages Firebase setup and theme management
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
// App startup function - initializes Firebase and system settings
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Setup Firebase for notifications
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light, // Make status bar icons light
    ),
  );

  // Check if app was opened from notification
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  remoteMessageGlobal = initialMessage;
  runApp(const MyApp()); // Start the app
}

// Manages notifications when app is in background
backgroundHandler(NotificationResponse details) {
  // Put notification management code here.
}

// Main app widget - manages theme and navigation
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// App state class - manages theme changes and system brightness
class _MyAppState extends State<MyApp>
    with WidgetsBindingObserver
    implements DarkModeChangeListener {
  ThemeData? darkThemeData; // Dark theme styling
  bool? systemDarkMode; // Track if system is in dark mode
  late DarkThemeProvider themeChangeProvider; // Theme state manager

  _MyAppState() {
    themeChangeProvider = DarkThemeProvider(this); // Initialize theme provider
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Listen to system changes
    getCurrentAppTheme(); // Load saved theme
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    super.dispose();
  }

  // Called when system brightness changes (day/night mode)
  @override
  void didChangePlatformBrightness() {
    setState(() {
      final systemBrightness =
          WidgetsBinding.instance.window.platformBrightness;
      if ("Brightness.light" == systemBrightness.toString()) {
        themeChangeProvider.darkTheme = false; // Light mode
      } else {
        themeChangeProvider.darkTheme = true; // Dark mode
      }
      super.didChangePlatformBrightness();
    });
  }

  // Load theme settings from device storage
  Future<void> getCurrentAppTheme() async {
    try {
      // Get user's saved theme preference
      themeChangeProvider.darkTheme =
          await themeChangeProvider.darkThemePreference.getTheme();
      systemDarkMode =
          await themeChangeProvider.darkThemePreference.getSystemDarkTheme();

      if (systemDarkMode != null) {
        if (!systemDarkMode!) {
          darkThemeData = ThemeData.dark();
          if (themeChangeProvider.darkTheme == false) {
            // Check current system brightness
            final systemBrightness =
                WidgetsBinding.instance.window.platformBrightness;
            if ("Brightness.light" == systemBrightness.toString()) {
              themeChangeProvider.darkTheme = false;
            } else {
              themeChangeProvider.darkTheme = true;
            }
          }
        } else {
          darkThemeData = null; // Use system theme
        }
      } else {
        // No preference saved, use system brightness
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

  // Build the main app widget with theme provider
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider; // Provide theme to all child widgets
    }, child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
      return GetMaterialApp(
        title: 'Shabadguru',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.light,
        home: const SplashScreen(), // Start with splash screen
      );
    }));
  }

  // Called when user changes theme manually
  @override
  void onChanged(bool value) {
    if (value == true) {
      darkThemeData = null; // Use system dark theme
    } else {
      darkThemeData = ThemeData.dark(); // Use custom dark theme
    }
  }
}
