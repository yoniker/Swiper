import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrientationScreen extends StatefulWidget {
  static const String routeName = '/orientation_screen';

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  String? currentChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 0),
              child: ProgressBar(
                page: 4,
              ),
            ),
            Expanded(
              child: QuestionnaireWidget(
                choices: kIntoChoices,
                headline: 'Who are you interested in?',
                subLine: 'This can be changed later',
                saveButtonName: 'Continue',
                promotes: kPromotesForPreferredGender,
                onValueChanged: (newIntoValue) {
                  setState(() {
                    currentChoice = newIntoValue;
                  });
                },
                alwaysPressed: true,

                /// Must be true or user can continue
                onSave: currentChoice != null
                    ? () {
                        setState(() {
                          SettingsData.instance.preferredGender =
                              currentChoice!;
                          Get.offAllNamed(OnboardingFlowController.instance
                              .nextRoute(OrientationScreen.routeName));
                        });
                      }
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
