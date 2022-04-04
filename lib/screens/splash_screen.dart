import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/app_state_info.dart';
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
  bool navigatedFromNotification = false;
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

  Future<void> _initializeApp() async {
    //initialize the app when user is already logged in
    AppStateInfo.instance;
    await NotificationsController.instance.initialize();
    await ChatData.initDB();
    await SettingsData.instance.readSettingsFromShared();
    await CelebsInfo.instance.getCelebsFromDatabase();

  }

  Future<void> _initAppAlreadyRegistered() async{
    //Stuff we want to do only if the user is already registered

    MatchEngine.instance;
    navigatedFromNotification = await ChatData.instance.onInitApp();
  }



  Future<String> _chooseRoute() async {
    
    // we are making sure that if the user is already logged in at a time and i.e. sharedPreferences data exist
    // we move to the Main-navigation screen otherwise we move to the LoginScreen.
    
    await SettingsData.instance.readSettingsFromShared();
    if (SettingsData.instance.uid.length>0 && SettingsData.instance.registrationStatus==API_CONSTS.ALREADY_REGISTERED) {
      return MainNavigationScreen.routeName;
    }

    return WelcomeScreen.routeName;
  }

  // loads in the shared preference.
  void _load() async {
    final routeTo = await _chooseRoute();
    try {
      await _initializeApp();
      if (routeTo == MainNavigationScreen.routeName) {
        await _initAppAlreadyRegistered();
      }
    }
    catch (e) {
      print('There was an error at initialization $e');
    }

    if (!navigatedFromNotification) {
      Get.offAllNamed(routeTo);
    } //If notification exists, the assumption is that navigation was handled already.
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
