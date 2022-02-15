import 'dart:io';

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

class OnboardingFlowController{
  static const List<String> onboardingFlow = [
    WelcomeScreen.routeName,
    PhoneScreen.routeName,
    LocationPermissionScreen.routeName,
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
    FinishOnboardingScreen.routeName,
    MainNavigationScreen.routeName
  ];

  static String nextRoute(String currentRoute){
    String candidateNextScreen =  onboardingFlow[onboardingFlow.indexOf(currentRoute)+1];
    while(true){
      if(
          (candidateNextScreen==EmailAddressScreen.routeName && SettingsData.instance.email.length>0)  //There is email
      ||
          (candidateNextScreen==NotificationsPermissionScreen.routeName && Platform.isAndroid)
      ){
        candidateNextScreen = onboardingFlow[onboardingFlow.indexOf(candidateNextScreen)+1];
        continue;
      }
      break;

    }

    return candidateNextScreen;

  }
}