import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';
import '../widgets/swipe_setting_widget.dart';

/// The implementation for the Notification screen.
class AccountSettingsScreen extends StatefulWidget {
  static const String routeName = '/account_settings';

  AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCardColor,
      appBar: CustomAppBar(
        title: 'General Settings',
        hasTopPadding: true,
        showAppLogo: false,
        trailing: PrecachedImage.asset(
          imageURI: BetaIconPaths.settingsBarIcon,
          color: Colors.black,
        ),
      ),
      body: SwipeSettingWidget(
        showExtraSettings: true,
      ),
    );
  }
}
