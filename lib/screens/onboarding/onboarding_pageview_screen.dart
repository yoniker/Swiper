import 'package:betabeta/constants/onboarding_consts.dart';
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
import 'package:betabeta/screens/onboarding/upload_images_onboarding_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';

class OnboardingPageViewScreen extends StatefulWidget {
  static const String routeName = '/onboarding_page_view_screen';
  const OnboardingPageViewScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingPageViewScreen> createState() =>
      _OnboardingPageViewScreenState();
}

class _OnboardingPageViewScreenState extends State<OnboardingPageViewScreen> {
  int currentPage = 0;

  List<Widget> pages = [
    NotificationsPermissionScreen(),
    TermsScreen(),
    GetNameScreen(),
    BirthdayOnboardingScreen(),
    PronounScreen(),
    OrientationScreen(),
    RelationshipTypeOnboardingScreen(),
    AboutMeOnboardingScreen(),
    UploadImagesOnboardingScreen(),
    LocationPermissionScreen(),
    FinishOnboardingScreen()
  ];

  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: currentPage);
    super.initState();
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
                    controller: _pageController,
                    children: pages,
                    onPageChanged: (page) {
                      setState(
                        () {
                          currentPage = page;
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          'Skip all',
                          style: kButtonText.copyWith(
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
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
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
