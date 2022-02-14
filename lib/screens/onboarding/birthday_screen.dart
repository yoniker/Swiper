import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/onboarding/get_name_screen.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/screens/onboarding/pronouns_screen.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BirthdayOnboardingScreen extends StatefulWidget {
  static const String routeName = '/birthday_onboarding';

  const BirthdayOnboardingScreen({Key? key}) : super(key: key);

  @override
  _BirthdayOnboardingScreenState createState() =>
      _BirthdayOnboardingScreenState();
}

class _BirthdayOnboardingScreenState extends State<BirthdayOnboardingScreen> {
  DateTime selectedDate = SettingsData.instance.userBirthday.length>0?DateTime.parse(SettingsData.instance.userBirthday):DateTime(2000, 1, 1); //TODO take the user's birthday if given (for example from Facebook)

  final earliestDate = DateTime(1900, 1);
  final currentDate = DateTime.now();

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: OnboardingColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProgressBar(
                  page: 2,
                ),
                const FittedBox(
                  child: Text(
                    "When's your birthday?",
                    style: kTitleStyle,
                  ),
                ),
                Divider(
                  height: screenHeight * 0.03,
                  color: Colors.grey,
                ),
                SizedBox(
                  height:
                      ScreenSize.getSize(context) == ScreenSizeCategory.small
                          ? screenHeight * 0.45
                          : screenHeight * 0.18,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: selectedDate,
                        minimumDate: earliestDate,
                        maximumDate: currentDate,
                        onDateTimeChanged: (newDate) {
                          setState(() {
                            selectedDate = newDate;
                          });
                        }),
                  ),
                ),
                Divider(
                  height: screenHeight * 0.03,
                  color: Colors.grey,
                )
              ],
            ),
            Column(
              children: [
                RoundedButton(
                  name: 'NEXT',
                  onTap: () {
                    int age = calculateAge(selectedDate);
                    showDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                              title: Text(
                                "You're $age",
                              ),
                              content: age >= 18
                                  ? const Text(
                                      "Make sure that this is you'r correct age.")
                                  : const Text(
                                      'The minimum age requirement for Voilà is 18 years old.\nWe will be happy to welcome you back when you are 18'),
                              actions: age >= 18
                                  ? ([
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            SettingsData.instance.userBirthday = selectedDate.toString();
                                            Get.offAllNamed(OnboardingFlowController.nextRoute(BirthdayOnboardingScreen.routeName));
                                          },
                                          child: const Text(
                                            'Confirm',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))
                                    ])
                                  : [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                            ));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
