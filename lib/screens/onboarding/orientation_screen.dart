import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/relationship_type_onboarding_screen.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Choice { men, women, everyone }

class OrientationScreen extends StatefulWidget {
  static String routeName = '/orientation_screen';

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  Choice? currentChoice;
  String whatWeShowText = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressBar(
                  page: 4,
                ),
                const Text(
                  'Who are you interested in?',
                  style: kTitleStyle,
                ),
                const SizedBox(height: 10),
                const Text('This can be changed later', style: kSmallInfoStyle),
                const SizedBox(height: 30),
                ChoiceButton(
                  name: 'Men',
                  onTap: () {
                    setState(() {
                      currentChoice = Choice.men;
                      whatWeShowText = 'We will only show you men';
                    });
                  },
                  pressed: currentChoice == Choice.men ? true : false,
                ),
                const SizedBox(height: 20),
                ChoiceButton(
                  name: 'Women',
                  onTap: () {
                    setState(() {
                      currentChoice = Choice.women;
                      whatWeShowText = 'We will only show you women';
                    });
                  },
                  pressed: currentChoice == Choice.women ? true : false,
                ),
                const SizedBox(height: 20),
                ChoiceButton(
                  name: 'Everyone',
                  onTap: () {
                    setState(() {
                      currentChoice = Choice.everyone;
                      whatWeShowText = 'We will show you everyone';
                    });
                  },
                  pressed: currentChoice == Choice.everyone ? true : false,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Row(
                    children: [
                      currentChoice != null
                          ? const Icon(Icons.remove_red_eye_rounded,
                              color: Colors.black54)
                          : const SizedBox(),
                      const SizedBox(width: 10),
                      Text(whatWeShowText, style: kSmallInfoStyle),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RoundedButton(
                    name: 'CONTINUE',
                    onTap: currentChoice != null
                        ? () {
                            Get.offAllNamed(
                                RelationshipTypeOnboardingScreen.routeName);
                          }
                        : null),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
