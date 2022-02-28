import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetNameScreen extends StatefulWidget {
  static const String routeName = '/get_name';

  @override
  _GetNameScreenState createState() => _GetNameScreenState();
}

class _GetNameScreenState extends State<GetNameScreen> {
  String userName = SettingsData.instance.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      resizeToAvoidBottomInset:
          ScreenSize.getSize(context) == ScreenSizeCategory.small
              ? false
              : true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressBar(
                      page: 1,
                    ),
                    const FittedBox(
                      child: Text(
                        "What's your first name?",
                        style: kTitleStyle,
                      ),
                    ),
                    const SizedBox(height: 30),
                    InputField(
                      initialvalue: userName,
                      onTapIcon: () {
                        SettingsData.instance.name = userName;
                        Get.offAllNamed(OnboardingFlowController.nextRoute(
                            GetNameScreen.routeName));
                      },
                      icon: userName.length == 0 ? null : Icons.send,
                      hintText: ' Enter your first name here.',
                      onType: (value) {
                        setState(() {
                          userName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.remove_red_eye_rounded,
                            color: Colors.black54),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This will be shown on your profile.',
                            style: kSmallInfoStyle,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                RoundedButton(
                  name: 'NEXT',
                  onTap: userName.isEmpty
                      ? null
                      : () {
                          SettingsData.instance.name = userName;
                          Get.offAllNamed(OnboardingFlowController.nextRoute(
                              GetNameScreen.routeName));
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
