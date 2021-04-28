import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/draggable.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MatchScreen extends StatefulWidget {
  MatchScreen({Key key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  // Todo: Add the implementation for detecting the changeCount.
  // holds the value for the number of undos that can be made by users.
  bool canUndo = false;

  // Initialize the Animation Controller for the exposure of the revert button when a change
  // is discovered.
  AnimationController _animationController;

  // The actual Slide Animation literal.
  // Animation<Offset> _slideAnimation;

  // // The actual Size Animation literal.
  // Animation<double> _sizeAnimation;

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
          // Create a CustomAppBar.
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
                        child: Icon(
                          Icons.undo,
                          size: 24.0,
                          color: colorBlend01,
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

                    builder: (context, value, child) {
                      // Holds a boolean value that determines whether or not users can revert their Decisions
                      // and move to previous Matches.
                      bool canUndo = value?.previousMatchExists();

                      if (canUndo) {
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
                              // padding: EdeIN,
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
            showAppLogo: true,
            hasBackButton: false,
            icon: GlobalWidgets.imageToIcon(BetaIconPaths.settingsBarIcon),
          ),

          // create the card stack.
          // Wrap in expanded to allow the card to take up the maximum
          // possible space.
          Expanded(
            child: MatchCardBuilder(),
          ),
        ],
      ),
    );
  }

  // @override
  // // This necessarily helps to preserve the state of our App.
  // bool get wantKeepAlive => true;
}

/// The card Widget used to display match Information.
class MatchCardBuilder extends StatefulWidget {
  MatchCardBuilder({Key key}) : super(key: key);

  @override
  _MatchCardBuilderState createState() => _MatchCardBuilderState();
}

//
class _MatchCardBuilderState extends State<MatchCardBuilder> {
  // The stack and offset of the first Matchcard stacked at the back of the current one.
  double middleStackScale = 0.95;
  Offset middleStackOffset = Offset(0.0, 1.7);

  // The stack and offset of the second Match card stacked at the back of the current one.
  double bottomStackScale = 0.75;
  Offset bottomStackOffset = Offset(0.0, 0.87);

  // The controller that controls how each match card slides when a valid Decision is made.
  var _matchPageController;

  @override
  void initState() {
    super.initState();

    // initialize the match engine.
    _initEngine();

    // Initialize the [PageController] with values.
    _matchPageController = PageController(initialPage: 0);
  }

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
      var middleDyIncrement = (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
      middleStackScale = 0.87 + (0.1 * (distance / 50.0)).clamp(0.0, 0.1);
      middleStackOffset = Offset(0.0, 1.275 + middleDyIncrement);

      // sort the new middle card [Scale] and [Offset] value.
      // make increment based on the distance the card has been slided.
      var bottomDyIncrement = (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
      bottomStackScale = 0.75 + (0.05 * (distance / 70.0)).clamp(0.0, 0.05);
      bottomStackOffset = Offset(0.0, 0.82 + bottomDyIncrement);
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
      middleStackScale = 0.95;
      middleStackOffset = Offset(0.0, 1.7);
    });
  }

  /// The Widget stacked at the bottom of the Stack of cards.
  Widget _bottomStack() {
    var nextMatch =
        Provider.of<MatchEngine>(context, listen: false).nextMatch();

    if (nextMatch != null) {
      return Transform.scale(
        scale: bottomStackScale,
        alignment: Alignment(bottomStackOffset.dx, bottomStackOffset.dy),
        // transform: Matrix4.identity()..translate(bottomStackOffset.dx, bottomStackOffset.dy)..scale(bottomStackScale, bottomStackScale),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      );
    } else {
      // show an empty container.
      return Container();
    }
  }

  // The Widget stacked in the middle of `_bottomStack` and `_topStack`.
  Widget _middleStack() {
    var nextMatch =
        Provider.of<MatchEngine>(context, listen: false).nextMatch();

    if (nextMatch != null) {
      return DraggableCard(
        screenHeight: MediaQuery.of(context).size.height,
        screenWidth: MediaQuery.of(context).size.width,
        isDraggable: false,
        canScroll: false,
        card: Transform.scale(
          scale: middleStackScale,
          alignment: Alignment(middleStackOffset.dx, middleStackOffset.dy),
          child: Opacity(
            opacity: middleStackScale.clamp(0.0, 1.0),
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
      return Container();
    }
  }

  // The Widget stacked at the top. This is the main Widget.
  Widget _topStack() {
    var currentMatch =
        Provider.of<MatchEngine>(context, listen: false).currentMatch();

    if (currentMatch != null) {
      return DraggableCard(
        screenHeight: MediaQuery.of(context).size.height,
        screenWidth: MediaQuery.of(context).size.width,
        slideTo: _desiredSlideOutDirection(),
        onSlideUpdate: _onSlideUpdate,
        onSlideComplete: _onSlideComplete,
        controller: _matchPageController,
        isDraggable: true,
        canScroll: true,
        card: MatchCard(
          key: Key(currentMatch.profile.username),
          profile: currentMatch.profile,
          showCarousel: true,
          clickable: true,
        ),
        mactchProfile: currentMatch.profile,
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

  // initialize the match engine.
  void _initEngine() async {
    await Provider.of<MatchEngine>(context, listen: false)
        .getMoreMatchesFromServer()
        .then((value) {
      // check if the Widget has been mounted to prevent state errors.
      if (mounted) setState(() {});
    });
  }

  // Adds more Match cards to the stack.
  void addCards() async {
    await Provider.of<MatchEngine>(context, listen: false)
        .getMoreMatchesFromServer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return a stack of cards well positioned.
    return Consumer<MatchEngine>(
      builder: (context, matchEngine, child) {
        return Stack(
          children: <Widget>[
            // The last stack at the bottom.
            // _bottomStack(),

            // The [MatchCard] stacked in the middle.
            _middleStack(),

            // The main [MatchCard] currently in Focus.
            _topStack(),
          ],
        );
      },
    );
  }
}

// Testing some concepts.
var test = PageView();

var test2 =
    SliverFillViewport(delegate: SliverChildBuilderDelegate((context, count) {
  return Container(
    color: Colors.green,
  );
}));
