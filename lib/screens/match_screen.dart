import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_settings/app_settings.dart';
import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/location_service.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/animated_widgets/animated_minitcard_widget.dart';
import 'package:betabeta/widgets/animated_widgets/no_matches_display_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/voila_logo_widget.dart';
import 'package:extended_image/extended_image.dart';
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
  late final ScrollController _scrollController;

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
  // late final ScrollController _scrollController;

  @override
  void initState() {
    // _scrollController = ScrollController()
    //   ..addListener(() {
    //     setState(() {});
    //   });
    prefetchMatchesImages();
    MatchEngine.instance.addListener(prefetchMatchesImages);
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    MatchEngine.instance.removeListener(prefetchMatchesImages);
    super.dispose();
  }

  void enableLocation() async {
    if (LocationService.instance.needChangeAppSettings()) {
      await AppSettings.openLocationSettings();
    }
    var status = await LocationService.instance.requestLocationCapability();
    if (status == LocationServiceStatus.enabled) {
      LocationService.instance.onInit();
    }
  }

  Widget _widgetWhenNoCardsExist() {
    if (MatchEngine.instance.registrationStatus ==
        RegistrationStatus.registeredNotApproved) {
      return Text('You were not approved yet widget should appear here');
    }

    if (MatchEngine.instance.getServerSearchStatus ==
        MatchSearchStatus.not_found) {
      return NoMatchesDisplayWidget(
        centerWidget: Text(
          'No new matches found with your current preferences. Check again soon to see new people.',
          style: kSmallInfoStyle.copyWith(color: Colors.black45),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SpinKitChasingDots(
      size: 20.0,
      color: Colors.blue,
    );
  }

  Future<void> prefetchMatchesImages() async {
    //This function prefetches images while listening to MatchEngine.
    //TODO is this ideal?
    var matches = MatchEngine.instance.topMatches();
    List<Future<void>> futuresGettingImages = [];
    matches.asMap().forEach((i, match) {
      if ((match?.profile?.imageUrls?.length ?? 0) >= 1) {
        var maxIndexToFetch =
            i <= 1 ? match!.profile!.imageUrls!.length - 1 : 0;
        for (int i = 0; i < maxIndexToFetch + 1; i++) {
          var img = ExtendedImage.network(
            AWSServer.getProfileImageUrl(match!.profile!.imageUrls![i]),
            scale: 1.0,
            fit: BoxFit.cover,
            //headers:{"Keep-Alive":"timeout=20"},
          );
          futuresGettingImages.add(precacheImage(img.image, context));
        }
      }
    });
    Future.wait(futuresGettingImages);
    return;
  }

  @override
  Widget build(BuildContext context) {
    // return a stack of cards well positioned.
    return ListenerWidget(
      notifier: MatchEngine.instance,
      builder: (context) {
        List<Match?> topEngineMatches = MatchEngine.instance.topMatches();

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
                        // scrollController: _scrollController,
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
}
