import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/screens/onboarding/upload_images_onboarding_screen.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutMeOnboardingScreen extends StatefulWidget {
  static const String routeName = '/aboutMeOnboardingScreen';
  static const int minCharInDescription = 10;

  const AboutMeOnboardingScreen({Key? key}) : super(key: key);

  @override
  _AboutMeOnboardingScreenState createState() =>
      _AboutMeOnboardingScreenState();
}

class _AboutMeOnboardingScreenState extends State<AboutMeOnboardingScreen> {
  String aboutMeText = '';

  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    int charactersLeft =
        AboutMeOnboardingScreen.minCharInDescription - (aboutMeText.length);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackroundThemeColor,
        resizeToAvoidBottomInset: true,
        body: RawScrollbar(
          thumbColor: Colors.black54,
          thickness: 5,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            reverse: false,
            child: SizedBox(
              height: heightWithoutSafeArea,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
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
                          onTapIcon: aboutMeText.length <
                                  AboutMeOnboardingScreen.minCharInDescription
                              ? null
                              : () {
                            SettingsData.instance.userDescription = aboutMeText;
                            Get.offAllNamed(OnboardingFlowController.nextRoute(AboutMeOnboardingScreen.routeName));
                                },
                          iconHeight: 90,
                          icon: Icons.send,
                          onType: (value) {
                            aboutMeText = value;
                            setState(() {});
                          },
                          maxCharacters: 500,
                          maxLines: 5,
                          hintText:
                              'Write something interesting about yourself',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            aboutMeText.length >=
                                    AboutMeOnboardingScreen.minCharInDescription
                                ? ''
                                : 'Minimum $charactersLeft characters left',
                            style: kSmallInfoStyle,
                          ),
                        )
                      ],
                    ),
                    RoundedButton(
                        name: 'CONTINUE',
                        onTap: aboutMeText.length <
                                AboutMeOnboardingScreen.minCharInDescription
                            ? null
                            : () {
                          SettingsData.instance.userDescription = aboutMeText;
                          Get.offAllNamed(OnboardingFlowController.nextRoute(AboutMeOnboardingScreen.routeName));
                              })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
