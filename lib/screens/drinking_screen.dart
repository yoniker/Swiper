import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/choice_button.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class DrinkingScreen extends StatefulWidget {
  static const String routeName = '/drinking_screen';
  const DrinkingScreen({Key? key}) : super(key: key);

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
            backgroundColor: backgroundThemeColor,
            appBar: CustomAppBar(
              hasTopPadding: true,
              hasBackButton: true,
              showAppLogo: false,
              title: 'Drinking',
            ),
            body: QuestionnaireWidget(
                headline: 'How often do you drink?',
                choices: ['Frequently', 'Socially', 'Never']),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
