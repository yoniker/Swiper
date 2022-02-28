import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';

import '../constants/enums.dart';
import '../constants/onboarding_consts.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/onboarding/choice_button.dart';

class OrientationEditScreen extends StatefulWidget {
  static const String routeName = '/orientation_edit_screen';

  @override
  _OrientationEditScreenState createState() => _OrientationEditScreenState();
}

class _OrientationEditScreenState extends State<OrientationEditScreen> {
  PreferredGender? currentChoice;
  String whatWeShowText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        showAppLogo: false,
        title: 'My orientation',
      ),
      backgroundColor: kBackroundThemeColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    'Interested in?',
                    style: smallBoldedTitleBlack,
                  ),
                ),
                const SizedBox(height: 30),
                ChoiceButton(
                  name: 'Men',
                  onTap: () {
                    setState(() {
                      currentChoice = PreferredGender.Men;
                      whatWeShowText = 'We will only show you men';
                    });
                  },
                  pressed: currentChoice == PreferredGender.Men ? true : false,
                ),
                const SizedBox(height: 20),
                ChoiceButton(
                  name: 'Women',
                  onTap: () {
                    setState(() {
                      currentChoice = PreferredGender.Women;
                      whatWeShowText = 'We will only show you women';
                    });
                  },
                  pressed:
                      currentChoice == PreferredGender.Women ? true : false,
                ),
                const SizedBox(height: 20),
                ChoiceButton(
                  name: 'Everyone',
                  onTap: () {
                    setState(() {
                      currentChoice = PreferredGender.Everyone;
                      whatWeShowText = 'We will show you everyone';
                    });
                  },
                  pressed:
                      currentChoice == PreferredGender.Everyone ? true : false,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Row(
                    children: [
                      currentChoice != null
                          ? const Icon(Icons.remove_red_eye_rounded,
                              color: Colors.black54)
                          : const SizedBox(),
                      const SizedBox(width: 10),
                      Text(whatWeShowText, style: kSmallInfoStyle),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
