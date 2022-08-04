import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailAddressScreen extends StatefulWidget {
  static const String routeName = '/emailAddressScreen';
  final void Function()? onNext;

  const EmailAddressScreen({Key? key, this.onNext}) : super(key: key);

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
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            widget.onNext?.call();
                          },
                          child: const Text(
                            'Skip this step',
                            style: kSmallInfoStyleUnderline,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            RoundedButton(
                name: 'CONTINUE',
                onTap: () {
                  if (isValid(userEmail)) {
                    SettingsData.instance.email = userEmail;
                    widget.onNext?.call();
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
                                      style: const TextStyle(color: Colors.red),
                                    ))
                              ],
                            ));
                  }
                })
          ],
        ),
      ),
    );
  }
}
