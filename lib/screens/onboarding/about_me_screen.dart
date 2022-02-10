import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/upload_images_onboarding_screen.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutMeOnboardingScreen extends StatefulWidget {
  static const String routeName = '/aboutMeOnboardingScreen';
  static const int minCharInDescription = 10;

  const AboutMeOnboardingScreen({Key? key}) : super(key: key);

  @override
  _AboutMeOnboardingScreenState createState() => _AboutMeOnboardingScreenState();
}

class _AboutMeOnboardingScreenState extends State<AboutMeOnboardingScreen> {
  String aboutMe = '';

  @override
  Widget build(BuildContext context) {
    int charactersLeft = AboutMeOnboardingScreen.minCharInDescription - (aboutMe.length);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: OnboardingColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ProgressBar(
                  page: 7,
                ),
                const Text(
                  'Tell others about yourself',
                  style: kTitleStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'People love to see a bio that describe who you are.',
                  style: kSmallInfoStyle,
                ),
                const SizedBox(
                  height: 30,
                ),
                InputField(
                  onTapIcon: aboutMe.length < AboutMeOnboardingScreen.minCharInDescription
                      ? null
                      : () {
                    Get.offAllNamed(UploadImagesOnboardingScreen.routeName);
                        },
                  iconHeight: 90,
                  icon: Icons.send,
                  onType: (value) {
                    aboutMe = value;
                    setState(() {});
                  },
                  maxCharacters: 500,
                  maxLines: 5,
                  hintText: 'Write something interesting about yourself',
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    aboutMe.length >= AboutMeOnboardingScreen.minCharInDescription
                        ? ''
                        : 'Minimum $charactersLeft characters left',
                    style: kSmallInfoStyle,
                  ),
                )
              ],
            ),
            RoundedButton(
                name: 'CONTINUE',
                onTap: aboutMe.length < AboutMeOnboardingScreen.minCharInDescription
                    ? null
                    : () {
                  Get.offAllNamed(UploadImagesOnboardingScreen.routeName);
                      })
          ],
        ),
      ),
    );
  }
}
