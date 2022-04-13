import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PronounScreen extends StatefulWidget {
  static const String routeName = '/pronounScreen';

  const PronounScreen({Key? key}) : super(key: key);

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

    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 0),
              child: ProgressBar(
                page: 3,
              ),
            ),
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
                        Get.offAllNamed(OnboardingFlowController.instance
                            .nextRoute(PronounScreen.routeName));
                      }
                    : null,
              ),
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.black87),
              child: CheckboxListTile(
                  title: const Text(
                    'Show my gender on my profile',
                    style: kSmallInfoStyle,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  checkColor: Colors.white,
                  activeColor: Colors.black87,
                  tristate: false,
                  value: _showGender,
                  onChanged: (value) {
                    setState(() {
                      _showGender = value!;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
