import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/location_permission_screen.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/phone_number_collector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneScreen extends StatefulWidget {
  static const String routeName = '/phoneScreen';

  const PhoneScreen({Key? key}) : super(key: key);
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  int dropDownValue = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: OnboardingColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'What is your phone number?  📞',
                    style: kTitleStyle,
                  ),
                ),
                Text(
                  'Just to make sure you are real :)',
                  style: kSmallInfoStyle,
                ),
                SizedBox(
                  height: 30,
                ),
                PhoneNumberCollector(
                  //TODO Yoni add phone login logic
                  onTap: (){
                    Get.offAllNamed(LocationPermissionScreen.routeName);
                  },
                )
              ],
            ),
            Column(
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Kept private and wont be in your profile  🔒',
                    style: kSmallInfoStyle,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
