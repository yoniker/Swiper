import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class SmokingScreen extends StatefulWidget {
  static const String routeName = '/smoking_screen';
  final bool onboardingMode;
  const SmokingScreen({Key? key, this.onboardingMode = false})
      : super(key: key);

  @override
  _SmokingScreen createState() => _SmokingScreen();
}

class _SmokingScreen extends State<SmokingScreen> {
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
                    title: 'Smoking',
                  ),
            body: QuestionnaireWidget(
              headline: 'Do you smoke?',
              onboardingMode: widget.onboardingMode,
              choices: kSmokingChoices,
              initialChoice: SettingsData.instance.smoking,
              onValueChanged: (newSmokingVal) {
                SettingsData.instance.smoking = newSmokingVal;
              },
              onSave: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
