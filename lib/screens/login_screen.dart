import 'package:auth_buttons/auth_buttons.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/conversations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  //See https://codesundar.com/flutter-facebook-login/

  late bool _errorTryingToLogin;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _errorTryingToLogin = false;
    _getSettings();
  }

  _getSettings() async {
    SettingsData settings = SettingsData();
    await settings.readSettingsFromShared();
    if (settings.readFromShared! && settings.facebookId != '') {
      print('get settings decided to move to main nav screen');
      Navigator.pushReplacementNamed(
        context,
        MainNavigationScreen.routeName,
      ); //TODO make sure this makes sense given splash screen
    }
  }

  _getFBLoginInfo() async {
    final loginResult = await FacebookAuth.instance.login();

    switch (loginResult.status) {
      case LoginStatus.success:
        final AccessToken? accessToken = loginResult.accessToken;
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );
        SettingsData().name = userData['name'];
        SettingsData().facebookId = userData['id'];
        SettingsData().facebookProfileImageUrl =
            userData['picture']['data']['url'];

        DefaultCacheManager().emptyCache();
        DefaultCacheManager()
            .getSingleFile(SettingsData().facebookProfileImageUrl);
        _getSettings();
        break;

      case LoginStatus.cancelled:
        setState(() {
          _errorTryingToLogin = true;
          _errorMessage = 'User cancelled Login';
        });
        break;
      case LoginStatus.operationInProgress:
      case LoginStatus.failed:
        setState(() {
          _errorTryingToLogin = true;
          _errorMessage = loginResult.message ?? 'Error trying to login';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'D',
                style: TextStyle(
                  fontSize: 55,
                  fontFamily: 'RougeScript',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text('MVPBeta Login'),
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FacebookAuthButton(
                    onPressed: () {
                      _getFBLoginInfo();
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => MatchingScreen(title: 'Flutter Demo Home Page')));
                    },
                  ),
                  _errorTryingToLogin
                      ? TextButton(
                          child: Text('❗'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(_errorMessage ??
                                        "Error when trying to login"),
                                  );
                                },
                                barrierDismissible: true);
                          })
                      : Container()
                ],
              ),
              Text(
                "Don't worry, we only ask for your public profile.",
                style: TextStyle(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              Text('We never post to Facebook.',
                  style: TextStyle(
                    color: Colors.grey,
                  )),
              GestureDetector(
                child: Container(
                  child: Text('What does public profile mean?',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Public Profile Info"),
                          content: Text(
                              "Public Profile includes just your name and profile picture. This information is literally available to anyone in the world."),
                        );
                      },
                      barrierDismissible: true);
                },
              ),
            ],
          ),
        ));
  }
}
