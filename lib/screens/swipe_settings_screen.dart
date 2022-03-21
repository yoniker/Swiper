import 'dart:math' as math;

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/cupertino_range_slider.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/dropdown_form_field.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/swipe_setting_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DropdownButtonFormField;
import 'package:get/get.dart';


class SwipeSettingsScreen extends StatefulWidget {
  SwipeSettingsScreen({Key? key}) : super(key: key);
  static const String routeName = '/swipe_settings';
  static const minAge = 18;
  static const maxAge = 65;

  @override
  _SwipeSettingsScreenState createState() => _SwipeSettingsScreenState();
}

class _SwipeSettingsScreenState extends State<SwipeSettingsScreen> {
  @override
  void initState() {
    super.initState();

    // call the `initializePreferences` method to initialize all important
    // user configurations.
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
        notifier: SettingsData.instance,
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Settings',
              hasTopPadding: true,
              trailing: Icon(
                  Icons.settings), //iconURI: 'assets/images/settings_icon.png',
            ),
            body: SwipeSettingWidget(),
          );
        });
  }
}
