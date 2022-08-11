import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/chat/conversations_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/screens/voila_page.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:betabeta/services/app_tutorial_brain.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/animated_widgets/animated_their_taste_widget.dart';
import 'package:betabeta/widgets/circle_button.dart';
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/image_filterview_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/text_search_view_widget.dart';
import 'package:betabeta/widgets/voila_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../constants/global_keys.dart';

class MainNavigationScreen extends StatefulWidget {
  static const int PROFILE_PAGE_INDEX = 2;
  static const int MATCHING_PAGE_INDEX = 0;
  static const int CONVERSATIONS_PAGE_INDEX = 1;
  static const String routeName = '/main_navigation_screen';
  static const String TAB_INDEX_PARAM = 'tab_index';

  static late AnimationController appBarColorAnimationController;
  MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  static int selectedTabIndex = MainNavigationScreen.MATCHING_PAGE_INDEX;
  final bool startTutorial = Get.arguments ?? false;
  late bool pageIsTransparent = true;
  late AnimationController _controller;
  late PageController pageController;
  late Animation _backgroundColor;
  late Animation _animation;
  late List<Widget> pages;
  Future<void> switchTab(int index) async {
    //<debug>
    print('GOING TO PAGE:- index ~$index');
    await pageController.animateToPage(index,
        duration: Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
        curve: Curves.fastOutSlowIn);
    changeColor();
  }

  late AppTutorialBrain appTutorial;

  // List of pages.

  Widget buildCenterWidget() {
    switch (SettingsData.instance.filterType) {
      case FilterType.TEXT_SEARCH:
        if (SettingsData.instance.textSearch.length > 0 &&
            selectedTabIndex ==
                MainNavigationScreen
                    .MATCHING_PAGE_INDEX) //TODO Nitzan why is this condition here and why does it repeat itself?
          return TextSearchViewWidget();
        break;
      case FilterType.CELEB_IMAGE:
      case FilterType.CUSTOM_IMAGE:
        if (selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX)
          return ImageFilterViewWidget();
        break;
      case FilterType.THEIR_TASTE:
        if (selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX)
          return AnimatedTheirTasteWidget();
        break;
      default:
        return VoilaLogoWidget(
          logoOnlyMode: true,
          whiteLogo:
              selectedTabIndex == MainNavigationScreen.PROFILE_PAGE_INDEX,
        );
    }
    return VoilaLogoWidget(
      logoOnlyMode: true,
      whiteLogo: selectedTabIndex == MainNavigationScreen.PROFILE_PAGE_INDEX,
    );
  }

  Widget buildSettingWidget() {
    double settingsScale = 12;
    double padding = 5;
    switch (selectedTabIndex) {
      case MainNavigationScreen.PROFILE_PAGE_INDEX:
        return CircleButton(
          padding: EdgeInsets.all(padding),
          onPressed: () {
            Get.toNamed(AccountSettingsScreen.routeName);
          },
          child: Stack(
            children: [
              AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale:
                    selectedTabIndex != MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 0
                        : 1,
                child: Image.asset(
                  BetaIconPaths.voilaSwipeSettingsButtonPath,
                  scale: settingsScale,
                ),
              ),
              AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale:
                    selectedTabIndex != MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 1
                        : 0,
                child: Image.asset(
                  BetaIconPaths.settingsIconPath,
                  scale: 4,
                ),
              ),
            ],
          ),
        );

      case MainNavigationScreen.MATCHING_PAGE_INDEX:
        return CircleButton(
          padding: EdgeInsets.all(padding),
          onPressed: () {
            Get.toNamed(SwipeSettingsScreen.routeName);
          },
          child: Stack(
            children: [
              AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale:
                    selectedTabIndex != MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 0
                        : 1,
                child: Image.asset(
                  BetaIconPaths.voilaSwipeSettingsButtonPath,
                  scale: settingsScale,
                ),
              ),
              AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale:
                    selectedTabIndex != MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 1
                        : 0,
                child: Image.asset(
                  BetaIconPaths.settingsIconPath,
                  scale: 4,
                ),
              ),
            ],
          ),
        );
      case MainNavigationScreen.CONVERSATIONS_PAGE_INDEX:
        return CircleButton(
          padding: EdgeInsets.all(padding),
          onPressed: () {},
          child: Stack(
            children: [
              AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale:
                    selectedTabIndex != MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 0
                        : 0,
                child: Image.asset(
                  BetaIconPaths.voilaSwipeSettingsButtonPath,
                  scale: settingsScale,
                ),
              ),
              AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale:
                    selectedTabIndex != MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 0
                        : 0,
                child: Image.asset(
                  BetaIconPaths.settingsIconPath,
                  scale: 4,
                ),
              ),
            ],
          ),
        );
      default:
        return CircleButton(
          padding: EdgeInsets.all(padding),
          onPressed: () {},
          child: Stack(
            children: [
              AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale:
                    selectedTabIndex != MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 0
                        : 1,
                child: Image.asset(
                  BetaIconPaths.voilaSwipeSettingsButtonPath,
                  scale: settingsScale,
                ),
              ),
              AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale:
                    selectedTabIndex != MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 1
                        : 0,
                child: Image.asset(
                  BetaIconPaths.settingsIconPath,
                  scale: 4,
                ),
              ),
            ],
          ),
        );
    }
  }

  /// builds the widget's body.
  PageView _body() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: pages,
      controller: pageController,
      onPageChanged: (page) {
        setState(() {
          selectedTabIndex = page;
        });
      },
    );
  }

  void openVoilaSettings() {
    Get.toNamed(VoilaPage.routeName);
  }

  void changeColor() {
    if (MainNavigationScreen.appBarColorAnimationController.isCompleted &&
        selectedTabIndex != MainNavigationScreen.PROFILE_PAGE_INDEX)
      MainNavigationScreen.appBarColorAnimationController.reverse();
    else if (selectedTabIndex == MainNavigationScreen.PROFILE_PAGE_INDEX)
      MainNavigationScreen.appBarColorAnimationController.forward();
  }

  void startTutorialAgain() async {
    await switchTab(MainNavigationScreen.MATCHING_PAGE_INDEX);
    appTutorial.showTutorial(context);
  }

  void moveToMatchPage() {
    switchTab(MainNavigationScreen.MATCHING_PAGE_INDEX);
  }

  void moveToChatPage() {
    switchTab(MainNavigationScreen.CONVERSATIONS_PAGE_INDEX);
  }

  @override
  void initState() {
    pages = [
      // ProfileTab(),
      MatchScreen(
        key: Key('Match Screen'),
      ),
      ConversationsScreen(onClickKeepSwiping: moveToMatchPage),
      ProfileScreen(
        onStartTutorial: startTutorialAgain,
      ),
    ];
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..addListener(() {
            setState(() {});
          });
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    MainNavigationScreen.appBarColorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )
      ..addStatusListener((status) {})
      ..addListener(() {
        setState(() {});
      });
    _backgroundColor =
        ColorTween(begin: backgroundThemeColor, end: Colors.black).animate(
      CurvedAnimation(
          parent: MainNavigationScreen.appBarColorAnimationController,
          curve: Curves.easeIn),
    );
    appTutorial = AppTutorialBrain(
        moveToChatPage: moveToChatPage, moveBackToMatchPage: moveToMatchPage);

    super.initState();

    // initialize the `_selectedTabIndex` variable with the value provided by appstate
    selectedTabIndex = AppStateInfo.instance.latestTabOnMainNavigation;
    pageController = PageController(initialPage: selectedTabIndex);
    changeColor();
    if (startTutorial) {
      if (selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX)
        WidgetsBinding.instance.addPostFrameCallback((_) => Future.delayed(
            Duration(milliseconds: 200), appTutorial.showTutorial(context)));
    }
    // initialize the pageController with necessary values.
  }

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStateInfo.instance.latestTabOnMainNavigation =
        selectedTabIndex; //TODO ugly as I mentioned at the comments at the Appstate,switch with a better solution when available

    return Opacity(
      opacity: _animation.value,
      child: Scaffold(
        appBar: CustomAppBar(
          trailingPad: 0,
          hasVerticalPadding: false,
          backgroundColor: _backgroundColor.value,
          elevation: 0,
          centerWidget: ListenerWidget(
              notifier: SettingsData.instance,
              builder: (BuildContext) {
                return GestureDetector(
                  onTap: SettingsData.instance.filterType != FilterType.NONE &&
                          selectedTabIndex ==
                              MainNavigationScreen.MATCHING_PAGE_INDEX
                      ? () {
                          openVoilaSettings();
                        }
                      : null,
                  child: buildCenterWidget(),
                );
              }),
          hasTopPadding: true,
          hasBackButton: false,
          customTitle: Container(
            key: searchButton,
            padding: EdgeInsets.only(left: 18),
            child: GestureDetector(
              onTap:
                  selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX
                      ? () {
                          openVoilaSettings();
                        }
                      : null,
              child: AnimatedOpacity(
                opacity:
                    selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 1
                        : 0,
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                child: Image.asset(
                  BetaIconPaths.voilaSearchSettingsPath,
                  scale: 12,
                ),
              ),
            ),
          ),
          trailing: AnimatedOpacity(
              key: filterButton,
              duration:
                  Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
              opacity: selectedTabIndex ==
                          MainNavigationScreen.MATCHING_PAGE_INDEX ||
                      selectedTabIndex ==
                          MainNavigationScreen.PROFILE_PAGE_INDEX
                  ? 1
                  : 0,
              child: buildSettingWidget()),
        ),
        backgroundColor: kBackroundThemeColor,
        body: _body(),
        extendBody: true,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          backgroundColor: Colors.black.withOpacity(0.95),
          selectedLabelStyle:
              boldTextStyle.copyWith(color: Colors.red, fontSize: 0),
          unselectedLabelStyle: boldTextStyle.copyWith(
            color: darkTextColor,
            fontSize: 0.0,
          ),
          selectedItemColor: mainAppColor02,
          unselectedItemColor: unselectedTabColor,
          showUnselectedLabels: false,
          elevation: 0.0,
          currentIndex: selectedTabIndex,
          onTap: (index) async {
            await switchTab(index);

            // then jump to the new page.
          },
          items: [
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: 0.85,
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                child: Icon(
                  Icons.search,
                  size: 35,
                ),
              ),
              activeIcon: AnimatedScale(
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                scale: 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 35,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 7, 4),
                      height: 14,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: mainAppColor02),
                    )
                  ],
                ),
              ),
              label: '',
              tooltip: 'Match',
            ),
            BottomNavigationBarItem(
              icon: AnimatedScale(
                  duration:
                      Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                  scale: 0.85,
                  curve: Curves.easeInOut,
                  child: Icon(
                    FontAwesomeIcons.comments,
                    size: 26,
                  )),
              activeIcon: AnimatedScale(
                scale: 1,
                duration:
                    Duration(milliseconds: pageGeneralAnimationTimeInMillSec),
                child: Icon(
                  FontAwesomeIcons.solidComments,
                  size: 26,
                ),
              ),
              label: '',
              tooltip: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: CircularUserAvatar(
                borderColor: unselectedTabColor,
                maxRadius: 11,
              ),
              activeIcon: CircularUserAvatar(
                maxRadius: 13,
              ),
              label: '',
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
