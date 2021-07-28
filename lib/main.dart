import 'dart:io';

import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/advanced_settings_screen.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/chat_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/login_screen.dart';
import 'package:betabeta/screens/main_messages_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/notification_screen.dart';
import 'package:betabeta/screens/profile_details_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/screens/view_children_screen.dart';
import 'package:betabeta/screens/view_likes_screen.dart';
import 'package:betabeta/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      appId: "218658432881919", //<-- YOUR APP_ID
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
      initialRoute: ScreenCelebritySelection.routeName //SplashScreen.routeName,

      // MatchingScreen(title: 'Swiper MVP'),
      // LoginHome(),
      //MatchingScreen(title: 'Flutter Demo Home Page'),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    if (settings.name == SplashScreen.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return SplashScreen();
        },
      );
    } else if (settings.name == LoginScreen.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return LoginScreen();
        },
      );
    } else if (settings.name == MainNavigationScreen.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return MainNavigationScreen();
        },
      );
    } else if (settings.name == AdvancedSettingsScreen.routeName) {
      return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return AdvancedSettingsScreen();
          });
    } else if (settings.name == ScreenCelebritySelection.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return ScreenCelebritySelection();
        },
      );
    } else if (settings.name == FaceSelectionScreen.routeName) {
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
    } else if (settings.name == SwipeSettingsScreen.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return SwipeSettingsScreen();
        },
      );
    } else if (settings.name == ChatScreen.routeName){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return ChatScreen();
        },
      );

    } else if (settings.name == AccountSettingsScreen.routeName){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return AccountSettingsScreen();
        },
      );
    } else if (settings.name == MainMessagesScreen.routeName){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return MainMessagesScreen();
        },
      );


    } else if (settings.name == MatchScreen.routeName){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return MatchScreen();
        },
      );


    } else if (settings.name == NotificationScreen.routeName){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return NotificationScreen();
        },
      );


    } else if (settings.name == ProfileDetailsScreen.routeName){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return ProfileDetailsScreen();
        },
      );


    }
    else if (settings.name == SwipeSettingsScreen.routeName){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return SwipeSettingsScreen();
        },
      );


    } else if (settings.name == ViewLikesScreen.routeName){
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return ViewLikesScreen();
        },
      );


    }
    else {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          return LoginScreen();
        },
      );
    }
  }
}
