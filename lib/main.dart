import 'dart:io';

import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/advanced_settings_screen.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/settings_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

import 'models/celebs_info_model.dart';
import 'models/details_model.dart';

class MyHttpOverrides extends HttpOverrides {
  //TODO it's a temporary fix so we can use self signed certificates. DON'T USE IN PRODUCTION
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.instance.webInitialize(
      appId: "218658432881919",//<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }
  runApp(ChangeNotifierProvider(
      create: (context) => MatchEngine(),
      child: ChangeNotifierProvider(
          //TODO put it in a lower place down the Widget tree...
          create: (context) => CelebsInfo(),
          child: MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DetailsData(); //Create both singletons  which read from shared preferences. TODO what's the prinicpled way to do that?
    SettingsData();
    return MaterialApp(
      onGenerateRoute: _onGenerateRoute,
      title: 'Swiper MVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorBrightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: LoginHome(),
      // MatchingScreen(title: 'Swiper MVP'),
      // LoginHome(),
      //MatchingScreen(title: 'Flutter Demo Home Page'),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    if (settings.name == MainNavigationScreen.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return MainNavigationScreen();
        },
      );
    }

    if (settings.name == AdvancedSettingsScreen.routeName) {
      return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return AdvancedSettingsScreen();
          });
    }

    if (settings.name == ScreenCelebritySelection.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return ScreenCelebritySelection();
        },
      );
    }

    if (settings.name == FaceSelectionScreen.routeName) {
      final FaceSelectionScreenArguments args =
          settings.arguments as FaceSelectionScreenArguments;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return FaceSelectionScreen(
            imageFile: args.imageFile,
            imageFileName: args.imageFileName,
          );
        },
      );
    }

    if (settings.name == SettingsScreen.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return SettingsScreen();
        },
      );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        return LoginHome();
      },
    );
  }
}

class LoginHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginHomeState();
  }
}

class _LoginHomeState extends State<LoginHome> {
  //See https://codesundar.com/flutter-facebook-login/

  bool _errorTryingToLogin;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _errorTryingToLogin = false;
    _getSettings();
  }

  _getSettings() async {
    SettingsData settings = SettingsData();
    await settings.readSettingsFromShared();
    if (settings.readFromShared && settings.facebookId != '') {
      print('get settings decided to move to main nav screen');
      Navigator.pushReplacementNamed(
        context,
        MainNavigationScreen.routeName,
      );
    }
  }

  _getFBLoginInfo() async {
    final loginResult = await FacebookAuth.instance.login();

    switch (loginResult.status) {
      case LoginStatus.success:
        final AccessToken accessToken = loginResult.accessToken;
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
            title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('D',
                style: TextStyle(
                    fontSize: 55,
                    fontFamily: 'RougeScript',
                    fontWeight: FontWeight.bold)),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text('MVPBeta Login'))
          ],
        )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FacebookSignInButton(
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
              )
            ],
          ),
        ));
  }
}
