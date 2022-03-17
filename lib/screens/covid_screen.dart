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

class CovidScreen extends StatefulWidget {
  static const String routeName = '/covid_screen';
  const CovidScreen({Key? key}) : super(key: key);

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
            appBar: CustomAppBar(
              hasTopPadding: true,
              hasBackButton: true,
              showAppLogo: false,
              title: 'Covid Vaccine',
            ),
            body: RawScrollbar(
              isAlwaysShown: true,
              thumbColor: Colors.black54,
              thickness: 5,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  height: heightWithoutSafeArea - 38,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuestionnaireWidget(
                          headline: 'Test headline',
                          choices: [
                            'Fully vaccinated',
                            'Partially vaccinated',
                            'Not vaccinated'
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
