import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/onboarding_pageview_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrientationScreen extends StatefulWidget {
  static const String routeName = '/orientation_screen';
  final void Function()? onNext;

  OrientationScreen({this.onNext});

  @override
  State<OrientationScreen> createState() => _OrientationScreenState();
}

class _OrientationScreenState extends State<OrientationScreen> {
  String? currentChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: Column(
        children: [
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
                        SettingsData.instance.preferredGender = currentChoice!;
                        widget.onNext?.call();
                      });
                    }
                  : null,
            ),
          )
        ],
      ),
    );
  }
}
