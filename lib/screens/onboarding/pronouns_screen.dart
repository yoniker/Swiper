import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/onboarding_pageview_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PronounScreen extends StatefulWidget {
  static const String routeName = '/pronounScreen';
  final void Function()? onNext;

  const PronounScreen({Key? key, this.onNext}) : super(key: key);

  @override
  _PronounScreenState createState() => _PronounScreenState();
}

class _PronounScreenState extends State<PronounScreen> {
  void saveSelectedGender() {
    SettingsData.instance.showUserGender = _showGender;
    SettingsData.instance.userGender = elseGender;
  }

  Gender? selectedGender;

  bool _showGender = false;
  String elseGender = '';

  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBackroundThemeColor,
        body: Column(
          children: [
            Expanded(
              child: QuestionnaireWidget(
                choices: kGenderChoices,
                saveButtonName: 'Continue',
                headline: 'How do you identify?',
                subLine: 'We welcome anyone to Voilà!',
                bottomPadding: false,
                extraUserChoice: true,
                alwaysPressed: true,
                onValueChanged: (newValue) {
                  setState(() {
                    elseGender = newValue;
                    print(elseGender);
                  });
                },
                onSave: elseGender.length != 0
                    ? () {
                        saveSelectedGender();
                        FocusScope.of(context).unfocus();
                        widget.onNext?.call();
                      }
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Show my gender on my profile',
                      style: kSmallInfoStyle,
                      maxLines: 1,
                    ),
                  ),
                  Switch(
                    value: SettingsData.instance.showUserGender,
                    onChanged: (newValue) {
                      setState(() {
                        SettingsData.instance.showUserGender = newValue;
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
