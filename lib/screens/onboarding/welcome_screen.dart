import 'dart:io';

import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/models/loginService.dart';
import 'package:betabeta/screens/onboarding/phone_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/services/chat_networking.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/loading_indicator.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;
  bool currentlyTryingToLogin = false;

  _continueIfLoggedIn() async {
    await SettingsData.instance.readSettingsFromShared();
    if (SettingsData.instance.readFromShared! &&
        SettingsData.instance.uid.length > 0) {
      Get.offAllNamed(
          OnboardingFlowController.nextRoute(WelcomeScreen.routeName));
    }
  }

  void skipLogin(
      //This function is so that development won't be hindered by the existence of onboarding

      ) {
    SettingsData.instance.uid = Random().nextInt(999999).toString();
    SettingsData.instance.name = 'Lamer Admin';
    SettingsData.instance.userDescription = 'Lamer was fed by Tzippi';
    Get.offAllNamed(MainNavigationScreen.routeName);
  }

  Future<void> _saveUid() async {
    var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String serverUid =
        await ChatNetworkHelper.registerUid(firebaseIdToken: idToken!);
    //TODO support existing accounts : check with the server if the uid already existed,and if so load the user's details from the server
    if (uid != serverUid) {
      print(
          'The uid in server is different from client, something weird is going on!');
      //TODO something about it?
    }
    SettingsData.instance.uid = uid;
    print('Registered the uid $uid');
  }

  _tryLoginFacebook() async {
    setState(() {
      currentlyTryingToLogin = true;
    });
    await LoginsService.instance.tryLoginFacebook();
    if (LoginsService.instance.facebookLoginState == LoginState.Success) {
      await LoginsService.instance.getFacebookUserData();
      await LoginsService.signInUser(
          credential: LoginsService.instance.facebookCredential!);
      await _saveUid();
      await _continueIfLoggedIn();
    }
    setState(() {
      currentlyTryingToLogin = false;
    });
  }

  @override
  void initState() {
    _controller =
        VideoPlayerController.asset('assets/onboarding/videos/startedit.mp4')
          ..initialize().then((_) {
            _controller.play();
            _controller.setLooping(true);
            setState(() {});
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.getSize(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black87,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        currentlyTryingToLogin == true
            ? LoadingIndicator()
            : Container(
                height: double.infinity,
                width: double.infinity,
                decoration: kDarkToTransTheme,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConditionalParentWidget(
                      condition: ScreenSize.getSize(context) ==
                          ScreenSizeCategory.small,
                      conditionalBuilder: (Widget child) => FittedBox(
                        child: child,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/onboarding/images/Voila-logo.png',
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: screenHeight * 0.03,
                          left: screenWidth * 0.06,
                          right: screenWidth * 0.06),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.values[1],
                        children: [
                          RoundedButton(
                            name: 'Continue with Facebook',
                            showBorder: false,
                            icon: Icons.facebook_rounded,
                            color: const Color(0xFF0060DB),
                            onTap: () async {
                              setState(() {
                                currentlyTryingToLogin = true;
                              });
                              await _tryLoginFacebook();
                              setState(() {
                                currentlyTryingToLogin = false;
                              });
                              //TODO show indication to user if login wasn't successful
                            },
                          ),
                          if (Platform.isIOS)
                            const SizedBox(
                              height: 20,
                            ),
                          if (Platform.isIOS)
                            RoundedButton(
                                name: 'Continue with Apple      ',
                                showBorder: false,
                                color: Colors.white,
                                onTap: () {
                                  //TODO Apple login logic
                                  Get.offAllNamed(
                                      OnboardingFlowController.nextRoute(
                                          WelcomeScreen.routeName));
                                },
                                icon: Icons.apple_rounded),
                          SizedBox(
                            height: 20,
                          ),
                          RoundedButton(
                              name: 'Continue with phone      ',
                              icon: Icons.phone_android,
                              color: Colors.transparent,
                              onTap: () {
                                Get.offAllNamed(
                                    OnboardingFlowController.nextRoute(
                                        PhoneScreen.routeName));
                              }),
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  "Don't worry! We never post to Facebook.",
                                  style: kSmallInfoStyleWhite,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Text(
                                        'Terms of Service',
                                        style: kSmallInfoStyleUnderlineWhite,
                                      ),
                                      onTap: () {
                                        skipLogin();
                                      },
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      'Privacy Policy',
                                      style: kSmallInfoStyleUnderlineWhite,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
