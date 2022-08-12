import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialScreenStarter extends StatefulWidget {
  const TutorialScreenStarter({Key? key}) : super(key: key);
  static const String routeName = '/tutorial_screen_starter';

  @override
  State<TutorialScreenStarter> createState() => _TutorialScreenStarterState();
}

class _TutorialScreenStarterState extends State<TutorialScreenStarter>
    with SingleTickerProviderStateMixin {
  late Timer? timer;
  late AnimationController _controller;
  late Animation _animation;
  late Animation _secondAnimation;
  late Animation _thirdAnimation;

  static int time = 0;

  @override
  void initState() {
    SettingsData.instance.userWatchedMainTutorial=true;
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (timer.isActive)
        setState(() {
          time = time + 100;
        });
      if (time > 6500) {
        timer.cancel();
        time = 0;
        Get.offAllNamed(MainNavigationScreen.routeName, arguments: true);
      }
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1, 0.2, curve: Curves.fastOutSlowIn),
      ),
    );
    _secondAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.18, 0.28, curve: Curves.fastOutSlowIn),
      ),
    );
    _thirdAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.45, curve: Curves.fastOutSlowIn),
      ),
    );
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: _controller.isCompleted ? 0 : 1,
                              child: SafeArea(
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
                                                pause:
                                                    Duration(milliseconds: 1),
                                                animatedTexts: [
                                                  ColorizeAnimatedText(
                                                    'Welcome',
                                                    speed: Duration(seconds: 2),
                                                    textStyle: colorizeTextStyle
                                                        .copyWith(fontSize: 30),
                                                    colors: colorizeColors,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 00,
                                          ),
                                          SizedBox(
                                            height: _secondAnimation.value * 33,
                                            child: FittedBox(
                                              child: AnimatedTextKit(
                                                pause:
                                                    Duration(milliseconds: 1),
                                                isRepeatingAnimation: true,
                                                repeatForever: true,
                                                animatedTexts: [
                                                  ColorizeAnimatedText(
                                                    'to',
                                                    textStyle:
                                                        colorizeTextStyle
                                                            .copyWith(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Yantramanav',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                    speed: Duration(seconds: 2),
                                                    colors: colorizeColors,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: _thirdAnimation.value * 66,
                                            child: FittedBox(
                                              child: AnimatedTextKit(
                                                pause:
                                                    Duration(milliseconds: 1),
                                                isRepeatingAnimation: true,
                                                repeatForever: true,
                                                animatedTexts: [
                                                  ColorizeAnimatedText(
                                                    'Voilà!',
                                                    textStyle: colorizeTextStyle
                                                        .copyWith(fontSize: 20),
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
                                    // SizedBox(
                                    //   height: 120,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            // Container(
                            //   child: Stack(
                            //     alignment: AlignmentDirectional.center,
                            //     children: [
                            //       AnimatedOpacity(
                            //         duration: Duration(milliseconds: 300),
                            //         opacity: time > 6500 && time < 9000 ? 1 : 0,
                            //         child: Text(
                            //           "Voilà is different than other apps",
                            //           style: LargeTitleStyleWhite.copyWith(
                            //               color: Colors.redAccent),
                            //           maxLines: 3,
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //       AnimatedOpacity(
                            //         duration: Duration(milliseconds: 300),
                            //         opacity:
                            //             time > 9500 && time < 12000 ? 1 : 0,
                            //         child: Text(
                            //           "Let's go over the basics",
                            //           style: LargeTitleStyleWhite.copyWith(
                            //               color: Colors.redAccent),
                            //           maxLines: 3,
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
