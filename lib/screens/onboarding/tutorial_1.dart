import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/finish_onboarding_screen.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({Key? key}) : super(key: key);
  static const String routeName = '/tutorial_1';

  @override
  State<Tutorial1> createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation _secondAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1, curve: Curves.fastOutSlowIn),
      ),
    );
    _secondAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1, curve: Curves.fastOutSlowIn),
      ),
    );
    Duration(seconds: 5);
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressBar(
                      totalProgressBarPages: kTotalProgressBarPages,
                      page: 9,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const FittedBox(
                      child: Text(
                        "Let's have a look at how Voilà works:",
                        style: kTitleStyle,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: _animation.value * 32,
                              child: FittedBox(
                                child: AnimatedTextKit(
                                  isRepeatingAnimation: true,
                                  repeatForever: true,
                                  pause: Duration(milliseconds: 1),
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                      'Welcome to',
                                      speed: Duration(seconds: 2),
                                      textStyle: colorizeTextStyle.copyWith(
                                          fontSize: 30),
                                      colors: colorizeColors,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: _secondAnimation.value * 66,
                              child: FittedBox(
                                child: AnimatedTextKit(
                                  pause: Duration(milliseconds: 1),
                                  isRepeatingAnimation: true,
                                  repeatForever: true,
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                      'Voilà!',
                                      textStyle: colorizeTextStyle.copyWith(
                                          fontSize: 20),
                                      speed: Duration(seconds: 2),
                                      colors: colorizeColors,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 120,
                      ),
                    ],
                  ),
                ),
                RoundedButton(
                  name: 'NEXT',
                  onTap: () {
                    Get.toNamed(FinishOnboardingScreen.routeName);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
