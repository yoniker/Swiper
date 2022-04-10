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
  static const int VOILA_PAGE_INDEX = 1;
  static const int MATCHING_PAGE_INDEX = 0;
  static const int CONVERSATIONS_PAGE_INDEX = 2;
  static const String routeName = '/main_navigation_screen';
  static const String TAB_INDEX_PARAM = 'tab_index';
  static late PageController pageController;
  MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  static int selectedTabIndex = 0;

  // List of pages.
  List<Widget> pages = <Widget>[
    // ProfileTab(),
    MatchScreen(
      key: Key('Match Screen'),
    ),
    VoilaPage(),
    ConversationsScreen(),
  ];

  Widget buildCenterWidget() {
    switch (SettingsData.instance.filterType) {
      case FilterType.TEXT_SEARCH:
        if (SettingsData.instance.textSearch.length > 0 &&
            selectedTabIndex != MainNavigationScreen.CONVERSATIONS_PAGE_INDEX)
          return TextSearchViewWidget();
        break;
      case FilterType.CELEB_IMAGE:
      case FilterType.CUSTOM_IMAGE:
        if (selectedTabIndex != MainNavigationScreen.CONVERSATIONS_PAGE_INDEX)
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
            centerWidget: ListenerWidget(
                notifier: SettingsData.instance,
                builder: (BuildContext) {
                  return GestureDetector(
                    onTap: SettingsData.instance.filterType !=
                                FilterType.NONE &&
                            selectedTabIndex !=
                                MainNavigationScreen.CONVERSATIONS_PAGE_INDEX
                        ? () {
                            MainNavigationScreen.pageController.animateToPage(1,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.fastOutSlowIn);
                          }
                        : null,
                    child: buildCenterWidget(),
                  );
                }),
            hasTopPadding: true,
            hasBackButton: false,
            customTitle: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(ProfileScreen.routeName);
                      },
                      child: CircularUserAvatar(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            trailing: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: selectedTabIndex ==
                      MainNavigationScreen.CONVERSATIONS_PAGE_INDEX
                  ? 0
                  : 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Image.asset(
                    'assets/images/settings.png',
                    scale: 12,
                  ),
                  onTap: selectedTabIndex ==
                          MainNavigationScreen.CONVERSATIONS_PAGE_INDEX
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
            backgroundColor: Colors.black,
            selectedLabelStyle: boldTextStyle.copyWith(color: Colors.red),
            unselectedLabelStyle: boldTextStyle.copyWith(
              color: darkTextColor,
              fontSize: 13.0,
            ),
            selectedItemColor:
                selectedTabIndex == 1 ? goldColorish : mainAppColor02,
            unselectedItemColor: unselectedTabColor,
            showUnselectedLabels: true,
            elevation: 0.0,
            currentIndex: selectedTabIndex,
            onTap: (index) {
              switchTab(index);

              // then jump to the new page.
            },
            items: [
              BottomNavigationBarItem(
                icon: DoubleIconToStack(
                    FontAwesomeIcons.addressCard, FontAwesomeIcons.addressCard),
                activeIcon: DoubleIconToStack(FontAwesomeIcons.addressCard,
                    FontAwesomeIcons.solidAddressCard),
                label: 'Match',
                tooltip: 'Match',
              ),
              BottomNavigationBarItem(
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveVoilaTabIconPath,
                  width: 30,
                  color: unselectedTabColor,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeVoilaTabIconPath,
                  width: 30,
                ),
                label: 'Search',
                tooltip: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.comments,
                ),
                activeIcon: Icon(FontAwesomeIcons.solidComments),
                label: 'Chat',
                tooltip: 'Chat',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
