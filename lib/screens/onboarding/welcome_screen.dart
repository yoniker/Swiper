import 'dart:io';

import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/constants/url-consts.dart';
import 'package:betabeta/screens/onboarding/onboarding_pageview_screen.dart';
import 'package:betabeta/screens/onboarding/phone_screen.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/loginService.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/loading_indicator.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;
  bool currentlyTryingToLogin = false;

  _continueIfLoggedIn(ServerRegistrationStatusResponse currentStatus) async {
    await SettingsData.instance.readSettingsFromShared();

    if (SettingsData.instance.readFromShared! &&
        !(SettingsData.instance.uid.length > 0)) {
      print('THERE IS NO UID AT CONTINUE IF LOGGED IN, SO NOT LOGGING IN...');
      return;
    }

    Get.offAllNamed(OnboardingPageViewScreen.routeName,
        arguments: currentStatus);
  }

  Future<ServerRegistrationStatusResponse> _registerUserAtServer() async {
    var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    ServerRegistrationStatusResponse currentRegistrationStatus =
        await AWSServer.instance.registerUid(firebaseIdToken: idToken!);
    return currentRegistrationStatus;
  }

  _tryFacebookLogin() async {
    setState(() {
      currentlyTryingToLogin = true;
    });
    await LoginsService.instance.tryLoginFacebook();

    if (LoginsService.instance.facebookLoginState == LoginState.Success) {
      await LoginsService.instance.getFacebookUserData();

      print(LoginsService.instance.facebookCredential!);
      await LoginsService.signInUser(
          credential: LoginsService.instance.facebookCredential!);

      ServerRegistrationStatusResponse currentServerRegistrationStatusResponse =
          await _registerUserAtServer();
      await _continueIfLoggedIn(currentServerRegistrationStatusResponse);
    }
    setState(() {
      currentlyTryingToLogin = false;
    });
  }

  _tryAppleLogin() async {
    setState(() {
      currentlyTryingToLogin = true;
    });
    UserCredential? credential = await LoginsService.instance.signInWithApple();
    if (credential != null) {
      //TODO replace condition with "apple login failed".
      ServerRegistrationStatusResponse currentServerRegistrationStatus =
          await _registerUserAtServer();
      await _continueIfLoggedIn(currentServerRegistrationStatus);
    }
    setState(() {
      currentlyTryingToLogin = false;
    });
  }

  _tryPhoneLogin() async {
    setState(() {
      currentlyTryingToLogin = true;
    });
    var credential = await Get.toNamed(PhoneScreen.routeName, arguments: true);
    if (credential != null) {
      //TODO replace condition with "phone login failed".
      ServerRegistrationStatusResponse currentServerRegistrationStatus =
          await _registerUserAtServer();
      await _continueIfLoggedIn(currentServerRegistrationStatus);
    }
    setState(() {
      currentlyTryingToLogin = false;
    });
  }

  @override
  void initState() {
    _controller = VideoPlayerController.asset(AssetsPaths.backgroundVideoPath)
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
              width: _controller.value.size.width,
              height: _controller.value.size.height,
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
                      child: SafeArea(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Column(
                              children: [
                                Image.asset(
                                  BetaIconPaths.activeVoilaTabIconPath,
                                  scale: 4,
                                ),
                                Text(
                                  'Voilà - dating',
                                  style: LargeTitleStyleWhite,
                                  // style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 30,
                                  //     fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
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
                              await _tryFacebookLogin();
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
                                onTap: () async {
                                  //TODO Apple login logic
                                  _tryAppleLogin();

                                  // Get.offAllNamed(OnboardingFlowController
                                  //     .instance
                                  //     .nextRoute(WelcomeScreen.routeName));
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
                                _tryPhoneLogin();
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
                                    TextButton(
                                      child: Text(
                                        'Terms of Service',
                                        style: kSmallInfoStyleUnderlineWhite,
                                      ),
                                      onPressed: () async {
                                        final url = privacyPolicyUrl;
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        }
                                      },
                                    ),
                                    SizedBox(width: 20),
                                    TextButton(
                                      onPressed: () async {
                                        final url = privacyPolicyUrl;
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        }
                                      },
                                      child: Text(
                                        'Privacy Policy',
                                        style: kSmallInfoStyleUnderlineWhite,
                                      ),
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
