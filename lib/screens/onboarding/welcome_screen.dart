import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/models/loginService.dart';
import 'package:betabeta/screens/onboarding/phone_screen.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/onboarding/videos/start4.mp4')
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: kDarkToTransTheme,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConditionalParentWidget(
                  condition: ScreenSize.getSize(context) == ScreenSizeCategory.small,
                  conditionalBuilder: (Widget child) => FittedBox(
                    child: child,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/onboarding/images/Voila-logo.png',
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                      ),
                    ],
                  ),
                ),
                ConditionalParentWidget(
                  condition:
                  ScreenSize.getSize(context) == ScreenSizeCategory.small,
                  conditionalBuilder: (Widget child) => FittedBox(
                    child: child,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: screenHeight * 0.03,
                        left: screenWidth * 0.06,
                        right: screenWidth * 0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.values[1],
                      children: [
                        RoundedButton(
                          name: 'Continue with Facebook',
                          icon: Icons.facebook_rounded,
                          color: const Color(0xFF0060DB),
                          onTap: ()  async{
                            await LoginsService.instance.tryLoginFacebook();
                            if(LoginsService.instance.facebookLoginState==LoginState.Success){
                              await LoginsService.instance.getFacebookUserData();
                              Get.offAllNamed(PhoneScreen.routeName);
                            }
                            //TODO if not successful,show something to the user

                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundedButton(
                            name: 'Continue with Apple',
                            color: Colors.white,
                            onTap: () {
                              //TODO Apple login logic
                              Get.offAllNamed(PhoneScreen.routeName);
                            },
                            icon: Icons.apple_rounded),
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
                                children: const [
                                  Text(
                                    'Terms of Service',
                                    style: kSmallInfoStyleUnderlineWhite,
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
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
