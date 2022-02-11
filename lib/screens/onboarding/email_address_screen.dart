import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/about_me_screen.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailAddressScreen extends StatefulWidget {
  static String routeName = '/emailAddressScreen';
  static String? userEmail;

  const EmailAddressScreen({Key? key}) : super(key: key);

  @override
  _EmailAddressScreenState createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends State<EmailAddressScreen> {
  List<String> validEmail = ["@", "."];
  String? userEmail = '';

  bool? isValid() {
    String valid = '';
    for (int i = 0; i < userEmail!.length; i++) {
      if (userEmail![i] == '@' || userEmail![i] == '.') {
        valid = valid + userEmail![i];
      }
    }
    if (valid == '@.') {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (EmailAddressScreen.userEmail != null) {
      setState(() {
        userEmail = EmailAddressScreen.userEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //height (with SafeArea)
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackroundThemeColor,
        resizeToAvoidBottomInset: true,
        body: RawScrollbar(
          thumbColor: Colors.black54,
          thickness: 5,
          thumbVisibility: true,
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
                          initialvalue: EmailAddressScreen.userEmail,
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
                            Get.offAllNamed(AboutMeOnboardingScreen.routeName);
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
                          isValid() == false
                              ? showCupertinoDialog(
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
                                      ))
                              : Get.offAllNamed(
                                  AboutMeOnboardingScreen.routeName);
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
