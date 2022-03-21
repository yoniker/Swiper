import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/bubbles_list_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:flutter/material.dart';

class MyHobbiesScreen extends StatefulWidget {
  static const String routeName = '/my_hobbies_screen';
  const MyHobbiesScreen({Key? key}) : super(key: key);

  @override
  State<MyHobbiesScreen> createState() => _MyHobbiesScreenState();
}

class _MyHobbiesScreenState extends State<MyHobbiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundThemeColor,
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        showAppLogo: false,
        title: 'My hobbies',
      ),
      body: BubblesListWidget(
        bubbles: kHobbiesList,
        headline: 'Choose up to 6 hobbies to highlight for your profile',
        maxChoices: 6,
        initialValue: SettingsData.instance.hobbies,
        onValueChanged: (newHobbiesList) {
          SettingsData.instance.hobbies = newHobbiesList;
        },
      ),
    );
  }
}
