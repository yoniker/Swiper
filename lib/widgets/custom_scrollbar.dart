import 'dart:async';

import 'package:flutter/material.dart';

/// The default Track color used in painting the CustomScrollBar's Track.
///
/// Basically a grey color with an opacity of 0.6
final Color kDefaultTrackColor = Colors.grey.withOpacity(0.4);

/// The default Duration of the FadeOut Animation of the [CustomScrollBar].
final Duration kFadeOutDuration = const Duration(milliseconds: 400);

/// A ScrollBar Widget that can stacked above any Widget and only shows when the ScrollView is scrolled.
/// It does not need to have any Scrollable Widget as it's child.
/// All it requires is a ScrollController which is currently attached to a ScrollView.
///
class CustomScrollBar extends StatefulWidget {
  CustomScrollBar({
    Key key,
    @required this.scrollController,
    this.trackColor,
    this.thumbColor = Colors.white,
    this.trackHeight = 45,
    this.trackWidth = 12.5,
    this.trackRadius = 7.5,
    this.thumbRadius = 6.0,
    this.thumbHeightfactor = 0.4,
    this.thumbPad = 1.0,
    this.trackPadding = const EdgeInsets.all(5.0),
    this.fadeInDuration = const Duration(milliseconds: 100),
    this.fadeOutDuration,
    this.fadeDelayDuration = const Duration(milliseconds: 1200),
  })  : assert(trackHeight != null, 'The track height cannot be null'),
        assert(trackWidth != null, 'The track width cannot be null'),
        assert(fadeInDuration != null,
            'The "fadeDuration" parameter cannot be null, Please pass in a valid value.'),
        assert(scrollController != null,
            'Please provide a valid value for the ScrollController'),
        super(key: key);

  /// The scrollController of the ScrollableView this widget controls.
  ///
  /// Note: This parameter must be provided for the CustomScrollbar to work.
  final ScrollController scrollController;

  /// The height of the [CustomSrollBar]'s Track.
  ///
  /// Note: The height for the [CustomSrollBar]'s `Thumb` will be calculated from this.
  final double trackHeight;

  /// The width of the [CustomSrollBar]'s Track.
  final double trackWidth;

  /// The padding to be applied to the outside of the Background border.
  ///
  /// Defaults to `EdgeInsets.all(5.0)`.
  final EdgeInsets trackPadding;

  /// The amount of horizontal padding in logical pixels to be applied to the
  /// inside of the Track's border and outside the [CustomScrollBar]'s `Thumb`.
  ///
  /// Defaults to `1.0`,
  final double thumbPad;

  /// The duration of the FadeIn Animation of the [CustomScrollBar] occurs when the
  /// ScrollView owned by the `ScrollController` passed to this [CustomScrollBar] Widget
  /// start scrolling.
  ///
  /// This Defaults to `Duration(milliseconds: 100)`
  final Duration fadeInDuration;

  /// The duration of the FadeOut Animation of the [CustomScrollBar] occurs when the
  /// ScrollView owned by the `ScrollController` passed to this [CustomScrollBar] widget
  /// start scrolling.
  ///
  /// If null Defaults to `kFadeOutDuration` which is `Duration(milliseconds: 400)`.
  final Duration fadeOutDuration;

  /// The time for which the CustomScrollBar must wait when the ScrollView attached to this
  /// [CustomScrollBar] widget is no longer being scrolled. i.e is inactive.
  ///
  /// This defaults to `Duration(milliseconds: 1200)`.
  final Duration fadeDelayDuration;

  /// The color used in painting the Track of the [CustomScrollBar].
  ///
  /// The default is [kDefaultTrackColor] defined in the [CustomScrollBar]'s Library
  /// which is grey with an opacity of 0.4
  final Color trackColor;

  /// The color used to paint the `Thumb` of the [CustomScrollBar].
  ///
  /// This is set to `Colors.white` by default.
  final Color thumbColor;

  /// The border radius used in Drawing the [CustomScrollBar]'s Thumb.
  ///
  /// This defaults to `6.0`.
  final double thumbRadius;

  /// The border radius used in Drawing the [CustomScrollBar]'s Track.
  ///
  /// This defaults to `7.5`.
  final double trackRadius;

  /// The percentage of height of the Track to be used as the height of the Thumb.
  /// The range is from `0.0` to `1.0`.
  ///
  /// This must not be null.
  ///
  /// Defaults to `0.4`.
  final double thumbHeightfactor;

  @override
  _CustomScrollBarState createState() => _CustomScrollBarState();
}

class _CustomScrollBarState extends State<CustomScrollBar>
    with SingleTickerProviderStateMixin {
  // The amount of pixes by which the scroll controller was off.
  double derivedPosition = 0.0;

  // The controller for the fadding Animation of the CustomScrollBar.
  AnimationController _opacityAnimationController;

  // The Fade Animation literal itself.
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Instantiate the scrollController.
    widget.scrollController?.addListener(() {
      if (widget.scrollController.hasClients) {
        var currentPos = widget.scrollController.position;

        // This connotes the offset of the ScrollController at a particular point clamped to
        // the range "0.0 to 1.0"
        var originalOffset =
            (currentPos.pixels / currentPos.maxScrollExtent) * 1.0;
        if (mounted) setState(() {
          derivedPosition = originalOffset;
        });

        // For the Fade animation.
        var isScrollingNotifier =
            widget.scrollController.position.isScrollingNotifier;
        isScrollingNotifier.addListener(() {
          toggleVisibility();
        });
      }
    });

    // Initialize and configure the AnimationController and the Animation.
    _opacityAnimationController = AnimationController(
      upperBound: 1.0,
      lowerBound: 0.0,
      duration: widget.fadeInDuration,
      animationBehavior: AnimationBehavior.preserve,
      reverseDuration: widget.fadeInDuration ?? kFadeOutDuration,
      vsync: this,
    );

    // Initialize the Fade Animation.
    _fadeAnimation = CurvedAnimation(
      parent: _opacityAnimationController,
      curve: Curves.easeIn,
    );

    // For the Fade animation.
    var isScrollingNotifier =
        widget?.scrollController?.position?.isScrollingNotifier;
    isScrollingNotifier.addListener(() {
      toggleVisibility();
    });
  }

  // handles wheter to show or hide the CustomScrollBar at any point in time.
  toggleVisibility() {
    var isScrollingNotifier =
        widget?.scrollController?.position?.isScrollingNotifier;

    bool isScrolling = isScrollingNotifier.value;

    // check if scrolling is active (under way).
    if (isScrolling) {
      // stop any active animation.
      if (_opacityAnimationController.isAnimating) {
        _opacityAnimationController.reset();
      }

      // forward the animation if dismissed.
      if (_opacityAnimationController.isDismissed) {
        _opacityAnimationController.forward();
      }
    }

    // if the ScrollView is no longer scrolling (inactive)
    else if (isScrolling == false) {
      // wait for 1200 milliseconds and then
      // reverse the animation. i.e fade out [CustomScrollBar] Widget.
      // This timer is used to control when to fade out the [CustomScrollBar] when
      // it is detected that the scroll is inactive. i.e The ScrollView attached to this
      // [CustomScrollBar] is no longer being scrolled.
      Future.delayed(widget.fadeDelayDuration, () {
        // In addition to the above we also check if the Widget is mounted so we can avoid calling the
        // delay function to reverse our non-existent Animation Controller.
        // 
        // All
        if (isScrollingNotifier.value == false &&
            // ensures that we are not calling the method that follows
            // after it the Widget has been disposed.
            mounted &&
            // makes sure that 
            _opacityAnimationController.isCompleted == true &&
            _opacityAnimationController.isDismissed == false) {
          if (_opacityAnimationController.isAnimating == false) {
            _opacityAnimationController.reverse();

            
          }

          //<debug>
          // print('STOPPED_SCROLLING, "isScrollingNotifier value  is: ${isScrollingNotifier.value}"');
        } else {
          //<debug>
          // print('SCROLLING IS UNDERWAY!, "isScrollingNotifier value  is: ${isScrollingNotifier.value}"');
        }
      });
    }
  }

  @override
  void dispose() {
    // dispose the Scroll Controller if not diposed by the parent Widget.
    // widget.scrollController?.dispose();

    // dispose the Animation Controller
    _opacityAnimationController.dispose();

    // call super to dispose.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // define the [CutomScrollBar]'s track height for easy readability.
    double trackHeight = widget.trackHeight;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: widget.trackPadding,
        child: Stack(
          children: [
            //  The CustomScrollBar's Track.
            Container(
              height: trackHeight,
              width: widget.trackWidth,
              decoration: BoxDecoration(
                color: widget.trackColor,
                borderRadius: BorderRadius.circular(
                    widget.trackRadius ?? widget.thumbRadius + widget.thumbPad),
              ),
            ),

            // The CustomScrollBar's Thumb.
            Positioned(
              top: trackHeight *
                  derivedPosition *
                  (1.0 - widget.thumbHeightfactor),
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widget.thumbPad),
                height: trackHeight * widget.thumbHeightfactor,
                decoration: BoxDecoration(
                  color: widget.thumbColor,
                  borderRadius: BorderRadius.circular(
                    widget.thumbRadius,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
