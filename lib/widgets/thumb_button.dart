import 'package:flutter/material.dart';

import 'clickable.dart';

const BoxConstraints _kDefaultBoxConstraints = BoxConstraints(
  minHeight: 45.0,
  maxHeight: 80.0,
  minWidth: 40.0,
  maxWidth: 75.0,
);

/// A button that is painted to look like an inverted drop of water and uses
/// [Clickable] as the gesture provider.
class ThumbButton extends StatelessWidget {
  const ThumbButton({
    Key key,
    this.child,
    this.thumbColor = Colors.white,
    this.enableFeedback = true,
    this.onTap,
  }) : super(key: key);

  /// The color with which to paint the thumb.
  /// This value is passed on to the [ThumbButtonPainter].
  final Color thumbColor;

  /// The Widget directly below this widget in the Widget tree.
  ///
  /// The supplied widget is painted right inside the thumb.
  final Widget child;

  /// Whether or not to make this button clickable.
  ///
  /// Note that if this is true and onTap is null, the clickable widget will
  /// disable onTap and no Thumb reaction will take place.
  final bool enableFeedback;

  /// A callback that gets fired when this button is tapped.
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    // the current screen size.
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    // TODO: make the Thumb re-adjust based on the size of its child.
    final double _thumbWidth = screenWidth * 0.2;

    return Clickable(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: _kDefaultBoxConstraints,
        child: Stack(
          children: [
            CustomPaint(
              // size:
              //     Size(_thumbWidth, (_thumbWidth * 1.2264150943396226).toDouble()),
              painter: ThumbButtonPainter(color: thumbColor),
            ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }
}

// ///
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*1.2264150943396226).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

class ThumbButtonPainter extends CustomPainter {
  ThumbButtonPainter({@required this.color});

  /// The color with which to paint this the thumb.
  final Color color;

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

    Paint paint = Paint()..style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
