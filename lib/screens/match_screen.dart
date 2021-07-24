import 'dart:math' as math;

import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/draggable.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MatchScreen extends StatefulWidget {
  static const String routeName = '/match_screen';
  MatchScreen({Key key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  // Todo: Add the implementation for detecting the changeCount.
  // holds a boolean value whether or not a user can undo his/her previous Macth Decision.
  bool canUndo = false;

  // Initialize the Animation Controller for the exposure of the revert button when a change
  // is discovered.
  AnimationController _animationController;

  // Holds a boolean value whether or not to hide the MatchCard.
  //
  // Note: This option must be set to false whenever you navigate to another Route (and true otherwise)
  // from the Match Screen, so, it is best you call the "setVisiblity" method before you perform any form of navigation
  // you intend to perform as this method sets the current value for the "_matchCardIsVisible" boolean object.
  //
  // This is necessary since all navigation from the Match Screen are always prevented because of the overlay concept
  // in use in the screen.
  //
  // When you plan to navigate to any screen it is essential that this is set to true to make sure the overlay screen stay
  // hidden.
  //
  // This is useful in that when we want to push (Navigate to) a new [Route] over [this]
  // the current [Route], we don't want the overlay to Obscure the New Route we are pushing to.
  //
  // Whenever you wish to push to a new route consider using the "pushToScreen" method defined
  // in the class below.
  bool _matchCardIsVisible = true;

  /// Make the MatchCard Invisible by setting the variable "_matchCardIsVisible"
  /// to false.
  ///
  /// Note: This should be called whenever you are planning to Navigate from this Screen to a new
  /// one.
  void setMatchCardVisibility([bool visbility = false]) {
    setState(() {
      _matchCardIsVisible = visbility;
    });
  }

  // initState Declaration.
  @override
  void initState() {
    super.initState();

    // Instantiate and Initialize the Animation Controller and the respective Animation.
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      upperBound: 1.0,
      lowerBound: 0.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // dispose the Animation Controller instance.
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).padding,
      child: Column(
        children: [
          CustomAppBar(
            customTitleBuilder: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // We use the built in Consumer widget of the Provider package as a wrapper
                  // around the "revert" button.
                  // What this essentially does is that it listens for any change in the MatchEngine
                  // and rebuilds the "revert" button widget to relect it.
                  Consumer<MatchEngine>(
                    // We explicitly pass the "child" parameter to the Consumer widget
                    // this makes sure that everytime the Consumer Widget is being rebuilt
                    // Flutter does not re-build this particular "child" widget.
                    // This thus helps us to tone up the App's performance a little.
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(
                            Icons.refresh,
                            size: 24.0,
                            color: colorBlend01,
                          ),
                        ),
                      ),
                      onTap: () {
                        // Move to the prevoious Match Deducted by the Match Engine.
                        Provider.of<MatchEngine>(
                          context,
                          listen: false,
                        ).goBack();
                      },
                    ),

                    builder: (context, matchEngine, child) {
                      if (matchEngine.previousMatchExists()) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }

                      //
                      double getAnimatedValue(num value) {
                        return _animationController.value * value;
                      }

                      return AnimatedBuilder(
                        animation: _animationController,
                        child: child,
                        builder: (context, child) {
                          return Opacity(
                            opacity: getAnimatedValue(1.0),
                            child: Container(
                              width: getAnimatedValue(30.0),
                              child: child,
                              transform: Matrix4.identity()
                                ..setTranslationRaw(
                                  getAnimatedValue(1.0),
                                  0.0,
                                  0.0,
                                ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Text(
                    'Discover',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            showAppLogo: false,
            hasBackButton: false,
            trailing: GestureDetector(
              child: Icon(Icons.settings,size:35),
              onTap: () async {
                // hide the overlay.
                setMatchCardVisibility(false);

                // Navigate savely to the Settings screen.
                await Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) {
                    return SwipeSettingsScreen();
                  }),
                ).then((value) {
                  // make the match card visible.
                  setMatchCardVisibility(true);
                });
              },
            ),
          ),

          // create the card stack.
          // Wrap in expanded to allow the card to take up the maximum
          // possible space.
          Expanded(
            child: Visibility(
              visible: _matchCardIsVisible,
              child: MatchCardBuilder(
                onNavigationCallback: (value) {
                  setMatchCardVisibility(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The card Widget used to display match Information.
class MatchCardBuilder extends StatefulWidget {
  MatchCardBuilder({Key key, @required this.onNavigationCallback})
      : super(key: key);

  final void Function(bool) onNavigationCallback;

  @override
  _MatchCardBuilderState createState() => _MatchCardBuilderState();
}

//
class _MatchCardBuilderState extends State<MatchCardBuilder> {
  double bottomCardScale = 0.95;
  Offset bottomCardOffset = Offset(0.0, 1.7);

  /// Deduce what direction to be registered for specific [Decision]s.
  ///
  /// called to determine the [SlideDirection] the MatchCard should be Dragged to.
  SlideDirection _desiredSlideOutDirection() {
    switch (Provider.of<MatchEngine>(context, listen: false)
        .currentMatch()
        .decision) {
      case Decision.nope:
        return SlideDirection.left;
        break;
      case Decision.like:
        return SlideDirection.right;
        break;
      case Decision.superLike:
        return SlideDirection.up;
        break;
      default:
        return null;
    }
  }

  /// Called whenever you start to Drag the [MatchCard].
  ///
  /// Used to update the UI accordingly.
  void _onSlideUpdate(double distance) {
    setState(() {
      // sort the new middle card [Scale] and [Offset] value.
      // make increment based on the distance the card has been slided.
      var bottomDyIncrement = (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
      bottomCardScale = 0.87 + (0.1 * (distance / 50.0)).clamp(0.0, 0.1);
      bottomCardOffset = Offset(0.0, 1.275 + bottomDyIncrement);
    });
  }

  /// Called whenever you stop Dragging the [MatchCard].
  void _onSlideComplete(SlideDirection direction) {
    Decision decision = Decision.indecided;

    switch (direction) {
      case SlideDirection.left:
        decision = Decision.nope;
        break;
      case SlideDirection.right:
        decision = Decision.like;
        break;
      case SlideDirection.up:
        decision = Decision.superLike;
        break;
    }

    Provider.of<MatchEngine>(context, listen: false)
        .currentMatchDecision(decision);

    setState(() {
      bottomCardScale = 0.95;
      bottomCardOffset = Offset(0.0, 1.7);
    });
  }

  Widget _bottomCard() {
    var nextMatch =
        Provider.of<MatchEngine>(context, listen: false).nextMatch();

    if (nextMatch != null) {
      return DraggableCard(
        onNavigationCallback: (value) {
          // this triggers the MatchScreen to hide the MatchCard stack.
          widget.onNavigationCallback(value);
        },
        screenHeight: MediaQuery.of(context).size.height,
        screenWidth: MediaQuery.of(context).size.width,
        isDraggable: false,
        canScroll: false,
        card: Transform.scale(
          scale: bottomCardScale,
          alignment: Alignment(bottomCardOffset.dx, bottomCardOffset.dy),
          child: Opacity(
            opacity: bottomCardScale.clamp(0.0, 1.0),
            child: MatchCard(
              profile: nextMatch.profile,
              showCarousel: false,
              clickable: false,
            ),
          ),
        ),
      );
    } else {
      // show an empty container.
      return SizedBox.shrink();
    }
  }

  // The Widget stacked at the top. This is the main Widget.
  Widget _topCard() {
    var currentMatch =
        Provider.of<MatchEngine>(context, listen: false).currentMatch();

    if (currentMatch != null) {
      return DraggableCard(
        onNavigationCallback: (value) {
          // this triggers the MatchScreen to hide the MatchCard stack.
          widget.onNavigationCallback(value);
        },
        screenHeight: MediaQuery.of(context).size.height,
        screenWidth: MediaQuery.of(context).size.width,
        slideTo: _desiredSlideOutDirection(),
        onSlideUpdate: _onSlideUpdate,
        onSlideComplete: _onSlideComplete,
        isDraggable: true,
        canScroll: true,
        card: MatchCard(
          key: Key(currentMatch.profile.username),
          profile: currentMatch.profile,
          showCarousel: true,
          clickable: true,
        ),
        matchProfile: currentMatch.profile,
      );
    } else {
      // show a progress indicator.
      // Note: A progress indicator is shown only on the `_topStack` [Widget].
      // when no match is yet found or the MatchEngine is still loading/initializing.
      return SpinKitChasingDots(
        size: 20.0,
        color: Colors.blue,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // return a stack of cards well positioned.
    return Consumer<MatchEngine>(
      builder: (context, matchEngine, child) {
        return Stack(
          children: <Widget>[
            _bottomCard(),
            _topCard(),
          ],
        );
      },
    );
  }
}
