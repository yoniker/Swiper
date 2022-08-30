import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/screens/onboarding/tutorial_screen_starter.dart';
import 'package:betabeta/screens/pending_approvment_screen.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:betabeta/services/location_service.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/onboarding/welcome_screen.dart';
import 'package:betabeta/services/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    await SettingsData.instance.readSettingsFromShared();
    AppStateInfo.instance;
    await NotificationsController.instance.initialize();
    await ChatData.initDB(); //Initizalize DB, not side effects expected
    CelebsInfo.instance.getCelebsFromDatabase();
  }

  Future<void> _initAppAlreadyRegistered() async {
    //Stuff we want to do only if the user is already registered
    try{
    LocationService.instance.onInit();
    MatchEngine.instance;
    navigatedFromNotification = await ChatData.instance.onInitApp();
    await AWSServer.instance.updateUserStatusFromServer();}catch(_){}
  }

  Future<String> _chooseRoute() async {
    //Choose the next screen based on SettingsData info (shared preferences).

    await SettingsData.instance.readSettingsFromShared();
    if (SettingsData.instance.uid.length > 0 &&
        (SettingsData.instance.registrationStatus == RegistrationStatus.registeredNotApproved || SettingsData.instance.registrationStatus == RegistrationStatus.registeredApproved))
    //If the user is currently registered

     {
       if(SettingsData.instance.registrationStatus==RegistrationStatus.registeredApproved){
         if(SettingsData.instance.userWatchedMainTutorial)
            {return  MainNavigationScreen.routeName;}
         return TutorialScreenStarter.routeName;

       }
       return PendingApprovementScreen.routeName;
    }

    return WelcomeScreen.routeName;
  }

  // loads in the shared preference.
  void _load() async {
    try{await _initializeApp();}catch(_){}
    final routeTo = await _chooseRoute();
    print('the route which was chosen is $routeTo');
    if (routeTo == MainNavigationScreen.routeName || routeTo==PendingApprovementScreen.routeName || routeTo==TutorialScreenStarter.routeName) {
      await _initAppAlreadyRegistered();
    }

    if (!navigatedFromNotification) {
      Get.offAllNamed(routeTo);
    } //If notification exists, the assumption is that navigation was handled already.
    await NotificationsController.instance.cancelAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                width: sizeAnimation.value,
                child: Image.asset(BetaIconPaths.inactiveVoilaTabIconPath),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                BetaIconPaths.logoTextFile,
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
