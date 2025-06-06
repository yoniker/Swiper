import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/screens/splash_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/swipe_setting_widget.dart';

/// The implementation for the Notification screen.
class AccountSettingsScreen extends StatefulWidget {
  static const String routeName = '/account_settings';

  AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  String produceAgesRangeText(RangeValues _ages) {
    String agesRangeText;

    if (_ages.start.toInt() <= SwipeSettingsScreen.minAge) {
      if (_ages.end.toInt() >= SwipeSettingsScreen.maxAge) {
        agesRangeText = 'Any Age';
      } else {
        agesRangeText = '${_ages.end.toInt()} or younger';
      }
    } else {
      if (_ages.end.toInt() >= SwipeSettingsScreen.maxAge) {
        agesRangeText = 'Between ${_ages.start.toInt()} and 65+';
      } else {
        agesRangeText =
            'Between ${_ages.start.toInt()} and ${_ages.end.toInt()}';
      }
    }
    return agesRangeText;
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
        notifier: SettingsData.instance,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: backgroundThemeColor,
            appBar: CustomAppBar(
              title: 'General Settings',
              hasTopPadding: true,
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.settingsBarIcon,
                color: Colors.black,
              ),
            ),
            body: SwipeSettingWidget(
              showExtraSettings: true,
            ),
          );
        });
  }
}
