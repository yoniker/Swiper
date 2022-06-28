import 'package:betabeta/constants/beta_icon_paths.dart';
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
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/image_filterview_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:betabeta/widgets/text_search_view_widget.dart';
import 'package:betabeta/widgets/voila_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static int selectedTabIndex = MainNavigationScreen.MATCHING_PAGE_INDEX;

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
      default:
        return VoilaLogoWidget();
    }
    return VoilaLogoWidget();
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
    // showModalBottomSheet(
    //     elevation: 5,
    //     isScrollControlled: true,
    //     barrierColor: Colors.transparent,
    //     constraints: BoxConstraints(
    //         maxHeight: MediaQuery.of(context).size.height * 0.85),
    //     backgroundColor: Colors.transparent,
    //     context: context,
    //     builder: (context) {
    //       return VoilaPage();
    //     });
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
    super.initState();

    // initialize the `_selectedTabIndex` variable with the value provided by appstate
    selectedTabIndex = AppStateInfo.instance.latestTabOnMainNavigation;
    MainNavigationScreen.pageController =
        PageController(initialPage: selectedTabIndex);

    // initialize the pageController with necessary values.
  }

  @override
  Widget build(BuildContext context) {
    print('Building main navigation screen!!!!!!!!!!!!!!');
    AppStateInfo.instance.latestTabOnMainNavigation =
        selectedTabIndex; //TODO ugly as I mentioned at the comments at the Appstate,switch with a better solution when available
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          appBar: CustomAppBar(
            hasVerticalPadding: false,
            centerWidget: ListenerWidget(
                notifier: SettingsData.instance,
                builder: (BuildContext) {
                  return GestureDetector(
                    onTap:
                        SettingsData.instance.filterType != FilterType.NONE &&
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
            trailing: AnimatedOpacity(
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
                icon: Icon(
                  Icons.search,
                  size: 35,
                ),
                activeIcon: Stack(
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
                          shape: BoxShape.circle, color: Colors.white),
                    )
                  ],
                ),
                label: '',
                tooltip: 'Match',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.comments, size: 26),
                activeIcon: Icon(
                  FontAwesomeIcons.solidComments,
                  size: 26,
                ),
                label: '',
                tooltip: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user, size: 27),
                activeIcon: Icon(
                  FontAwesomeIcons.userAlt,
                  size: 27,
                ),
                label: '',
                tooltip: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
