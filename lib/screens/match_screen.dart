import 'dart:math' as math;

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tcard/tcard.dart';

class MatchScreen extends StatefulWidget {
  static const String routeName = '/match_screen';
  MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  // Todo: Add the implementation for detecting the changeCount.
  // holds a boolean value whether or not a user can undo his/her previous Match Decision.
  bool canUndo = false;

  // Initialize the Animation Controller for the exposure of the revert button when a change
  // is discovered.
  late AnimationController _animationController;

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
  void setMatchCardVisibility([bool visibility = false]) {
    setState(() {
      _matchCardIsVisible = visibility;
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
            customTitle: Container(
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
              child: Icon(Icons.person_search, size: 35,color: colorBlend02,),
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
                setMatchCardVisibility: (value) {
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
  MatchCardBuilder({Key? key, required this.setMatchCardVisibility})
      : super(key: key);

  final void Function(bool) setMatchCardVisibility;
  final maxThumbOpacity = 0.7; // Max opacity of the thumbs feedback (when swiping left/right)

  @override
  _MatchCardBuilderState createState() => _MatchCardBuilderState();
}

//
class _MatchCardBuilderState extends State<MatchCardBuilder> {
  double bottomCardScale = 0.95;
  Offset bottomCardOffset = Offset(0.0, 1.7);
  SwipeDirection? currentJudgment;
  late double currentInterpolation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // return a stack of cards well positioned.
    return Consumer<MatchEngine>(
      builder: (context, matchEngine, unusedChild) {
         List<Match?> topEngineMatches = [
          if (matchEngine.currentMatch() != null) matchEngine.currentMatch(),
          if (matchEngine.nextMatch() != null) matchEngine.nextMatch()
        ];

         Widget _buildThumbIcon() {
           if (currentJudgment == SwipeDirection.Right){
             return Center(
               child: Opacity(
                 opacity: currentInterpolation*widget.maxThumbOpacity,
                 child: Transform.scale(
                   scale: currentInterpolation,
                   child: Icon(
                     Icons.thumb_up,
                     size: 100.0,
                     color: Colors.green,
                   ),
                 ),
               ),
             );
           }
           if (currentJudgment == SwipeDirection.Left){
           return Center(
             child: Opacity(
               opacity: currentInterpolation*widget.maxThumbOpacity,
               child: Transform.scale(
                 scale: currentInterpolation,
                 child: Icon(
                   Icons.thumb_down,
                   size: 100.0,
                   color: Colors.red,
                 ),
               ),
             ),
           );}



           return SizedBox.shrink();

         }

        return topEngineMatches.isEmpty
            ? SpinKitChasingDots(
                size: 20.0,
                color: Colors.blue,
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                   TCard(

                     onDragCard: (double interpolation,SwipeDirection direction){
                       setState(() {


                       currentInterpolation = interpolation;
                       currentJudgment = direction;
                       });
                       return;

                     },
                     delaySlideFor: 0,
                    onForward: (int index,SwipeInfo info){
                      if (index ==0){ //TODO index>0 should be impossible
                        if(info.direction == SwipeDirection.Left){
                          matchEngine.currentMatchDecision(Decision.nope);
                        }
                        else if (info.direction == SwipeDirection.Right){
                          matchEngine.currentMatchDecision(Decision.like);
                        }
                      }
                    },




                    cards: topEngineMatches.map<Widget>((match) {
                      return
                         MatchCard(
                          key: Key(match!.profile!.userId!.id!),
                          profile: match.profile,
                          showCarousel: true,
                          clickable: true,
                        );

                    }).toList(),
                  ),
                  _buildThumbIcon(),
                ],
              );
      },
    );
  }
}
