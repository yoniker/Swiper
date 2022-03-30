import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class OrientationEditScreen extends StatefulWidget {
  static const String routeName = '/orientation_edit_screen';

  @override
  _OrientationEditScreenState createState() => _OrientationEditScreenState();
}

class _OrientationEditScreenState extends State<OrientationEditScreen> {
  PreferredGender? currentChoice;
  String whatWeShowText = '';
  List<String> promotes = [
    'We will only show you men',
    'We will only show you women',
    'We will show you everyone'
  ];

  updateText() {
    if (SettingsData.instance.preferredGender == PreferredGender.Men.name) {
      whatWeShowText = 'We will only show you men';
    } else if (SettingsData.instance.preferredGender ==
        PreferredGender.Women.name) {
      whatWeShowText = 'We will only show you women';
    } else {
      whatWeShowText = 'We will show you everyone';
    }
  }

  @override
  void initState() {
    updateText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        showAppLogo: false,
        title: 'Interested in',
      ),
      backgroundColor: kBackroundThemeColor,
      body: QuestionnaireWidget(
        choices: ['Men', 'Women', 'Everyone'],
        headline: 'Interested in?',
        promotes: promotes,
        onValueChanged: (newPrefferedGender) {
          SettingsData.instance.preferredGender = newPrefferedGender;
        },
        alwaysPressed: true,
        initialChoice: SettingsData.instance.preferredGender,
      ),
    );
  }
}
