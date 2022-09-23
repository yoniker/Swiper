import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class DrinkingScreen extends StatefulWidget {
  static const String routeName = '/drinking_screen';
  final bool onboardingMode;
  const DrinkingScreen({Key? key, this.onboardingMode = false})
      : super(key: key);

  @override
  _DrinkingScreen createState() => _DrinkingScreen();
}

class _DrinkingScreen extends State<DrinkingScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
        notifier: SettingsData.instance,
        builder: (context) {
          return Scaffold(
            backgroundColor: kBackroundThemeColor,
            appBar: widget.onboardingMode
                ? null
                : CustomAppBar(
                    hasTopPadding: true,
                    hasBackButton: true,
                    title: 'Drinking',
                  ),
            body: QuestionnaireWidget(
              onboardingMode: widget.onboardingMode,
              headline: 'How often do you drink?',
              choices: ['Frequently', 'Socially', 'Never'],
              initialChoice: SettingsData.instance.drinking,
              onValueChanged: (newDrinkingValue) {
                SettingsData.instance.drinking = newDrinkingValue;
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
