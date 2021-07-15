import 'dart:math';

import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/widgets/custom_scrollbar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/overlay_builder.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../models/match_engine.dart';

enum SlideDirection {
  left,
  right,
  up,
}

class DraggableCard extends StatefulWidget {
  /// The Widget to build as the child of this [DragabbleCard].
  final Widget card;

  // /// A secondary Widget to show when the this card is being is scrolled.
  // ///
  // /// If found to be null nothing will be built as the "deatailsCard".
  // // This will contain all the Details for the match.
  // final Widget detailsCard;

  /// The [Profile] of this MatchCard.
  final Profile mactchProfile;

  /// A pageController for controlling exclusively what page is shown.
  ///
  /// It is this PageController the DetailsCard uses to return users back to
  /// the Match Page once a valid Decision has been made.
  final PageController controller;

  /// Determines wether or not this Widget is Draggable.
  ///
  /// This is set to `true` by default
  /// This parameter cannot be null.
  final bool isDraggable;

  /// Wether or not to show the detailsCard.
  ///
  /// This is set to `false` by default
  /// This parameter cannot be null.
  final canScroll;

  /// The Time taken for the Details screen to exit the details Page when a
  /// Decision is made.
  final Duration exitDuration;
  final SlideDirection slideTo;
  final Function(double distance) onSlideUpdate;
  final Function(SlideDirection direction) onSlideComplete;
  final double screenWidth;
  final double screenHeight;

  DraggableCard({
    Key key,
    @required this.card,
    // this.detailsCard,
    this.controller,
    this.mactchProfile,
    this.isDraggable = true,
    this.canScroll = false,
    this.slideTo,
    this.onSlideUpdate,
    this.onSlideComplete,
    @required this.screenWidth,
    @required this.screenHeight,
    this.exitDuration = const Duration(milliseconds: 100),
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Decision decision;
  GlobalKey profileCardKey = GlobalKey(debugLabel: 'profile_card_key');
  // This is useful in that when we want to push (Navigate to) a new [Route] over [this]
  // the current [Route], we don't want the overlay to Obscure the New Route we are pushing to.
  bool _showCardStack = true;
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  List<Offset>
      gestureOffsets; //Track if all offsets happened at the same direction
  List<Duration>
      gestureTimeStamps; //Track all of the time stamps to test if it happened "fast enough"
  Offset slideBackStart;
  SlideDirection slideOutDirection;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;

  // Defines the ScrollController that controls the inner ScrollView.
  ScrollController scrollController;

  // The defualt Curve with which the details Page animates out into the new Match Page.
  final kdefaultExitCurve = Curves.fastOutSlowIn;

  Duration exitDuration;

  @override
  void initState() {
    super.initState();
    slideBackAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
                Curves.elasticOut.transform(slideBackAnimation.value));

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
            gestureOffsets = null;
            gestureTimeStamps = null;
          });
        }
      });

    slideOutAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() => setState(() {
            cardOffset = slideOutTween.evaluate(slideOutAnimation);
            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;

            if (widget.onSlideComplete != null) {
              widget.onSlideComplete(slideOutDirection);
            }
          });
        }
      });

    // Initialize the ScrollController.
    scrollController = ScrollController(keepScrollOffset: false);

    // Intantiate the exitDuration.
    exitDuration = widget.exitDuration;
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    scrollController = null;
    // re-initialize the ScrollController.
    scrollController = ScrollController();

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = const Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
      }
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    slideOutAnimation.dispose();

    scrollController?.dispose();
    super.dispose();
  }

  void _slideLeft() {
    // final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(-2 * widget.screenWidth, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  Offset _chooseRandomDragStart() {
    final cardContex = profileCardKey.currentContext;
    final cardTopLeft = (cardContex.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY =
        widget.screenHeight * (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
            cardTopLeft.dy;

    return Offset(widget.screenWidth / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideRight() {
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(2 * widget.screenWidth, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  void _slideUp() {
    // final screenHeight = context.size.height;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(0.0, -2 * widget.screenHeight),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    gestureOffsets = [];
    gestureTimeStamps = [];

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;
      gestureOffsets.add(cardOffset);
      gestureTimeStamps.add(details.sourceTimeStamp);

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }
    });
  }

  FastSwipe detectFastSwipe() {
    const int MINIMUM_GESTURE_LENGTH = 40;
    const double MINIMUM_DURATION_TIME =
        1; //TODO convert it into Duration since it's more like dart than this
    const double MAXIMUM_DURATION_TIME = 1000;

    if (gestureTimeStamps.length < 2) {
      return FastSwipe.notFastSwipe;
    }
    final int gestureTime =
        (gestureTimeStamps[gestureTimeStamps.length - 1] - gestureTimeStamps[0])
            .inMilliseconds;
    if (gestureTime < MINIMUM_DURATION_TIME) {
      return FastSwipe.notFastSwipe;
    }
    if (gestureTime > MAXIMUM_DURATION_TIME) {
      return FastSwipe.notFastSwipe;
    } //TODO again,it's important to cut the lists but for now
    double overAllGestureSize =
        gestureOffsets[gestureOffsets.length - 1].dx - gestureOffsets[0].dx;
    if (overAllGestureSize.abs() < MINIMUM_GESTURE_LENGTH) {
      return FastSwipe.notFastSwipe;
    }
    //TODO cut both lists such that we will observe only the very last motions eg 1/2 miliseconds
    bool monotonic = true;
    for (int i = 1; i < gestureOffsets.length; ++i) {
      if (gestureOffsets[i].dx.abs() < gestureOffsets[i - 1].dx.abs()) {
        monotonic = false;
        break;
      }
    }
    if (!monotonic) {
      return FastSwipe.notFastSwipe;
    }

    if (gestureOffsets[0].dx > gestureOffsets[1].dx) {
      return FastSwipe.Left;
    }

    return FastSwipe.Right;
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;

    // This determines the point at which the Dragged Widget is considered to be
    // at the left region.
    bool isInLeftRegion = (cardOffset.dx / context.size.width) < -0.35;

    // This determines the point at which the Dragged Widget is considered to be
    // at the right region.
    bool isInRightRegion = (cardOffset.dx / context.size.width) > 0.35;

    // This determines the point at which the Dragged Widget is considered to be
    // at the top region.
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.30;

    // This helps to detect fast swipe either left or right.
    final FastSwipe fastSwipeStatus = detectFastSwipe();

    isInLeftRegion |= fastSwipeStatus == FastSwipe.Left;
    isInRightRegion |= fastSwipeStatus == FastSwipe.Right;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));

        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;

        // reset the scroll position.
        _resetViewport();
      } else if (isInTopRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection = SlideDirection.up;

        // reset the scroll position.
        _resetViewport();
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);

        // we did not call "_resetViewport()" here since at this point the slideDirection is null
        // indicating a false swipe.
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
  }

  /// A function to select the match Decision made on the the current match.
  currentMatchDecision(Decision decision) {
    if (Provider.of<MatchEngine>(context, listen: false).currentMatch() !=
        null) {
      Provider.of<MatchEngine>(context, listen: false)
          .currentMatchDecision(decision);
      Provider.of<MatchEngine>(context, listen: false).goToNextMatch();

      // reset the scroll position.
      _resetViewport();
    }
  }

  /// Reset the scroll position of the viewport.
  ///
  /// This essetially calls the  "animateTo" function on the scrollController.
  void _resetViewport() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: exitDuration,
        curve: kdefaultExitCurve,
      );
    }
  }

  /// A widget that displays the actions a user can make on a match.
  /// Actions such as:
  ///   "Dislike",
  ///   "Like",
  ///   "Draft Message"
  ///
  /// Essentially a list of [DecisionControl] widgets to display below
  /// the Image Display Widget of each match.
  Widget _matchControls({EdgeInsets padding = const EdgeInsets.all(2.0)}) {
    return Container(
      padding: padding,
      foregroundDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: darkCardColor,
            offset: Offset(0.0, 0.2),
            blurRadius: 16.0,
          ),
        ],
      ),
      // A Material Widget is added here so as to allow the solash of the InkWell Widgets
      // below this Widget in the tree to show.
      //
      // Note: Any Container Within the Widget tree will obscure the action of any InkWell Widget
      // below such Container in the Widget tree.
      child: Material(
        // With this as transparent we can retain the original color of the Enclosing
        // Decoration Widget.
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              child: GlobalWidgets.assetImageToIcon(
                BetaIconPaths.dislikeMatchIcon,
                scale: 4.0,
              ),
              onTap: () {
                // Decision.nope
                currentMatchDecision(Decision.nope);
              },
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              child: GlobalWidgets.assetImageToIcon(
                BetaIconPaths.likeMatchIcon,
                // The scale is kid of backwards.
                scale: 3.75,
              ),
              onTap: () {
                // Decision.like
                currentMatchDecision(Decision.like);
              },
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              child: GlobalWidgets.assetImageToIcon(
                BetaIconPaths.draftMesssageIcon,
                scale: 4.0,
              ),
              onTap: () {
                // Call a Function to open a chat Tab to chat with the match.
                print('MAKE A DRAFT!');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The padding applied to the DraggableCard.
    // We need to specify this here so we can take into account the
    // amount of space eaten up by the padding and reflect this in the
    // height set for the Draggable Card.
    double vertPad = MediaQuery.of(context).size.height * 0.020;

    // The padding applied to the horizontal axis of the DraggableCard.
    double horizPad = MediaQuery.of(context).size.height * 0.015;

    // Describes the height of the MatchCard and the DraggableCard as a whole.
    // final kFixedHeight = MediaQuery.of(context).size.height * 0.7;

    // Wraps the widget in a Transformation and Overlay.
    // This makes our MatchCard to float avove the AppBar and other
    // widgets since it's is an overlay on the current context.
    var wrapper = AnchoredOverlay(
      showOverlay: _showCardStack,
      child: Container(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        // The height available for the MatchCard to fit into.
        //
        // Note: This is height when no padding has been applied.
        final kFixedHeight = anchorBounds.height;

        // The actual height is the amount of space left after padding as being applied.
        // Since the padding is applied to all the sides i.e. EdgeInsets.all was the constructor used
        // to get the actual Height available we have to subtract this from the original (fixed)
        // height when no padding has been applied at all.
        final kActualHeight = kFixedHeight - vertPad * 2;

        // Replaced the original CenterAbout [Widget] with a more precise [Widget]
        // provided by the FrameWork, "Center" widget.
        return Center(
          child: Transform(
            transform:
                Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: Container(
              key: profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              // We apply the pad here.
              padding:
                  EdgeInsets.symmetric(vertical: vertPad, horizontal: horizPad),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(16.0),
                    shadowColor: Colors.grey[200],
                    elevation: 0.40,
                    child: GestureDetector(
                      onPanStart: widget.isDraggable ? _onPanStart : null,
                      onPanUpdate: widget.isDraggable ? _onPanUpdate : null,
                      onPanEnd: widget.isDraggable ? _onPanEnd : null,
                      child: (widget.canScroll != true)
                          // Builds the regular DraggableCard with no inclusion of the details Page
                          // whatsoever.
                          ? widget.card
                          : SizedBox(
                              // This helps the MatchCard as a whole (including the PhotoView and the Description widget)
                              // to know and fit with the amount of space remaining.
                              height: kActualHeight,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                restorationId:
                                    '${widget.mactchProfile.username}-${DateTime.now().toString()}',
                                clipBehavior: Clip.none,
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    // Diplays the MatchCard.
                                    // Here we are passing the BoxConstraints of the Viewport to the
                                    // SizedBox holding the MatchCard.
                                    //
                                    // What this does is that it forces the height of the Viewport on the MatchCard
                                    // thus, this makes sure that the MatchCard fills the available space according to the
                                    // height constraints of the ViewPort.
                                    SizedBox(
                                      height: kActualHeight,
                                      child: widget.card,
                                    ),

                                    // Here we display the DetailsCard of this Match.
                                    // The following will contain the MatchCard Implementation.
                                    // SizedBox(
                                    //   height: MediaQuery.of(context).size.height * 0.7,
                                    //   child: widget.detailsCard,
                                    // ),

                                    // build the MatchCardDetails.
                                    // The tripple dots placed at the back just mean that I am appending the
                                    // below ehich is a list of Widgets to this bigger list.
                                    // removing it will cause analysis error.
                                    //
                                    // This is just a way one can add a grouped List of Widgets within another
                                    // super or parent list.
                                    ...buildMatchDetails(
                                      widget.mactchProfile,
                                      context: context,
                                    ),

                                    // build the Match Control.
                                    _matchControls(),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  if (widget.canScroll == true)
                    Align(
                      alignment: Alignment.topRight,
                      child: CustomScrollBar(
                        key: UniqueKey(),
                        scrollController: scrollController,
                        trackHeight: 80.0,
                        trackWidth: 8.5,
                        thumbHeightfactor: 0.3,
                        trackPadding: EdgeInsets.only(right: 8.0, top: 15.0),
                        thumbColor: Colors.white,
                        trackColor: colorBlend02.withOpacity(0.4),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return wrapper;
  }
}

enum FastSwipe { notFastSwipe, Right, Left }

/// Generates a List of Items that serves as the MatchDetails.
///
/// We are returnig a List of Widgets so that this can be easily
/// incorporated into the MatchCard Scroll ViewPort.
///
/// Also, we have to imcorporate this into the Draggable Widget since we needed it to be part
/// of the Overlay being display/stacked on the screen which also makes it drag when we drag.swipe
/// left or right.
///
List<Widget> buildMatchDetails(
  Profile profile, {
  @required BuildContext context,
}) {
  final _imageUrls = profile.imageUrls ?? <String>[];

  // builds the achivement items such as loves and stars.
  Widget _buildAchievementItem(String iconURI, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: [
          Text(
            value,
            style: smallCharStyle.copyWith(color: darkTextColor),
          ),
          SizedBox(width: 2.0),
          PrecachedImage.asset(
            imageURI: iconURI,
          ),
        ],
      ),
    );
  }

  // Return a List of Widgets.
  return [
    SizedBox(height: 16.0),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              '${profile.username}, ${profile.age}',
              textAlign: TextAlign.left,
              // overflow: TextOverflow.ellipsis,
              style: boldTextStyle.copyWith(fontSize: 18.0),
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 5.0),
        //   child: Row(
        //     children: [
        //       _buildAchievementItem(BetaIconPaths.heartIconFilled01, '25k+'),
        //       _buildAchievementItem(BetaIconPaths.starIconFilled01, '15k+'),
        //     ],
        //   ),
        // ),
      ],
    ),
    Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        (profile.headline != null) ? profile.headline : '',
        textAlign: TextAlign.left,
        style: defaultTextStyle,
      ),
    ),
    Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 12.0,
        left: 5.0,
        right: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: subTitleStyle,
          ),
          Divider(
            color: darkCardColor,
            indent: 2.0,
            endIndent: 2.0,
            thickness: 2.8,
            height: 8.0,
          ),
          Text(
            (profile.description != null)
                ? profile.description
                : 'No Description available',
            style: mediumCharStyle,
          ),
        ],
      ),
    ),
    Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      child: Row(
        children: [
          PrecachedImage.asset(imageURI: BetaIconPaths.locationIconFilled01),
          SizedBox(width: 5.6),
          Text(
            (profile.location != null)
                ? 'Lives in ${profile.location}'
                : 'Current Location not available',
            textAlign: TextAlign.right,
            style: defaultTextStyle,
          ),
        ],
      ),
    ),
    Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 12.0,
        left: 5.0,
        right: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Images',
            style: subTitleStyle,
          ),
          Divider(
            color: darkCardColor,
            indent: 2.0,
            endIndent: 2.0,
            thickness: 2.8,
            height: 8.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: !(_imageUrls.length > 0)
                ? Center(
                    child: Text(
                      'No Profile image Available for match',
                      style: mediumBoldedCharStyle,
                    ),
                  )
                : ListView.separated(
                    key: UniqueKey(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageUrls.length,
                    itemBuilder: (cntx, index) {
                      final String _url = _baseToNetwork(_imageUrls[index]);
                      return SizedBox(
                        height: 80.5,
                        width: 100.0,
                        child: Card(
                          margin: EdgeInsets.all(6.0),
                          clipBehavior: Clip.antiAlias,
                          elevation: 2.1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: PrecachedImage.network(
                            imageURL: _url,
                            fadeIn: true,
                            shouldPrecache: false,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (cntx, index) {
                      return SizedBox(width: 16.0);
                    },
                  ),
          ),
        ],
      ),
    ),
    Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 12.0,
        left: 5.0,
        right: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Artificial Intelligence',
            style: subTitleStyle,
          ),
          Divider(
            color: darkCardColor,
            indent: 2.0,
            endIndent: 2.0,
            thickness: 2.8,
            height: 8.0,
          ),
          DescriptionBanner(
            // TODO(Backend) Add a field "gender" to the profile Interface:
            message: 'See what a baby with her will look like',
            overflow: null,
            onTap: () {
              print('GO TO VIEW PROGENY PAGE!');
            },
            label: Align(
              alignment: Alignment(-1.02, -2.0),
              child: PrecachedImage.asset(
                imageURI: BetaIconPaths.tryMeBanner,
              ),
            ),
          ),
          DescriptionBanner(
            message: 'Like Fever Prediction',
            overflow: null,
            trailing: LikeFeverWidget(
              value: 20.0,
              assetURI: BetaIconPaths.likeFeverTherm02,
              startValue: 20.0,
            ),
          ),
          DescriptionBanner(
            message: 'Match Percentage',
            overflow: null,
            trailing: LikeFeverWidget(
              value: 20.0,
              assetURI: BetaIconPaths.likeScale01,
            ),
            // trailing: Container(
            //   margin: EdgeInsets.symmetric(horizontal: 4.0),
            //   padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8.0),
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: mainColorGradient.colors,
            //     ),
            //   ),
            //   child: RichText(
            //     text: TextSpan(
            //       style: subHeaderStyle.copyWith(color: whiteTextColor),
            //       children: <TextSpan>[
            //         TextSpan(
            //           text: '70% ',
            //           style: subTitleStyle.copyWith(color: whiteTextColor),
            //         ),
            //         TextSpan(text: 'match'),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    ),
  ];
}

/// Returns a string with `https://` appended to the back of the `base` given.
String _baseToNetwork(String base) {
  final String _http = 'https://';
  return _http + base;
}

///
class LikeFeverWidget extends StatelessWidget {
  const LikeFeverWidget({
    Key key,
    @required this.value,
    this.startValue = 0.0,
    this.endValue = 100.0,
    @required String assetURI,
    this.colorGradient,
  })  : assert(value >= 0.0 && value <= 100.0,
            'The "value" provided must be in the range (0.0, 100.0)\n Given: $value'),
        assert(endValue > startValue,
            'The "endValue" provided must be greater than the "startValue'),
        assert(endValue >= 0.0 && endValue <= 100.0,
            'The "endValue" provided must be in the range (0.0, 100.0)\n Given: $value'),
        assert(startValue >= 0.0 && startValue <= 100.0,
            'The "startValue" provided must be in the range (0.0, 100.0)\n Given: $value'),
        _uri = assetURI,
        super(key: key);

  // run some computation to return a valid value within range.
  double _compute(double value) {
    final val = value / 100;
    final _start = startValue / 100;
    final _end = endValue / 100;

    final double _computeVal = val * (_end - _start) + _start;

    return _computeVal;
  }

  /// The start value of the scale.
  ///
  /// Note that the provided value must be in the range `(0.0, 100.0)`, same as the `value` parameter.
  final double startValue;

  /// The end value of the scale.
  ///
  /// Note that the provided value must be in the range `(0.0, 100.0)`, same as the `value` parameter.
  final double endValue;

  /// The value of the like-fever.
  ///
  /// Note that the value provided should be in the range `(0.0, 100.0)`.
  final double value;

  /// The Gradient to use in painting this widget.
  ///
  /// If none is given (or a value of null is supplied) the gradient defaults to [mainColorGradient].
  final Gradient colorGradient;

  /// THe URI to the asset image for rendering the scale.
  final String _uri;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ShaderMask(
        shaderCallback: (rect) {
          final _val = _compute(value);
          final double _skew = _val + 0.1;

          final _gradient = colorGradient ??
              LinearGradient(
                colors: [
                  colorBlend02,
                  defaultShadowColor,
                ],
                stops: [
                  _val,
                  _skew,
                ],
              );

          return _gradient.createShader(
            rect,
          );
        },
        child: PrecachedImage.asset(imageURI: _uri),
      ),
    );
  }
}
