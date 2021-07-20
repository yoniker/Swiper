import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The implementation for the Notification screen.
class GeneralSettingsScreen extends StatefulWidget {
  static const String routeName = '/general_settings';

  GeneralSettingsScreen({Key key}) : super(key: key);

  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'General Settings',
        hasTopPadding: true,
        showAppLogo: false,
        trailing: PrecachedImage.asset(
          imageURI: BetaIconPaths.settingsBarIcon,
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Text(
              'Swiper V 1.0.2',
              style: mediumBoldedCharStyle,
            ),
          ),
          SizedBox(height: 12.0),
          ActionBox(
            message: 'Matching Settings',
            messageStyle: smallBoldedCharStyle.copyWith(color: colorBlend02),
            margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            trailing: Icon(
              Icons.settings,
              color: colorBlend02,
            ),
            onTap: () {
              // move to swiping-preference screen.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SwipeSettingsScreen(),
                ),
              );
            },
          ),
          ActionBox(
            message: 'Facebook Logout',
            messageStyle: smallBoldedCharStyle.copyWith(color: blue),
            margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            trailing: PrecachedImage.asset(
              imageURI: BetaIconPaths.facebookLogo,
            ),
            onTap: () {},
          ),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }
}
