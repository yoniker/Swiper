import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/chat/conversations_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/screens/voila_page.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/animated_widgets/animated_their_taste_widget.dart';
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/image_filterview_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/text_search_view_widget.dart';
import 'package:betabeta/widgets/voila_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MainNavigationScreen extends StatefulWidget {
  static const int PROFILE_PAGE_INDEX = 2;
  static const int MATCHING_PAGE_INDEX = 0;
  static const int CONVERSATIONS_PAGE_INDEX = 1;
  static const String routeName = '/main_navigation_screen';
  static const String TAB_INDEX_PARAM = 'tab_index';
  static late PageController pageController;
  MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  static int selectedTabIndex = MainNavigationScreen.MATCHING_PAGE_INDEX;
  final bool startTutorial = Get.arguments ?? false;
  late bool pageIsTransparent = true;
  late AnimationController _controller;
  late Animation _animation;

  late TutorialCoachMark VoilaTutorial;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey searchButton = GlobalKey();
  GlobalKey filterButton = GlobalKey();

  // List of pages.
  List<Widget> pages = <Widget>[
    // ProfileTab(),
    MatchScreen(
      key: Key('Match Screen'),
    ),
    ConversationsScreen(),
    ProfileScreen(),
  ];

  Widget buildCenterWidget() {
    switch (SettingsData.instance.filterType) {
      case FilterType.TEXT_SEARCH:
        if (SettingsData.instance.textSearch.length > 0 &&
            selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX)
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
        );
    }
    return VoilaLogoWidget(
      logoOnlyMode: true,
    );
  }

  /// builds the widget's body.
  PageView _body() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: pages,
      controller: MainNavigationScreen.pageController,
      onPageChanged: (page) {
        setState(() {
          selectedTabIndex = page;
        });
      },
    );
  }

  void switchTab(int index) {
    //<debug>
    print('GOING TO PAGE:- index ~$index');
    MainNavigationScreen.pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
  }

  void openVoilaSettings() {
    Get.toNamed(VoilaPage.routeName);
  }

  Widget DoubleIconToStack(IconData icon1, IconData icon2) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 4),
          child: Icon(icon1),
        ),
        Container(
          width: 27,
          color: Colors.black,
          child: Icon(icon2),
        ),
      ],
    );
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..addListener(() {
            setState(() {
              print(_animation.value);
            });
          });
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    if (selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX &&
        startTutorial) Future.delayed(Duration(seconds: 2), showTutorial);
    super.initState();

    // initialize the `_selectedTabIndex` variable with the value provided by appstate
    selectedTabIndex = AppStateInfo.instance.latestTabOnMainNavigation;
    MainNavigationScreen.pageController =
        PageController(initialPage: selectedTabIndex);

    // initialize the pageController with necessary values.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showTutorial() {
    initTargets();
    VoilaTutorial = TutorialCoachMark(
      context,
      hideSkip: true,
      alignSkip: Alignment.centerLeft,
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.7),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
        Get.toNamed(VoilaPage.routeName, arguments: true);
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: ($context) {
        showDialog(context: context, builder: (_) => Text('Test'));
        print('onClickOverlay: $context');
      },
      onSkip: () {
        print("skip");
      },
    )..show();
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "filterButtonAppBar",
        keyTarget: filterButton,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return GestureDetector(
                onTap: () {
                  print('clicked on overlay');
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Click here for basic filters",
                        style: LargeTitleStyleWhite,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          VoilaTutorial.next();
                        },
                        child: Text(
                          'NEXT',
                          style: LargeTitleStyleWhite.copyWith(
                              decoration: TextDecoration.underline,
                              color: Colors.blueAccent),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "SearchButtonAppBar",
        keyTarget: searchButton,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Click here for advanced search",
                      style: LargeTitleStyleWhite.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building main navigation screen!!!!!!!!!!!!!!');
    AppStateInfo.instance.latestTabOnMainNavigation =
        selectedTabIndex; //TODO ugly as I mentioned at the comments at the Appstate,switch with a better solution when available
    return Opacity(
      opacity: _animation.value,
      child: Scaffold(
        appBar: CustomAppBar(
          hasVerticalPadding: false,
          backgroundColor: backgroundThemeColorALT,
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
            padding: EdgeInsets.only(left: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  openVoilaSettings();
                },
                child: AnimatedOpacity(
                  opacity: selectedTabIndex ==
                          MainNavigationScreen.MATCHING_PAGE_INDEX
                      ? 1
                      : 0,
                  duration: Duration(milliseconds: 300),
                  child: Image.asset(
                    'assets/images/search.png',
                    scale: 12,
                  ),
                ),
              ),
            ),
          ),
          trailing: Row(
            children: [
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity:
                    selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 1
                        : 0,
                child: GestureDetector(
                  onTap: selectedTabIndex ==
                          MainNavigationScreen.MATCHING_PAGE_INDEX
                      ? () {
                          showTutorial();
                        }
                      : null,
                  child: Icon(Icons.info),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              AnimatedOpacity(
                key: filterButton,
                duration: Duration(milliseconds: 300),
                opacity:
                    selectedTabIndex == MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? 1
                        : 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    child: Image.asset(
                      'assets/images/settings.png',
                      scale: 12,
                    ),
                    onTap: selectedTabIndex !=
                            MainNavigationScreen.MATCHING_PAGE_INDEX
                        ? null
                        : () {
                            Get.toNamed(SwipeSettingsScreen.routeName);
                          },
                  ),
                ),
              ),
            ],
          ),
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
          onTap: (index) {
            switchTab(index);

            // then jump to the new page.
          },
          items: [
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: 0.85,
                duration: Duration(milliseconds: 200),
                child: Icon(
                  Icons.search,
                  size: 35,
                ),
              ),
              activeIcon: AnimatedScale(
                duration: Duration(milliseconds: 200),
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
                  duration: Duration(milliseconds: 200),
                  scale: 0.85,
                  curve: Curves.easeInOut,
                  child: Icon(
                    FontAwesomeIcons.comments,
                    size: 26,
                  )),
              activeIcon: AnimatedScale(
                scale: 1,
                duration: Duration(milliseconds: 200),
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
