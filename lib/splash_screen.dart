import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/login_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';

/// This is the first root of the Application from here
/// we navigate to other routes.
class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<String> _routeTo() async {
    SettingsData settings = SettingsData();
    await settings.readSettingsFromShared();
    // we are making sure that if the user is already logged in at a time and i.e. sharedPreferences data exist
    // we move to the Main-navigation screen otherwise we move to the LoginScreen.
    //
    // This is the standard way of creating a splash-screen for an Application.
    if (settings.readFromShared && settings.facebookId != '') {
      return MainNavigationScreen.routeName;
    } else {
      return LoginScreen.routeName;
    }
  }

  // loads in the shared preference.
  void _load() async {
    final routeTo = await _routeTo();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Navigator.of(context).pushReplacementNamed(routeTo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: darkCardColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(BetaIconPaths.appLogoIcon),
            ),
            Text(
              'Swiper',
              style: mediumBoldedCharStyle.copyWith(color: colorBlend02),
            ),
          ],
        ),
      ),
    );
  }
}
