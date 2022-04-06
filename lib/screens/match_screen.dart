import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:tcard/tcard.dart';

class MatchScreen extends StatefulWidget {
  static const String routeName = '/match_screen';
  MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with AutomaticKeepAliveClientMixin {
  // Todo: Add the implementation for detecting the changeCount.
  // holds a boolean value whether or not a user can undo his/her previous Match Decision.
  bool canUndo = false;

  /// Make the MatchCard Invisible by setting the variable "_matchCardIsVisible"
  /// to false.
  ///
  /// Note: This should be called whenever you are planning to Navigate from this Screen to a new
  /// one.

  // initState Declaration.

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundThemeColor,
      child: Padding(
        padding: MediaQuery.of(context).padding,
        child: Container(
          color: Colors.white70,
          child: Column(
            children: [
              // create the card stack.
              // Wrap in expanded to allow the card to take up the maximum
              // possible space.
              Expanded(
                child: MatchCardBuilder(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// The card Widget used to display match Information.
class MatchCardBuilder extends StatefulWidget {
  MatchCardBuilder({Key? key}) : super(key: key);

  final maxThumbOpacity =
      0.7; // Max opacity of the thumbs feedback (when swiping left/right)

  @override
  _MatchCardBuilderState createState() => _MatchCardBuilderState();
}

//
class _MatchCardBuilderState extends State<MatchCardBuilder>
    with SingleTickerProviderStateMixin {
  double bottomCardScale = 0.95;
  Offset bottomCardOffset = Offset(0.0, 1.7);
  SwipeDirection? currentJudgment;
  late double currentInterpolation;
  late AnimationController _animation =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));

  @override
  void initState() {
    _animation =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _animation.addListener(() {
      setState(() {});
    });
    _animation.repeat(reverse: true);
    super.initState();
  }

  Widget _widgetWhenNoCardsExist() {
    if (MatchEngine.instance.locationCountData.status ==
        LocationCountStatus.not_enough_users) {
      int? requiredNumUsers, currentNumUsers;
      requiredNumUsers =
          MatchEngine.instance.locationCountData.requiredNumUsers;
      currentNumUsers = MatchEngine.instance.locationCountData.currentNumUsers;
      double percents =
          (currentNumUsers ?? 0) / (requiredNumUsers ?? 250) * 100;
      return Column(
        children: [
          Text(
              'For Nitzan: Put something here when there are not enough users'),
          Text('For example: '),
          Text('Current number of users is $currentNumUsers'),
          Text(' number of users is $requiredNumUsers'),
          Text('In Percents it is $percents')
        ],
      );
    }

    if (MatchEngine.instance.locationCountData.status ==
        LocationCountStatus.unknown_location) {
      return Center(
        child: Text(
            'For Nitzan: Show widget when user location is unknown (maybe encourage him to activate gps?)'),
      );
    }

    if (MatchEngine.instance.locationCountData.status ==
        LocationCountStatus.initial_state) {
      return Center(
        child: Text(
            'For Nitzan: Show something when initializing (didnt get a response from server yet regrading how many users are in our area,are there enough etc)'),
      );
    }

    if (MatchEngine.instance.getServerSearchStatus ==
        MatchSearchStatus.not_found) {
      return Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: _animation.value * 10,
                child: Icon(
                  Icons.radar_outlined,
                  size: 100,
                  color: Colors.black12,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'No matches found with your current preferences. Check again soon to see new people.',
                style: kSmallInfoStyle.copyWith(color: Colors.black45),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              SettingsData.instance.filterType != FilterType.NONE
                  ? RoundedButton(
                      name: 'Deactivate filters',
                      elevation: 4,
                      onTap: () {
                        SettingsData.instance.filterType = FilterType.NONE;
                        SettingsData.instance.filterDisplayImageUrl = '';
                      },
                    )
                  : RoundedButton(
                      elevation: 4,
                      onTap: () {
                        Get.toNamed(SwipeSettingsScreen.routeName);
                      },
                      name: 'Expand search',
                    )
            ],
          ),
        )),
      );
    }

    return SpinKitChasingDots(
      size: 20.0,
      color: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    // return a stack of cards well positioned.
    return ListenerWidget(
      notifier: MatchEngine.instance,
      builder: (context) {
        List<Match?> topEngineMatches = [
          if (MatchEngine.instance.currentMatch() != null)
            MatchEngine.instance.currentMatch(),
          if (MatchEngine.instance.nextMatch() != null)
            MatchEngine.instance.nextMatch()
        ];

        Widget _buildThumbIcon() {
          if (currentJudgment == SwipeDirection.Right) {
            return Center(
              child: Opacity(
                opacity: currentInterpolation * widget.maxThumbOpacity,
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
          if (currentJudgment == SwipeDirection.Left) {
            return Center(
              child: Opacity(
                opacity: currentInterpolation * widget.maxThumbOpacity,
                child: Transform.scale(
                  scale: currentInterpolation,
                  child: Icon(
                    Icons.thumb_down,
                    size: 100.0,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }

          return SizedBox.shrink();
        }

        return topEngineMatches.isEmpty
            ? _widgetWhenNoCardsExist()
            : Stack(
                fit: StackFit.expand,
                children: [
                  TCard(
                    onDragCard:
                        (double interpolation, SwipeDirection direction) {
                      setState(() {
                        currentInterpolation = interpolation;
                        currentJudgment = direction;
                      });
                      return;
                    },
                    delaySlideFor: 0,
                    onForward: (int index, SwipeInfo info) {
                      if (index == 0) {
                        //TODO index>0 should be impossible
                        if (info.direction == SwipeDirection.Left) {
                          MatchEngine.instance
                              .currentMatchDecision(Decision.nope);
                        } else if (info.direction == SwipeDirection.Right) {
                          MatchEngine.instance
                              .currentMatchDecision(Decision.like);
                        }
                      }
                    },
                    cards: topEngineMatches.map<Widget>((match) {
                      return MatchCard(
                        key: Key(match!.profile!.uid),
                        profile: match.profile!,
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

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}
