import 'dart:async';

import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AboutMeOnboardingScreen extends StatefulWidget {
  static const String routeName = '/aboutMeOnboardingScreen';
  static const int minWordsInDescription = 5;
  final void Function()? onNext;

  const AboutMeOnboardingScreen({Key? key, this.onNext}) : super(key: key);

  @override
  _AboutMeOnboardingScreenState createState() =>
      _AboutMeOnboardingScreenState();
}

class _AboutMeOnboardingScreenState extends State<AboutMeOnboardingScreen> {
  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  String aboutMeText = '';
  bool clickOnDisable = false;
  Timer? _debounce;
  int _count = 0;
  TextDirection? textDirectionAboutMe = TextDirection.ltr;

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBackroundThemeColor,
        body: RawScrollbar(
          thumbColor: Colors.black54,
          thickness: 5,
          thumbVisibility: true,
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
                                    FocusScope.of(context).unfocus();
                                    widget.onNext?.call();
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
                              setState(() {
                                if (isRTL(aboutMeText)) {
                                  textDirectionAboutMe = TextDirection.rtl;
                                } else {
                                  textDirectionAboutMe = TextDirection.ltr;
                                }
                              });

                              final RegExp regExp = textDirectionAboutMe ==
                                      TextDirection.rtl
                                  ? RegExp(
                                      r"[^\x00-\x7F\u00E2\u00E4\u00E8\u00E9\u00EA\u00EB\u00EE\u00EF\u00F4\u0153\u00F9\u00FB\u00FC\u00FF\u00E7\u00C0\u00C2\u00C4\u00C8\u00C9\u00CA\u00CB\u00CE\u00CF\u00D4\u0152\u00D9\u00DB\u00DC\u0178\u00C7]+")
                                  : RegExp(r"[\w-._]+");

                              final Iterable matches = regExp.allMatches(value);
                              _count = matches.length;

                              print(textDirectionAboutMe);
                            },
                            textDirection: textDirectionAboutMe,
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
                                    FocusScope.of(context).unfocus();
                                    widget.onNext?.call();
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
