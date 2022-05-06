import 'dart:async';

import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class AboutMeOnboardingScreen extends StatefulWidget {
  static const String routeName = '/aboutMeOnboardingScreen';
  static const int minWordsInDescription = 10;

  const AboutMeOnboardingScreen({Key? key}) : super(key: key);

  @override
  _AboutMeOnboardingScreenState createState() =>
      _AboutMeOnboardingScreenState();
}

class _AboutMeOnboardingScreenState extends State<AboutMeOnboardingScreen> {
  String aboutMeText = '';
  bool clickOnDisable = false;
  Timer? _debounce;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    void alertUserMinimumText() {
      setState(() {
        clickOnDisable = true;
      });
      _debounce = Timer(Duration(seconds: 4), () {
        setState(() {
          clickOnDisable = false;
        });
      });
    }

    int wordsLeft = AboutMeOnboardingScreen.minWordsInDescription - (_count);

    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: SafeArea(
        child: RawScrollbar(
          thumbColor: Colors.black54,
          thickness: 5,
          isAlwaysShown: true,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 10),
                            child: ProgressBar(
                              totalProgressBarPages: kTotalProgressBarPages,
                              page: 7,
                            ),
                          ),
                          const Text(
                            'Tell others about yourself',
                            style: kTitleStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'People love to see a bio that describe who you are.',
                            style: kSmallInfoStyle,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          InputField(
                            onTapIcon: _count <
                                    AboutMeOnboardingScreen
                                        .minWordsInDescription
                                ? null
                                : () {
                                    SettingsData.instance.userDescription =
                                        aboutMeText;
                                    Get.offAllNamed(OnboardingFlowController
                                        .instance
                                        .nextRoute(
                                            AboutMeOnboardingScreen.routeName));
                                  },
                            onTapIconDisable: wordsLeft <= 0
                                ? null
                                : () {
                                    alertUserMinimumText();
                                  },
                            iconHeight: 110,
                            icon: Icons.send,
                            onType: (value) {
                              aboutMeText = value;
                              final RegExp regExp = new RegExp(r"[\w-._]+");
                              final Iterable matches = regExp.allMatches(value);
                              _count = matches.length;
                              setState(() {});
                            },
                            maxCharacters: 500,
                            keyboardType: TextInputType.multiline,
                            maxLines: 15,
                            minLines: 5,
                            hintText:
                                'Write something interesting about yourself',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              _count >=
                                      AboutMeOnboardingScreen
                                          .minWordsInDescription
                                  ? ''
                                  : 'Minimum ${wordsLeft} words left',
                              style: clickOnDisable != true
                                  ? kSmallInfoStyle
                                  : kSmallInfoStyleAlert,
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          alertUserMinimumText();
                        },
                        child: RoundedButton(
                            name: 'CONTINUE',
                            onTap: _count <
                                    AboutMeOnboardingScreen
                                        .minWordsInDescription
                                ? null
                                : () {
                                    SettingsData.instance.userDescription =
                                        aboutMeText;
                                    Get.offAllNamed(OnboardingFlowController
                                        .instance
                                        .nextRoute(
                                            AboutMeOnboardingScreen.routeName));
                                  }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    super.dispose();
  }
}
