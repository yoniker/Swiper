import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/widgets/cards.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:betabeta/widgets/title_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MatchScreen extends StatefulWidget {
  MatchScreen({Key key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {

  // //
  // var _defaultTextStyle = TextStyle(
  //   color: Colors.black,
  //   fontFamily: 'Nunito',
  //   fontSize: 15,
  //   fontWeight: FontWeight.w500,
  // );

  // var _varryingTextStyle = TextStyle(
  //   color: Colors.black,
  //   fontFamily: 'Nunito',
  //   fontSize: 16,
  //   fontWeight: FontWeight.w700,
  // );

  @override
  Widget build(BuildContext context) {
    // call super.build() method to facilite the preservation of our state.
    // super.build(context);

    return Padding(
          padding: MediaQuery.of(context).padding,
          child: Column(
            children: [
              // Create a BetaAppBar.
              BetaAppBar(
                title: 'Discover',
                hasBackButton: false,
                iconURI: BetaIconPaths.profileIcon,
              ),

              // create the card stack.
              MatchCardBuilder(),
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
  Offset middleStackOffset = Offset(0.0, 1.5);

  // The stack and offset of the second Match card stacked at the back of the current one.
  double bottomStackScale = 0.8;
  Offset bottomStackOffset = Offset(0.0, 1.15);

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
      middleStackScale = 0.9 + (0.5 * (distance / 100.0)).clamp(0.0, 0.1);
      middleStackOffset = Offset(0.0, 1.4 + middleDyIncrement);

      // sort the new middle card [Scale] and [Offset] value.
      // make increment based on the distance the card has been slided.
      var bottomDyIncrement = (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
      bottomStackScale = 0.8 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
      bottomStackOffset = Offset(0.0, 1.05 + bottomDyIncrement);
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
            color: darkCardColor.withOpacity(0.6),
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
        card: Transform.scale(
          scale: middleStackScale,
          alignment: Alignment(middleStackOffset.dx, middleStackOffset.dy),
          child: MatchCard(
            profile: nextMatch.profile,
            showCarousel: false,
            clickable: false,
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
        isDraggable: true,
        card: MatchCard(
          key: Key(currentMatch.profile.username),
          profile: currentMatch.profile,
          showCarousel: true,
          clickable: true,
        ),
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
  void initState() {
    super.initState();

    // initialize the match engine.
    _initEngine();
  }

  @override
  Widget build(BuildContext context) {
    // return a stack of cards well positioned.
    return Consumer<MatchEngine>(
      builder: (context, matchEngine, child) {
        return Expanded(
          child: Stack(
            children: <Widget>[
              // The last stack at the bottom.
              _bottomStack(),

              // The [MatchCard] stacked in the middle.
              _middleStack(),

              // The main [MatchCard] currently in Focus.
              _topStack(),
            ],
          ),
        );
      },
    );
  }
}
