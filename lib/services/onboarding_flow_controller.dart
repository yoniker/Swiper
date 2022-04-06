import 'dart:io';

import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/onboarding/about_me_screen.dart';
import 'package:betabeta/screens/onboarding/birthday_screen.dart';
import 'package:betabeta/screens/onboarding/email_address_screen.dart';
import 'package:betabeta/screens/onboarding/finish_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/get_name_screen.dart';
import 'package:betabeta/screens/onboarding/location_permission_screen.dart';
import 'package:betabeta/screens/onboarding/notifications_permission_screen.dart';
import 'package:betabeta/screens/onboarding/orientation_screen.dart';
import 'package:betabeta/screens/onboarding/phone_screen.dart';
import 'package:betabeta/screens/onboarding/pronouns_screen.dart';
import 'package:betabeta/screens/onboarding/relationship_type_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/terms_screen.dart';
import 'package:betabeta/screens/onboarding/upload_images_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/welcome_screen.dart';

class OnboardingFlowController {
  List<String> chosenOnboradingFlow;
  OnboardingFlowController._privateConstructor():chosenOnboradingFlow=fullOnboardingFlow;

  
  
  
  static final OnboardingFlowController _instance = OnboardingFlowController._privateConstructor();

  static OnboardingFlowController get instance => _instance;

  static const List<String> fullOnboardingFlow = [
    WelcomeScreen.routeName,
    //PhoneScreen.routeName,
    NotificationsPermissionScreen.routeName,
    TermsScreen.routeName,
    GetNameScreen.routeName,
    BirthdayOnboardingScreen.routeName,
    PronounScreen.routeName,
    OrientationScreen.routeName,
    RelationshipTypeOnboardingScreen.routeName,
    EmailAddressScreen.routeName,
    AboutMeOnboardingScreen.routeName,
    UploadImagesOnboardingScreen.routeName,
    LocationPermissionScreen.routeName,
    FinishOnboardingScreen.routeName,
    MainNavigationScreen.routeName
  ];

  void setOnboardingPath(ServerRegistrationStatus loginStatus){
    if(loginStatus==ServerRegistrationStatus.new_register){
      chosenOnboradingFlow=fullOnboardingFlow;
      return;
    }
    if(loginStatus==ServerRegistrationStatus.already_registered){

      chosenOnboradingFlow = [];
      if(!Platform.isAndroid){
        chosenOnboradingFlow.add(NotificationsPermissionScreen.routeName);
      }
      chosenOnboradingFlow.add(LocationPermissionScreen.routeName);
      chosenOnboradingFlow.add(MainNavigationScreen.routeName);

    }


  }

  String nextRoute(String currentRoute) {
    String candidateNextScreen =
    chosenOnboradingFlow[chosenOnboradingFlow.indexOf(currentRoute) + 1];
    while (true) {
      if ((candidateNextScreen == EmailAddressScreen.routeName &&
              SettingsData.instance.email.length > 0) //There is email
          ||
          (candidateNextScreen == NotificationsPermissionScreen.routeName && Platform.isAndroid)) //notification permissions for Android isn't needed
      {
        candidateNextScreen =
        chosenOnboradingFlow[chosenOnboradingFlow.indexOf(candidateNextScreen) + 1];
        continue;
      }
      break;
    }
    if(candidateNextScreen==MainNavigationScreen.routeName){
      NewNetworkService.instance.syncCurrentProfileImagesUrls();
      ChatData.instance.onInitApp();
      ChatData.instance.syncWithServer();
      MatchEngine.instance.clear();
      SettingsData.instance.registrationStatus=API_CONSTS.ALREADY_REGISTERED;
    }
    return candidateNextScreen;
  }
}
