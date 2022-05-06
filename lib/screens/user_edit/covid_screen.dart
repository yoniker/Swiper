import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/questionnaire_widget.dart';
import 'package:flutter/material.dart';

class CovidScreen extends StatefulWidget {
  static const String routeName = '/covid_screen';
  final bool onboardingMode;
  const CovidScreen({Key? key, this.onboardingMode = false}) : super(key: key);

  @override
  State<CovidScreen> createState() => _CovidScreenState();
}

class _CovidScreenState extends State<CovidScreen> {
  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

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
                    title: 'Covid Vaccine',
                  ),
            body: QuestionnaireWidget(
              onboardingMode: widget.onboardingMode,
              headline: 'Are you Covid-19 vaccinated?',
              choices: [
                'Fully vaccinated',
                'Partially vaccinated',
                'Not vaccinated'
              ],
              initialChoice: SettingsData.instance.covid_vaccine,
              onValueChanged: (newCovidValue) {
                SettingsData.instance.covid_vaccine = newCovidValue;
              },
              onSave: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }
}
