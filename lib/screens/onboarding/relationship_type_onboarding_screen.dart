import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelationshipTypeOnboardingScreen extends StatefulWidget {
  static const String routeName = '/lookingForOnboardingScreen';

  const RelationshipTypeOnboardingScreen({Key? key}) : super(key: key);

  @override
  _RelationshipTypeOnboardingScreenState createState() =>
      _RelationshipTypeOnboardingScreenState();
}

class _RelationshipTypeOnboardingScreenState
    extends State<RelationshipTypeOnboardingScreen> {
  bool? _showOnProfile = true;
  RelationshipPreference? currentChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: OnboardingColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressBar(
                  page: 5,
                ),
                FittedBox(
                  child: const Text(
                    'What are you looking for?',
                    maxLines: 2,
                    style: kTitleStyle,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'This will help Voilà find you suitable matches',
                  style: kSmallInfoStyle,
                ),
                const SizedBox(
                  height: 30,
                ),
                ChoiceButton(
                  name: 'Relationship',
                  onTap: () {
                    setState(() {
                      currentChoice = RelationshipPreference.relationship;
                    });
                  },
                  pressed: currentChoice == RelationshipPreference.relationship
                      ? true
                      : false,
                ),
                const SizedBox(height: 20),
                ChoiceButton(
                  name: 'Something casual',
                  onTap: () {
                    setState(() {
                      currentChoice = RelationshipPreference.casual;
                    });
                  },
                  pressed: currentChoice == RelationshipPreference.casual
                      ? true
                      : false,
                ),
                const SizedBox(height: 20),
                ChoiceButton(
                  name: 'I\'m not sure',
                  onTap: () {
                    setState(() {
                      currentChoice = RelationshipPreference.notSure;
                    });
                  },
                  pressed: currentChoice == RelationshipPreference.notSure
                      ? true
                      : false,
                ),
                const SizedBox(height: 20),
                ChoiceButton(
                  name: 'Prefer not to say',
                  onTap: () {
                    setState(() {
                      currentChoice = RelationshipPreference.marriage;
                    });
                  },
                  pressed: currentChoice == RelationshipPreference.marriage
                      ? true
                      : false,
                ),
              ],
            ),
            Column(
              children: [
                ScreenSize.getSize(context) == ScreenSizeCategory.small
                    ? const FittedBox()
                    : Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.black87),
                        child: CheckboxListTile(
                            title: const Text(
                              'Show this on my profile',
                              style: kSmallInfoStyle,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            checkColor: Colors.white,
                            activeColor: Colors.black87,
                            tristate: false,
                            value: _showOnProfile,
                            onChanged: (value) {
                              setState(() {
                                _showOnProfile = value;
                              });
                            }),
                      ),
                RoundedButton(
                    name: 'CONTINUE',
                    onTap: currentChoice != null
                        ? () {
                            SettingsData.instance.relationshipType =
                                currentChoice!.name;
                            Get.offAllNamed(OnboardingFlowController.nextRoute(
                                RelationshipTypeOnboardingScreen.routeName));
                          }
                        : null)
              ],
            )
          ],
        ),
      ),
    );
  }
}
