import 'dart:io';

import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/models/details_model.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/login_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/services/notifications_controller.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _load();
    super.initState();

  }

  Future<bool> _initializeApp() async{ //TODO support error states
    await ChatData.initDB();
    await NotificationsController.instance.initialize();
    if(Platform.isIOS){
      var result =
      await NotificationsController.instance.requestIOSPermissions();
      print('RESULT OF GETTING NOTIFICATIONS PERMISSIONS IS $result');
    }
    await SettingsData().readSettingsFromShared();
    DetailsData();
    MatchEngine();
    var _ = CelebsInfo.instance;
    ChatData();
    updateFcmToken();
    bool navigatingToChatScreen = await NotificationsController.instance.navigateChatOnBackgroundNotification();
    if(!navigatingToChatScreen) {
      Get.offAllNamed(LoginScreen.routeName);
      }
    return navigatingToChatScreen;
  }

  Future<void> updateFcmToken()async{

    while(true) {
      try{
        String? token = await FirebaseMessaging.instance.getToken();
        print('Got the token $token');
        if (token != null) {
          await SettingsData().readSettingsFromShared();
          if (SettingsData().fcmToken != token) {
            print('updating fcm token..');
            SettingsData().fcmToken = token;
          }
          return;
        }
      }
      catch(val){
        print('caught $val');
      }
    }
  }

  Future<String> _routeTo() async {
    SettingsData settings = SettingsData();
    // we are making sure that if the user is already logged in at a time and i.e. sharedPreferences data exist
    // we move to the Main-navigation screen otherwise we move to the LoginScreen.
    //
    // This is the standard way of creating a splash-screen for an Application.
    if (settings.readFromShared! && settings.facebookId != '') {
      return MainNavigationScreen.routeName;
    } else {
      return LoginScreen.routeName;
    }
  }

  // loads in the shared preference.
  void _load() async {
    bool navigateToChatScreen = await _initializeApp();
    final routeTo = await _routeTo();


    if(!navigateToChatScreen){
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Get.offAllNamed(routeTo);
    });}
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: lightCardColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(BetaIconPaths.appLogoIcon),
            ),
            Text(
              'Swiper',
              style: mediumBoldedCharStyle.copyWith(color: colorBlend02),
            ),
          ],
        ),
      ),
    );
  }
}
