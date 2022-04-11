import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class LookingForScreen extends StatefulWidget {
  static const String routeName = '/looking_for_screen';
  const LookingForScreen({Key? key}) : super(key: key);

  @override
  State<LookingForScreen> createState() => _LookingForScreenState();
}

class _LookingForScreenState extends State<LookingForScreen> {
  @override
  void initState() {
    print(
      SettingsData.instance.relationshipType,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        return Scaffold(
          appBar: CustomAppBar(
            hasTopPadding: true,
            hasBackButton: true,
            title: 'Looking for',
          ),
          backgroundColor: kBackroundThemeColor,
          body: QuestionnaireWidget(
            choices: ['Marriage', 'Relationship', 'Casual', 'Not sure'],
            headline: 'What are you looking for?',
            onValueChanged: (newLookingFor) {
              SettingsData.instance.relationshipType = newLookingFor;
            },
            alwaysPressed: true,
            initialChoice: SettingsData.instance.relationshipType,
            onSave: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
