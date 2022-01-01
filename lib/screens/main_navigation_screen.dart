import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/conversations_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/view_likes_screen.dart';
import 'package:betabeta/services/notifications_controller.dart';
import 'package:betabeta/tabs/profile_tab.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    ProfileTabRedo(),
    MatchScreen(
      key: Key('Match Screen'),
    ),
    ViewLikesScreen(),
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
    print('Current route at init state is ${Get.currentRoute}');
    // initialize the `_selectedTabIndex` variable with the
    // value provided.
    _selectedTabIndex = NotificationsController.instance.latestTabOnMainNavigation; //Ugly solution to a problem with two pushes after which route is only at the second route (chatscreen) when building mainnavscreen

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
    NotificationsController.instance.latestTabOnMainNavigation = _selectedTabIndex; //TODO ugly as I mentioned at the comments at the notifications controller,switch with a better solution when available
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          body: _body(),
          extendBody: true,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: boldTextStyle.copyWith(color: Colors.red),
            unselectedLabelStyle: boldTextStyle.copyWith(
              color: darkTextColor,
              fontSize: 13.0,
            ),
            selectedItemColor: colorBlend02,
            unselectedItemColor: darkTextColor,
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
                  imageURI: BetaIconPaths.inactiveProfileTabIconPath,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeProfileTabIconPath,
                ),
                label: 'Profile',
                tooltip: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveMatchTabIconPath,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeMatchTabIconPath,
                ),
                label: 'Match',
                tooltip: 'Match',
              ),
              BottomNavigationBarItem(
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveLikesTabIconPath,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeLikesTabIconPath,
                ),
                label: 'Likes',
                tooltip: 'Likes',
              ),
              BottomNavigationBarItem(
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveMessagesTabIconPath,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeMessagesTabIconPath,
                ),
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
