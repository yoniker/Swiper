import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/services/location_service.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/onboarding/welcome_screen.dart';
import 'package:betabeta/services/notifications_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

/// This is the first root of the Application from here
/// we navigate to other routes.
class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation sizeAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    sizeAnimation =
        Tween<double>(begin: 100.0, end: 140.0).animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat(reverse: true);
    _load();
    super.initState();
  }

  Future<bool> _initializeApp() async {
    //TODO support error states
    await ChatData.initDB();
    await NotificationsController.instance.initialize();
    await SettingsData.instance.readSettingsFromShared();
    if (SettingsData.instance.uid.length > 0) {
      await LocationService.instance.onInit();
    }
    MatchEngine.instance;
    await CelebsInfo.instance.getCelebsFromDatabase();
    bool notificationFromTerminated = await ChatData.instance.onInitApp();
    updateFcmToken();
    return notificationFromTerminated;
  }

  Future<void> updateFcmToken() async {
    while (true) {
      try {
        String? token = await FirebaseMessaging.instance.getToken();
        print('Got the token $token');
        if (token != null) {
          await SettingsData.instance.readSettingsFromShared();
          if (SettingsData.instance.uid .length>0) {
            print('sending fcm token to server...');
            SettingsData.instance.fcmToken = token;
          }
          return;
        }
      } catch (val) {
        print('caught $val');
      }
    }
  }

  Future<String> _routeTo() async {
    SettingsData settings = SettingsData.instance;
    // we are making sure that if the user is already logged in at a time and i.e. sharedPreferences data exist
    // we move to the Main-navigation screen otherwise we move to the LoginScreen.
    //
    // This is the standard way of creating a splash-screen for an Application.
    if (settings.readFromShared! && settings.uid.length > 0) {
      return MainNavigationScreen.routeName;
    }

    return WelcomeScreen.routeName;
  }

  // loads in the shared preference.
  void _load() async {
    bool navigatedToChatScreen = await _initializeApp();
    final routeTo = await _routeTo();
    if (!navigatedToChatScreen) {
      Get.offAllNamed(routeTo);
    }
    await NotificationsController.instance.cancelAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                width: sizeAnimation.value,
                child: Image.asset('assets/images/voila.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo_text.png',
                fit: BoxFit.contain,
                width: 230,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
