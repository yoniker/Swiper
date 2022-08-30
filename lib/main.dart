import 'dart:io';
import 'package:betabeta/screens/advanced_settings_screen.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/chat/chat_screen.dart';
import 'package:betabeta/screens/chat/other_user_profile_screen.dart';
import 'package:betabeta/screens/complete_profile_pageview_screen.dart';
import 'package:betabeta/screens/mock_new_match_card_page.dart';
import 'package:betabeta/screens/my_look_a_like_screen.dart';
import 'package:betabeta/screens/my_mirror_screen.dart';
import 'package:betabeta/screens/onboarding/onboarding_pageview_screen.dart';
import 'package:betabeta/screens/onboarding/tutorial_screen_starter.dart';
import 'package:betabeta/screens/pending_approvment_screen.dart';
import 'package:betabeta/screens/user_edit/kids_screen.dart';
import 'package:betabeta/screens/chat/conversations_screen.dart';
import 'package:betabeta/screens/user_edit/covid_screen.dart';
import 'package:betabeta/screens/current_user_profile_view_screen.dart';
import 'package:betabeta/screens/user_edit/drinking_screen.dart';
import 'package:betabeta/screens/user_edit/education_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/user_edit/fitness_screen.dart';
import 'package:betabeta/screens/full_image_screen.dart';
import 'package:betabeta/screens/got_new_match_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/user_edit/looking_for_screen.dart';
import 'package:betabeta/screens/user_edit/my_hobbies_screen.dart';
import 'package:betabeta/screens/user_edit/my_pets_screen.dart';
import 'package:betabeta/screens/notification_screen.dart';
import 'package:betabeta/screens/onboarding/about_me_screen.dart';
import 'package:betabeta/screens/onboarding/birthday_screen.dart';
import 'package:betabeta/screens/onboarding/email_address_screen.dart';
import 'package:betabeta/screens/onboarding/finish_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/get_name_screen.dart';
import 'package:betabeta/screens/onboarding/location_permission_screen.dart';
import 'package:betabeta/screens/onboarding/relationship_type_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/notifications_permission_screen.dart';
import 'package:betabeta/screens/onboarding/orientation_screen.dart';
import 'package:betabeta/screens/onboarding/phone_screen.dart';
import 'package:betabeta/screens/onboarding/pronouns_screen.dart';
import 'package:betabeta/screens/onboarding/terms_screen.dart';
import 'package:betabeta/screens/onboarding/upload_images_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/welcome_screen.dart';
import 'package:betabeta/screens/user_edit/orientation_edit_screen.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/screens/user_edit/pronouns_edit_screen.dart';
import 'package:betabeta/screens/user_edit/smoking_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/screens/view_likes_screen.dart';
import 'package:betabeta/screens/splash_screen.dart';
import 'package:betabeta/screens/view_morph_screen.dart';
import 'package:betabeta/screens/voila_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  //TODO it's a temporary fix so we can use self signed certificates. DON'T USE IN PRODUCTION
  @override
  HttpClient createHttpClient(SecurityContext? context) {

      var client = super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
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
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white.withOpacity(0.05),
    // statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    GetMaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        // TODO: uncomment the line below after codegen
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('ar', ''), // Arabic, no country code
        const Locale('he', ''),
        const Locale.fromSubtags(
            languageCode: 'zh'), // Chinese *See Advanced Locales below*
        // ... other locales the app supports
      ],
      home: SplashScreen(),
      getPages: [
        GetPage(
          name: ProfileScreen.routeName,
          page: () => ProfileScreen(),
        ),
        GetPage(
            name: UploadImagesOnboardingScreen.routeName,
            page: () => UploadImagesOnboardingScreen()),
        GetPage(
            name: FinishOnboardingScreen.routeName,
            page: () => FinishOnboardingScreen()),
        GetPage(
            name: AboutMeOnboardingScreen.routeName,
            page: () => AboutMeOnboardingScreen()),
        GetPage(
            name: RelationshipTypeOnboardingScreen.routeName,
            page: () => RelationshipTypeOnboardingScreen()),
        GetPage(
            name: EmailAddressScreen.routeName,
            page: () => EmailAddressScreen()),
        GetPage(
            name: OrientationScreen.routeName, page: () => OrientationScreen()),
        GetPage(name: PronounScreen.routeName, page: () => PronounScreen()),
        GetPage(
            name: BirthdayOnboardingScreen.routeName,
            page: () => BirthdayOnboardingScreen()),
        GetPage(name: GetNameScreen.routeName, page: () => GetNameScreen()),
        GetPage(name: TermsScreen.routeName, page: () => TermsScreen()),
        GetPage(
            name: NotificationsPermissionScreen.routeName,
            page: () => NotificationsPermissionScreen()),
        GetPage(
            name: LocationPermissionScreen.routeName,
            page: () => LocationPermissionScreen()),
        GetPage(name: PhoneScreen.routeName, page: () => PhoneScreen()),
        GetPage(name: WelcomeScreen.routeName, page: () => WelcomeScreen()),
        GetPage(name: SplashScreen.routeName, page: () => SplashScreen()),
        GetPage(
            name: MainNavigationScreen.routeName,
            page: () => MainNavigationScreen()),
        GetPage(
            name: AdvancedSettingsScreen.routeName,
            page: () => AdvancedSettingsScreen()),
        GetPage(
            name: ScreenCelebritySelection.routeName,
            page: () => ScreenCelebritySelection()),
        GetPage(
            name: FaceSelectionScreen.routeName,
            page: () => FaceSelectionScreen()), //had args previously
        GetPage(
            name: SwipeSettingsScreen.routeName,
            page: () => SwipeSettingsScreen()),
        GetPage(name: ChatScreen.routeName, page: () => ChatScreen()),
        GetPage(
            name: AccountSettingsScreen.routeName,
            page: () => AccountSettingsScreen()),
        GetPage(
            name: ConversationsScreen.routeName,
            page: () => ConversationsScreen()),
        GetPage(name: MatchScreen.routeName, page: () => MatchScreen()),
        GetPage(
            name: NotificationScreen.routeName,
            page: () => NotificationScreen()),
        GetPage(
            name: ProfileEditScreen.routeName, page: () => ProfileEditScreen()),
        GetPage(
            name: SwipeSettingsScreen.routeName,
            page: () => SwipeSettingsScreen()),
        GetPage(name: ViewLikesScreen.routeName, page: () => ViewLikesScreen()),
        GetPage(name: FullImageScreen.routeName, page: () => FullImageScreen()),
        GetPage(
            name: GotNewMatchScreen.routeName, page: () => GotNewMatchScreen()),
        GetPage(name: VoilaPage.routeName, page: () => VoilaPage()),
        GetPage(
            name: CurrentUserProfileViewScreen.routeName,
            page: () => CurrentUserProfileViewScreen()),
        GetPage(
            name: PronounsEditScreen.routeName,
            page: () => PronounsEditScreen()),
        GetPage(
            name: OrientationEditScreen.routeName,
            page: () => OrientationEditScreen()),
        GetPage(name: MyHobbiesScreen.routeName, page: () => MyHobbiesScreen()),
        GetPage(name: FitnessScreen.routeName, page: () => FitnessScreen()),
        GetPage(name: SmokingScreen.routeName, page: () => SmokingScreen()),
        GetPage(name: KidsScreen.routeName, page: () => KidsScreen()),
        GetPage(name: DrinkingScreen.routeName, page: () => DrinkingScreen()),
        GetPage(name: CovidScreen.routeName, page: () => CovidScreen()),
        GetPage(name: EducationScreen.routeName, page: () => EducationScreen()),
        GetPage(name: MyPetsScreen.routeName, page: () => MyPetsScreen()),
        GetPage(
            name: OtherUserProfileScreen.routeName,
            page: () => OtherUserProfileScreen()),
        GetPage(
            name: LookingForScreen.routeName, page: () => LookingForScreen()),
        GetPage(
            name: CompleteProfilePageViewScreen.routeName,
            page: () => CompleteProfilePageViewScreen()),
        GetPage(
            name: TutorialScreenStarter.routeName,
            page: () => TutorialScreenStarter()),
        GetPage(
            name: MyLookALikeScreen.routeName, page: () => MyLookALikeScreen()),
        GetPage(
            name: MyMirrorScreen.routeName, page: () => MyMirrorScreen()),
        GetPage(
            name: PendingApprovementScreen.routeName,
            page: () => PendingApprovementScreen()),
        GetPage(
            name: OnboardingPageViewScreen.routeName,
            page: () => OnboardingPageViewScreen()),
        GetPage(
            name: MockNewMatchCardPage.routePage,
            page: () => MockNewMatchCardPage()),
        GetPage(name: ViewMorphScreen.routeName, page: ()=>ViewMorphScreen())
      ],
      title: 'Voilà MVP',
      debugShowCheckedModeBanner: false,
    ),
  );
}
