import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/chat/conversations_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/voila_page.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:animations/animations.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavigationScreen extends StatefulWidget {
  static const int PROFILE_PAGE_INDEX = 0;
  static const int MATCHING_PAGE_INDEX = 1;
  static const int CONVERSATIONS_PAGE_INDEX = 2;
  static const String routeName = '/main_navigation_screen';
  static const String TAB_INDEX_PARAM = 'tab_index';
  static late PageController pageController;
  MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static int selectedTabIndex = 0;
  // create a pageController variable to control the varoius pages

  // List of pages.
  List<Widget> pages = <Widget>[
    // ProfileTab(),
    MatchScreen(
      key: Key('Match Screen'),
    ),
    VoilaPage(),
    ConversationsScreen(),
  ];

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

  @override
  void initState() {
    super.initState();
    // initialize the `_selectedTabIndex` variable with the value provided by appstate
    selectedTabIndex = AppStateInfo.instance.latestTabOnMainNavigation;
    MainNavigationScreen.pageController = PageController(initialPage: 1);

    // initialize the pageController with necessary values.
  }

  @override
  void dispose() {
    // dispose off the pageController we created for our pages
    super.dispose();
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
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveMatchTabIconPath,
                  color: unselectedTabColor,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeMatchTabIconPath,
                  color: mainAppColor02,
                ),
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
                label: 'Filters',
                tooltip: 'Filters',
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
