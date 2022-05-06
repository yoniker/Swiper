import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/dynamic_picker_screen.dart';
import 'package:betabeta/screens/onboarding/finish_onboarding_screen.dart';
import 'package:betabeta/screens/onboarding/job_title_screen.dart';
import 'package:betabeta/screens/onboarding/school_screen.dart';
import 'package:betabeta/screens/user_edit/covid_screen.dart';
import 'package:betabeta/screens/user_edit/drinking_screen.dart';
import 'package:betabeta/screens/user_edit/education_screen.dart';
import 'package:betabeta/screens/user_edit/fitness_screen.dart';
import 'package:betabeta/screens/user_edit/kids_screen.dart';
import 'package:betabeta/screens/user_edit/my_hobbies_screen.dart';
import 'package:betabeta/screens/user_edit/my_pets_screen.dart';
import 'package:betabeta/screens/user_edit/smoking_screen.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompleteProfilePageViewScreen extends StatefulWidget {
  static const String routeName = '/complete_profile_pageview_screen';
  const CompleteProfilePageViewScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfilePageViewScreen> createState() =>
      _CompleteProfilePageViewScreenState();
}

class _CompleteProfilePageViewScreenState
    extends State<CompleteProfilePageViewScreen> {
  List<Widget> pages = <Widget>[
    JobTitleScreen(),
    SchoolScreen(),
    EducationScreen(
      onboardingMode: true,
    ),
    DynamicPickerScreen(
      headline: 'What is your height?',
      itemList: kHeightList.map((e) => Center(child: Text(e))).toList(),
      initialItem: (kHeightList.length * 0.5).toInt(),
      onSelectedItemChanged: (int value) {
        SettingsData.instance.heightInCm = value + startingCm;
      },
    ),
    DynamicPickerScreen(
      headline: 'What religion do you follow?',
      itemList: kReligionsList.map((e) => Center(child: Text(e))).toList(),
      initialItem: 0,
      onSelectedItemChanged: (int value) {
        // if value is 0, delete religion
        value != 0
            ? SettingsData.instance.religion = kReligionsList[value]
            : SettingsData.instance.religion = '';
      },
    ),
    DynamicPickerScreen(
      headline: 'What is your zodiac sign?',
      itemList: kZodiacsList.map((e) => Center(child: Text(e))).toList(),
      initialItem: 0,
      onSelectedItemChanged: (int value) {
        // if value is 0, delete zodiac
        value != 0
            ? SettingsData.instance.zodiac = kZodiacsList[value]
            : SettingsData.instance.zodiac = '';
      },
    ),
    KidsScreen(
      onboardingMode: true,
    ),
    DrinkingScreen(
      onboardingMode: true,
    ),
    FitnessScreen(
      onboardingMode: true,
    ),
    SmokingScreen(
      onboardingMode: true,
    ),
    MyHobbiesScreen(
      onboardingMode: true,
    ),
    MyPetsScreen(
      onboardingMode: true,
    ),
    CovidScreen(
      onboardingMode: true,
    )
  ];

  late final PageController _pageController;

  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
        notifier: SettingsData.instance,
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            extendBody: true,
            backgroundColor: kBackroundThemeColor,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: ProgressBar(
                      totalProgressBarPages: pages.length,
                      page: currentPage.toDouble() + 1,
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      children: pages,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Get.offAllNamed(OnboardingFlowController.instance
                                .nextRoute(FinishOnboardingScreen.routeName));
                          },
                          child: Text(
                            'Skip all',
                            style: kButtonText.copyWith(
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        pages[currentPage] != pages.last
                            ? RoundedButton(
                                name: 'Next',
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  _pageController.animateToPage(currentPage + 1,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.fastOutSlowIn);
                                },
                              )
                            : RoundedButton(
                                name: 'Complete',
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Get.offAllNamed(OnboardingFlowController
                                      .instance
                                      .nextRoute(
                                          FinishOnboardingScreen.routeName));
                                }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
