import 'dart:io';

import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/onboarding/about_me_screen.dart';
import 'package:betabeta/screens/onboarding/birthday_screen.dart';
import 'package:betabeta/screens/onboarding/finish_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/get_name_screen.dart';
import 'package:betabeta/screens/onboarding/location_permission_screen.dart';
import 'package:betabeta/screens/onboarding/notifications_permission_screen.dart';
import 'package:betabeta/screens/onboarding/orientation_screen.dart';
import 'package:betabeta/screens/onboarding/pronouns_screen.dart';
import 'package:betabeta/screens/onboarding/relationship_type_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/terms_screen.dart';
import 'package:betabeta/screens/onboarding/tutorial_screen_starter.dart';
import 'package:betabeta/screens/onboarding/upload_images_onboarding_screen.dart';
import 'package:betabeta/screens/pending_approvment_screen.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/chatData.dart';
import 'package:betabeta/services/location_service.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPageViewScreen extends StatefulWidget {
  static const String routeName = '/onboarding_page_view_screen';

  late final ServerRegistrationStatusResponse? registrationStatus;
  OnboardingPageViewScreen({Key? key}) : super(key: key) {
    registrationStatus = Get.arguments;
  }

  @override
  State<OnboardingPageViewScreen> createState() =>
      _OnboardingPageViewScreenState();
}

class _OnboardingPageViewScreenState extends State<OnboardingPageViewScreen> {
  int currentPage = 0;
  int totalPages = 0;
  late List<Widget> chosenOnboradingFlow;
  late PageController pageController;
  var termsScreenKey = UniqueKey();
  var finishOnboardingScreenKey = UniqueKey();
  var notificationKey = UniqueKey();
  nextPage() {
    print(chosenOnboradingFlow.last);
    if (chosenOnboradingFlow.last != chosenOnboradingFlow[currentPage]) {
      pageController.animateToPage(currentPage + 1,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    } else {
      syncWithServer();
      //Register the user at server if this wasn't done already
      if(!(SettingsData.instance.registrationStatus==RegistrationStatus.registeredApproved || SettingsData.instance.registrationStatus == RegistrationStatus.registeredNotApproved)){
        SettingsData.instance.registrationStatus = RegistrationStatus.registeredNotApproved;
      }
      if (widget.registrationStatus ==
          ServerRegistrationStatusResponse.already_registered)
        {
          if(MatchEngine.instance.registrationStatus==RegistrationStatus.registeredApproved)
          {Get.offAllNamed(MainNavigationScreen.routeName);}
          Get.offAllNamed(PendingApprovementScreen.routeName);

        }
      else
        {
          Get.offAllNamed(PendingApprovementScreen.routeName); //TODO Nitzan build a tutorial here
          //Get.offAllNamed(TutorialScreenStarter.routeName);
          }
    }
  }

  void syncWithServer() {
    print('Now syncing from server!!!');
    AWSServer.instance.syncCurrentProfileImagesUrls();
    ChatData.instance.onInitApp();
    ChatData.instance.syncWithServer();
    MatchEngine.instance.clear();
    LocationService.instance.onInit();
    MatchEngine.instance;
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    final List<Widget> fullOnboardingFlow = [
      //PhoneScreen(),
      TermsScreen(
        onNext: nextPage,
        key: termsScreenKey,
      ),
      NotificationsPermissionScreen(
        onNext: nextPage,
      ),
      GetNameScreen(
        onNext: nextPage,
      ),
      BirthdayOnboardingScreen(
        onNext: nextPage,
      ),
      PronounScreen(
        onNext: nextPage,
      ),
      OrientationScreen(
        onNext: nextPage,
      ),
      RelationshipTypeOnboardingScreen(
        onNext: nextPage,
      ),
      //EmailAddressScreen(),
      AboutMeOnboardingScreen(
        onNext: nextPage,
      ),
      UploadImagesOnboardingScreen(
        onNext: nextPage,
      ),
      LocationPermissionScreen(
        onNext: nextPage,
      ),
      FinishOnboardingScreen(
        onNext: nextPage,
        key: finishOnboardingScreenKey,
      ),
      // TutorialScreenStarter(),
      // MainNavigationScreen()
    ];

    void setOnboardingPath(ServerRegistrationStatusResponse loginStatus) {
      if (loginStatus == ServerRegistrationStatusResponse.new_register) {
        chosenOnboradingFlow = fullOnboardingFlow;
        return;
      }
      if (loginStatus == ServerRegistrationStatusResponse.already_registered) {
        chosenOnboradingFlow = [];
        if (!Platform.isAndroid) {
          chosenOnboradingFlow
              .add(NotificationsPermissionScreen(onNext: nextPage));
        }
        chosenOnboradingFlow.add(LocationPermissionScreen(
          onNext: nextPage,
        ));
      }
    }

    setOnboardingPath(widget.registrationStatus!);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalPages = chosenOnboradingFlow.length;
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          backgroundColor: kBackroundThemeColor,
          body: Column(
            children: [
              if (chosenOnboradingFlow[currentPage].key != termsScreenKey &&
                  chosenOnboradingFlow[currentPage].key !=
                      finishOnboardingScreenKey)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: ProgressBar(
                      totalProgressBarPages: chosenOnboradingFlow.length,
                      page: currentPage.toDouble() + 1,
                    ),
                  ),
                ),
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  children: chosenOnboradingFlow,
                  onPageChanged: (page) {
                    setState(
                      () {
                        currentPage = page;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
