import 'package:flutter/material.dart';

import 'clickable.dart';

/// The BoxShadow list used by the Cupertino Slider.
const List<BoxShadow> _kThumbBoxShadows = <BoxShadow>[
  BoxShadow(
    color: Color(0x26000000),
    offset: Offset(0, 3),
    blurRadius: 8.0,
  ),
  BoxShadow(
    color: Color(0x29000000),
    offset: Offset(0, 1),
    blurRadius: 1.0,
  ),
  BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 3),
    blurRadius: 1.0,
  ),
];

/// The Color used to paint the thumbBorder.
const Color _kThumbColor = Color(0x0AFFFFFF);

/// The default box constraint applied to the thumb by default.
const BoxConstraints _kDefaultBoxConstraints = BoxConstraints(
  minHeight: 55.0,
  maxHeight: 120.0,
  minWidth: 45.0,
  maxWidth: 75.0,
);

/// A button that is painted to look like an inverted drop of water and uses
/// [Clickable] as the gesture provider.
///
/// The child widget may appear to not be centered in the image, you can use a [Positioned]
/// widget to center the child widget properly in the thumb or else where depending.
class ThumbButton extends StatelessWidget {
  const ThumbButton({
    Key? key,
    this.child,
    this.thumbColor = _kThumbColor,
    this.thumbConstraints = _kDefaultBoxConstraints,
    this.boxShadows = _kThumbBoxShadows,
    this.enableFeedback = true,
    this.onTap,
  }) : super(key: key);

  /// The color with which to paint the thumb.
  /// This value is passed on to the [ThumbButtonPainter].
  final Color thumbColor;

  /// The Widget directly below this widget in the Widget tree.
  ///
  /// The supplied widget is painted right inside the thumb.
  final Widget? child;

  /// The constraints set for this ThumbButton.
  /// The constraints provided is used to compute the dimension of the thumb button.
  ///
  /// The default value is the one defined by the const `_kDefaultBoxConstraints`.
  final BoxConstraints thumbConstraints;

  /// A list of [BoxShadow]s to paint behind this thumb.
  ///
  /// This value is passed to the [ThumbPainter] and used to paint the provided
  /// shadows behind the [ThumbButton].
  ///
  /// The default is `_kThumbBoxShadows`.
  final List<BoxShadow> boxShadows;

  /// Whether or not to make this button clickable.
  ///
  /// Note that if this is true and onTap is null, the clickable widget will
  /// disable onTap and no Thumb reaction will take place.
  final bool enableFeedback;

  /// A callback that gets fired when this button is tapped.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // the current screen size.
    // final Size screenSize = MediaQuery.of(context).size;
    // final double screenWidth = screenSize.width;

    return Clickable(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: ThumbButtonPainter(
              color: thumbColor,
              boxShadows: boxShadows,
            ),
            child: ConstrainedBox(
              constraints: _kDefaultBoxConstraints,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// The CustomPainter for the [ThumbButton] widget.
class ThumbButtonPainter extends CustomPainter {
  ThumbButtonPainter(
      {required this.color, this.boxShadows = _kThumbBoxShadows});

  /// The color with which to paint this the thumb.
  final Color color;

  /// A list of [BoxShadow]s to paint the Thumb.
  /// This is set to [_kThumbBoxShadows] by default.
  ///
  /// You can override this by passing it a list of [BoxShadow] of your choice.
  final List<BoxShadow> boxShadows;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    // final _height = size.height * 1.2264150943396226;
    path.moveTo(size.width * 0.5000000, 0);
    path.cubicTo(size.width * 0.2238585, 0, 0, size.height * 0.1825308, 0,
        size.height * 0.4076923);
    path.cubicTo(
        0,
        size.height * 0.5336785,
        size.width * 0.07008491,
        size.height * 0.6463185,
        size.width * 0.1802000,
        size.height * 0.7211015);
    path.cubicTo(
        size.width * 0.2887321,
        size.height * 0.7948123,
        size.width * 0.4122415,
        size.height * 0.8634308,
        size.width * 0.4724189,
        size.height * 0.9676277);
    path.lineTo(size.width * 0.4795170, size.height * 0.9799169);
    path.cubicTo(
        size.width * 0.4876755,
        size.height * 0.9940446,
        size.width * 0.5123245,
        size.height * 0.9940446,
        size.width * 0.5204830,
        size.height * 0.9799169);
    path.lineTo(size.width * 0.5275811, size.height * 0.9676277);
    path.cubicTo(
        size.width * 0.5877585,
        size.height * 0.8634308,
        size.width * 0.7112679,
        size.height * 0.7948123,
        size.width * 0.8198000,
        size.height * 0.7211015);
    path.cubicTo(size.width * 0.9299151, size.height * 0.6463169, size.width,
        size.height * 0.5336785, size.width, size.height * 0.4076923);
    path.cubicTo(size.width, size.height * 0.1825308, size.width * 0.7761415, 0,
        size.width * 0.5000000, 0);
    path.close();

    // This is where the `boxShadows` parameter is checked for being null
    // and set to `_kSliderBoxShadows`.
    for (final BoxShadow shadow in boxShadows ?? _kThumbBoxShadows) {
      // this paints the shdows behind the button.
      canvas.drawPath(path.shift(shadow.offset), shadow.toPaint());
    }

    Paint paint = Paint()..style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ThumbButtonPainter oldDelegate) {
    return oldDelegate.color != this.color;
  }
}
