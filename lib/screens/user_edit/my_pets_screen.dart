import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/bubbles_list_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MyPetsScreen extends StatefulWidget {
  static const String routeName = '/my_pets_screen';
  const MyPetsScreen({Key? key}) : super(key: key);

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundThemeColor,
      appBar: CustomAppBar(
        hasTopPadding: true,
        hasBackButton: true,
        showAppLogo: false,
        title: 'My pets',
      ),
      body: BubblesListWidget(
        bubbles: kPetsList,
        headline: 'Do you have pets?',
        maxChoices: 4,
        initialValue: SettingsData.instance.pets,
        onValueChanged: (newPetsValue) {
          SettingsData.instance.pets = newPetsValue;
        },
      ),
    );
  }
}
