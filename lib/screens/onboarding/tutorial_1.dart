import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/get_name_screen.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({Key? key}) : super(key: key);
  static const String routeName = '/tutorial_1';

  @override
  State<Tutorial1> createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressBar(
                      totalProgressBarPages: kTotalProgressBarPages,
                      page: 9,
                    ),
                    const FittedBox(
                      child: Text(
                        "Let's have a look at how Voilà works:",
                        style: kTitleStyle,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                RoundedButton(
                  name: 'NEXT',
                  onTap: () {
                    Get.offAllNamed(OnboardingFlowController.instance
                        .nextRoute(GetNameScreen.routeName));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
