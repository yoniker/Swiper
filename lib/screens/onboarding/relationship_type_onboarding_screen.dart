import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/onboarding_pageview_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelationshipTypeOnboardingScreen extends StatefulWidget {
  static const String routeName = '/lookingForOnboardingScreen';
  final void Function()? onNext;

  const RelationshipTypeOnboardingScreen({Key? key, this.onNext})
      : super(key: key);

  @override
  _RelationshipTypeOnboardingScreenState createState() =>
      _RelationshipTypeOnboardingScreenState();
}

class _RelationshipTypeOnboardingScreenState
    extends State<RelationshipTypeOnboardingScreen> {
  String? currentChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackroundThemeColor,
      body: Column(
        children: [
          Expanded(
            child: QuestionnaireWidget(
                choices: kRelationshipTypeChoices,
                alwaysPressed: true,
                headline: 'What are you looking for?',
                subLine: 'This will help Voilà find you a suitable match',
                saveButtonName: 'Continue',
                onValueChanged: (newRelationshipType) {
                  setState(() {
                    currentChoice = newRelationshipType;
                  });
                },
                onSave: currentChoice != null
                    ? () {
                        SettingsData.instance.relationshipType = currentChoice!;
                        widget.onNext?.call();
                      }
                    : null),
          )
        ],
      ),
    );
  }
}
