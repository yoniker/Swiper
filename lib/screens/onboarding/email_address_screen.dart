import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailAddressScreen extends StatefulWidget {
  static const String routeName = '/emailAddressScreen';

  const EmailAddressScreen({Key? key}) : super(key: key);

  @override
  _EmailAddressScreenState createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends State<EmailAddressScreen> {
  String userEmail = SettingsData.instance.email;

  bool isValid(String emailAddress) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailAddress);
  }

  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: RawScrollbar(
          thumbColor: Colors.black54,
          thickness: 5,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            child: SizedBox(
              height: heightWithoutSafeArea,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProgressBar(
                          page: 6,
                        ),
                        const Text(
                          'What\'s your email address?',
                          style: kTitleStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'We will use this to recover your account \nincase you can\'t log in',
                          style: kSmallInfoStyle,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InputField(
                          hintText: 'add account recovery email',
                          initialvalue: userEmail,
                          keyboardType: TextInputType.emailAddress,
                          onType: (value) {
                            userEmail = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAllNamed(OnboardingFlowController.nextRoute(
                                EmailAddressScreen.routeName));
                          },
                          child: const Text(
                            'Skip this step',
                            style: kSmallInfoStyleUnderline,
                          ),
                        )
                      ],
                    ),
                    RoundedButton(
                        name: 'CONTINUE',
                        onTap: () {
                          if (isValid(userEmail)) {
                            SettingsData.instance.email = userEmail;
                            Get.offAllNamed(OnboardingFlowController.nextRoute(
                                EmailAddressScreen.routeName));
                          } else {
                            showCupertinoDialog(
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                      title: const Text('Invalid email'),
                                      content: const Text(
                                          'The email you have entered \ndoes not appear to be valid.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Close',
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ))
                                      ],
                                    ));
                          }
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
