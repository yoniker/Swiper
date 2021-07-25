import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/main_messages_screen.dart';
import 'package:betabeta/screens/match_screen.dart';
import 'package:betabeta/screens/view_likes_screen.dart';
import 'package:betabeta/tabs/profile_tab.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = '/navigation_screen';
  MainNavigationScreen({Key key, this.pageIndex = 1}) : super(key: key);

  final int pageIndex;

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  /// holds the value of the current index form 0 to 3.
  int _selectedTabIndex = 0;

  // create a pageController variable to control the varoius pages
  PageController _pageController;

  // List of pages.
  List<Widget> pages = <Widget>[
    // ProfileTab(),
    ProfileTabRedo(),
    MatchScreen(
      key: Key('Match Screen'),
    ),
    ViewLikesScreen(),
    MainMessagesScreen(),
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

    // initialize the `_selectedTabIndex` variable with the
    // value provided.
    _selectedTabIndex = widget.pageIndex;

    // initialize the pageController with necessary values.
    _pageController = PageController(initialPage: _selectedTabIndex);
  }

  @override
  void dispose() {
    // dispose off the pageController we created for our pages
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      
      children: [
        Scaffold(
          body: _body(),
          extendBody: true,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: boldTextStyle.copyWith(color: Colors.red),
            selectedItemColor: Colors.red[400],
            elevation: 0.0,
            currentIndex: _selectedTabIndex,
            onTap: (index) {
              switchTab(index);

              // then jump to the new page.
              _pageController.jumpToPage(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveProfileTabIconPath,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeProfileTabIconPath,
                ),
                label: 'profile',
                tooltip: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveMatchTabIconPath,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeMatchTabIconPath,
                ),
                label: 'match',
                tooltip: 'Match',
              ),
              BottomNavigationBarItem(
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveLikesTabIconPath,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeLikesTabIconPath,
                ),
                label: 'likes',
                tooltip: 'Likes',
              ),
              BottomNavigationBarItem(
                icon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.inactiveMessagesTabIconPath,
                ),
                activeIcon: PrecachedImage.asset(
                  imageURI: BetaIconPaths.activeMessagesTabIconPath,
                ),
                label: 'messages',
                tooltip: 'Messages',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
