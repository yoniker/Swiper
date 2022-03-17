import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrientationScreen extends StatefulWidget {
  static const String routeName = '/orientation_screen';

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  PreferredGender? currentChoice;
  String whatWeShowText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: SafeArea(
        child: Padding(
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
                  const Text('This can be changed later',
                      style: kSmallInfoStyle),
                  const SizedBox(height: 30),
                  ChoiceButton(
                    name: 'Men',
                    onTap: () {
                      setState(() {
                        currentChoice = PreferredGender.Men;
                        whatWeShowText = 'We will only show you men';
                      });
                    },
                    pressed:
                        currentChoice == PreferredGender.Men ? true : false,
                  ),
                  const SizedBox(height: 20),
                  ChoiceButton(
                    name: 'Women',
                    onTap: () {
                      setState(() {
                        currentChoice = PreferredGender.Women;
                        whatWeShowText = 'We will only show you women';
                      });
                    },
                    pressed:
                        currentChoice == PreferredGender.Women ? true : false,
                  ),
                  const SizedBox(height: 20),
                  ChoiceButton(
                    name: 'Everyone',
                    onTap: () {
                      setState(() {
                        currentChoice = PreferredGender.Everyone;
                        whatWeShowText = 'We will show you everyone';
                      });
                    },
                    pressed: currentChoice == PreferredGender.Everyone
                        ? true
                        : false,
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
                              SettingsData.instance.preferredGender =
                                  currentChoice!.name;
                              Get.offAllNamed(
                                  OnboardingFlowController.nextRoute(
                                      OrientationScreen.routeName));
                              ;
                            }
                          : null),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
