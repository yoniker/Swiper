import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/advanced_settings_screen.dart';
import 'package:betabeta/screens/conversations_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/view_likes_screen.dart';
import 'package:betabeta/screens/voila_page.dart';
import 'package:betabeta/services/app_state_info.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavigationScreen extends StatefulWidget {
  static const int PROFILE_PAGE_INDEX = 0;
  static const int MATCHING_PAGE_INDEX = 1;
  static const int LIKE_PAGE_INDEX = 2;
  static const int CONVERSATIONS_PAGE_INDEX = 3;
  static const String routeName = '/main_navigation_screen';
  static const String TAB_INDEX_PARAM = 'tab_index';
  MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedTabIndex = 0;
  // create a pageController variable to control the varoius pages
  PageController? _pageController;

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
      pageSnapping: false,
      controller: _pageController,
      // This prevents user from being able to manually swipe to
      // another page.
      physics: NeverScrollableScrollPhysics(),
      children: pages,
      onPageChanged: (index) {
        switchTab(index);
      },
    );
  }

  void switchTab(int index) {
    //<debug>
    print('GOING TO PAGE:- index ~$index');
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // initialize the `_selectedTabIndex` variable with the value provided by appstate
    _selectedTabIndex = AppStateInfo.instance.latestTabOnMainNavigation;

    // initialize the pageController with necessary values.
    _pageController = PageController(initialPage: _selectedTabIndex);
  }

  @override
  void dispose() {
    // dispose off the pageController we created for our pages
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStateInfo.instance.latestTabOnMainNavigation =
        _selectedTabIndex; //TODO ugly as I mentioned at the comments at the Appstate,switch with a better solution when available
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
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
                _selectedTabIndex == 1 ? goldColorish : mainAppColor02,
            unselectedItemColor: unselectedTabColor,
            showUnselectedLabels: true,
            elevation: 0.0,
            currentIndex: _selectedTabIndex,
            onTap: (index) {
              switchTab(index);

              // then jump to the new page.
              _pageController!.jumpToPage(index);
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
                label: 'Voilà',
                tooltip: 'Voilà',
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
