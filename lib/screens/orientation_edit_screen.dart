import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
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

  updateText() {
    if (SettingsData.instance.preferredGender == PreferredGender.Men.name) {
      whatWeShowText = 'We will only show you men';
    } else if (SettingsData.instance.preferredGender ==
        PreferredGender.Women.name) {
      whatWeShowText = 'We will only show you women';
    } else {
      whatWeShowText = 'We will show you everyone';
    }
  }

  @override
  void initState() {
    updateText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        showAppLogo: false,
        title: 'Interested in',
      ),
      backgroundColor: kBackroundThemeColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConditionalParentWidget(
              condition:
                  ScreenSize.getSize(context) == ScreenSizeCategory.small,
              conditionalBuilder: (Widget child) => FittedBox(
                child: child,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: const Text(
                      'Interested in?',
                      style: titleStyle,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ChoiceButton(
                    name: 'Men',
                    onTap: () {
                      setState(() {
                        SettingsData.instance.preferredGender =
                            PreferredGender.Men.name;
                        whatWeShowText = 'We will only show you men';
                      });
                    },
                    pressed: SettingsData.instance.preferredGender ==
                        PreferredGender.Men.name,
                  ),
                  const SizedBox(height: 20),
                  ChoiceButton(
                      name: 'Women',
                      onTap: () {
                        setState(() {
                          SettingsData.instance.preferredGender =
                              PreferredGender.Women.name;
                          whatWeShowText = 'We will only show you women';
                        });
                      },
                      pressed: SettingsData.instance.preferredGender ==
                          PreferredGender.Women.name),
                  const SizedBox(height: 20),
                  ChoiceButton(
                      name: 'Everyone',
                      onTap: () {
                        setState(() {
                          SettingsData.instance.preferredGender =
                              PreferredGender.Everyone.name;
                          whatWeShowText = 'We will show you everyone';
                        });
                      },
                      pressed: SettingsData.instance.preferredGender ==
                          PreferredGender.Everyone.name),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Row(
                    children: [
                      const Icon(Icons.remove_red_eye_rounded,
                          color: Colors.black54),
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
