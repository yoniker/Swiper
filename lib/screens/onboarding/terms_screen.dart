import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/get_name_screen.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
  static const String routeName = '/Terms';
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(30),
          child: ConditionalParentWidget(
            condition: ScreenSize.getSize(context) == ScreenSizeCategory.small,
            conditionalBuilder: (Widget child) => Scrollbar(
              isAlwaysShown: true,
              child: SingleChildScrollView(
                child: child,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText('Welcome to Voilà!',
                            colors: kColorizeColors,
                            textStyle: kTitleStyleBlack)
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'We are excited for you to join our community! \nBefore you swipe, please follow these guidelines:',
                      style: kSmallInfoStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Row(
                        children: const [
                          Text(
                            '✔',
                            style: kVstyle,
                          ),
                          Text(
                            '  No Catfishing.',
                            style: kSmallTitleBlack,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Use your own bio, age and photos',
                      style: kSmallInfoStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Row(
                        children: const [
                          Text(
                            '✔',
                            style: kVstyle,
                          ),
                          Text(
                            '  Respect.',
                            style: kSmallTitleBlack,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Treat others the same way you want to be treated.',
                      style: kSmallInfoStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Row(
                        children: const [
                          Text(
                            '✔',
                            style: kVstyle,
                          ),
                          Text(
                            '  Security.',
                            style: kSmallTitleBlack,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Keep your personal information to yourself. \nDont give your phone number too quickly!',
                      style: kSmallInfoStyle,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20, top: 20),
                      child: Text(
                        'And remember that we are here for you!',
                        style: kSmallInfoStyle,
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
                RoundedButton(
                  elvation: 0,
                  name: 'I Agree',
                  onTap: () {
                    Get.offAllNamed(GetNameScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
