import 'dart:io';
import 'package:betabeta/screens/advanced_settings_screen.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/chat_screen.dart';
import 'package:betabeta/screens/conversations_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/login_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/notification_screen.dart';
import 'package:betabeta/screens/profile_details_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/screens/view_likes_screen.dart';
import 'package:betabeta/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  //TODO it's a temporary fix so we can use self signed certificates. DON'T USE IN PRODUCTION
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
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

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(home: SplashScreen(),
      getPages: [
        GetPage(name:SplashScreen.routeName,page: ()=> SplashScreen()),
        GetPage(name:LoginScreen.routeName, page: () =>LoginScreen()),
        GetPage(name:MainNavigationScreen.routeName,page:()=>MainNavigationScreen()),
        GetPage(name:AdvancedSettingsScreen.routeName,page:()=>AdvancedSettingsScreen()),
        GetPage(name:ScreenCelebritySelection.routeName,page:()=>ScreenCelebritySelection()),
        GetPage(name:FaceSelectionScreen.routeName,page:()=>FaceSelectionScreen()), //had args previously
        GetPage(name:SwipeSettingsScreen.routeName,page:()=>SwipeSettingsScreen()),
        GetPage(name:ChatScreen.routeName,page:()=>ChatScreen()),
        GetPage(name:AccountSettingsScreen.routeName,page:()=>AccountSettingsScreen()),
        GetPage(name:ConversationsScreen.routeName,page:()=>ConversationsScreen()),
        GetPage(name:MatchScreen.routeName,page:()=>MatchScreen()),
        GetPage(name:NotificationScreen.routeName,page:()=>NotificationScreen()),
        GetPage(name:ProfileDetailsScreen.routeName,page:()=>ProfileDetailsScreen()),
        GetPage(name:SwipeSettingsScreen.routeName,page:()=>SwipeSettingsScreen()),
        GetPage(name:ViewLikesScreen.routeName,page:()=>ViewLikesScreen()),

      ],

        title: 'Swiper MVP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColorBrightness: Brightness.light,
          primarySwatch: Colors.blue,
        )


    )
    ,);
}
