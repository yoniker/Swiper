import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/circular_user_avatar.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/image_filterview_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/text_search_view_widget.dart';
import 'package:betabeta/widgets/voila_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
  // late AnimationController _animationController;
  late AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(seconds: 1))
    //..repeat(reverse: true); // <-- comment this line

    ..addStatusListener((AnimationStatus status) {
      // <-- add listener
      if (status == AnimationStatus.completed) {
        Future.delayed(
            Duration(milliseconds: _animationController.value == 0 ? 500 : 0),
            () {
          if (mounted)
            _animationController
                .animateTo(_animationController.value == 0 ? 1 : 0);
        });
      }
    });

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
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.repeat(reverse: true);

    // Instantiate and Initialize the Animation Controller and the respective Animation.
    // _animationController = AnimationController(
    //   duration: Duration(milliseconds: 400),
    //   upperBound: 1.0,
    //   lowerBound: 0.0,
    //   vsync: this,
    // );
  }

  @override
  void dispose() {
    // dispose the Animation Controller instance.
    // _animationController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  Widget buildCenterWidget() {
    switch (SettingsData.instance.filterType) {
      case FilterType.TEXT_SEARCH:
        if (SettingsData.instance.textSearch.length > 0)
          return TextSearchViewWidget(
              animationController: _animationController);
        break;
      case FilterType.CELEB_IMAGE:
      case FilterType.CUSTOM_IMAGE:
        return ImageFilterViewWidget(animationController: _animationController);
      default:
        return VoilaLogoWidget();
    }
    return VoilaLogoWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).padding,
      child: Column(
        children: [
          CustomAppBar(
            centerWidget: buildCenterWidget(),
            customTitle: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ListenerWidget(
                  //   notifier: MatchEngine.instance,
                  //   builder: (context) {
                  //     print('Listener on match screen called!');
                  //     // Widget dor = InkWell(
                  //     //   borderRadius: BorderRadius.circular(16.0),
                  //     //   child: Padding(
                  //     //     padding: EdgeInsets.only(right: 20.0),
                  //     //     child: Transform(
                  //     //       alignment: Alignment.centerRight,
                  //     //       transform: Matrix4.rotationY(math.pi),
                  //     //       child: Icon(
                  //     //         Icons.refresh,
                  //     //         size: 24.0,
                  //     //         color: colorBlend01,
                  //     //       ),
                  //     //     ),
                  //     //   ),
                  //     //   onTap: () {
                  //     //     MatchEngine.instance.goBack();
                  //     //   },
                  //     // );
                  //     // if (MatchEngine.instance.previousMatchExists()) {
                  //     //   _animationController.forward();
                  //     // } else {
                  //     //   _animationController.reverse();
                  //     // }
                  //     //
                  //     // //
                  //     // double getAnimatedValue(num value) {
                  //     //   return _animationController.value * value;
                  //     // }
                  //
                  //     // return AnimatedBuilder(
                  //     //   animation: _animationController,
                  //     //   child: dor,
                  //     //   builder: (context, child) {
                  //     //     return Opacity(
                  //     //       opacity: getAnimatedValue(1.0),
                  //     //       child: Container(
                  //     //         width: getAnimatedValue(30.0),
                  //     //         child: child,
                  //     //         transform: Matrix4.identity()
                  //     //           ..setTranslationRaw(
                  //     //             getAnimatedValue(1.0),
                  //     //             0.0,
                  //     //             0.0,
                  //     //           ),
                  //     //       ),
                  //     //     );
                  //     //   },
                  //     // );
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
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
            showAppLogo: false,
            hasBackButton: false,
            trailing: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                child: Image.asset(
                  'assets/images/settings.png',
                  scale: 12,
                ),
                onTap: () async {
                  // hide the overlay.
                  setMatchCardVisibility(false); //TODO Review this
                  var value = await Get.toNamed(SwipeSettingsScreen.routeName);
                  // make the match card visible.
                  setMatchCardVisibility(true);
                },
              ),
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
                      name: 'Expend search',
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
