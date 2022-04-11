import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class FitnessScreen extends StatefulWidget {
  static const String routeName = '/fitness_screen';
  const FitnessScreen({Key? key}) : super(key: key);

  @override
  _FitnessScreen createState() => _FitnessScreen();
}

class _FitnessScreen extends State<FitnessScreen> {
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
                title: 'Fitness',
              ),
              body: QuestionnaireWidget(
                headline: 'How often do you work out?',
                choices: kFitnessChoices,
                initialChoice: SettingsData.instance.fitness,
                onValueChanged: (newFitnessValue) {
                  SettingsData.instance.fitness = newFitnessValue;
                },
                onSave: () {
                  Navigator.pop(context);
                },
              ));
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
