import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class EducationScreen extends StatefulWidget {
  static const String routeName = '/education_screen';
  final bool onboardingMode;
  const EducationScreen({Key? key, this.onboardingMode = false})
      : super(key: key);

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
        notifier: SettingsData.instance,
        builder: (context) {
          return Scaffold(
            backgroundColor: backgroundThemeColor,
            appBar: widget.onboardingMode
                ? null
                : CustomAppBar(
                    hasTopPadding: true,
                    hasBackButton: true,
                    title: 'Education level',
                  ),
            body: QuestionnaireWidget(
              choices: kEducationChoices,
              headline: 'What is your education level?',
              onboardingMode: widget.onboardingMode,
              initialChoice: SettingsData.instance.education,
              onValueChanged: (newEducationValue) {
                SettingsData.instance.education = newEducationValue;
              },
              onSave: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }
}
