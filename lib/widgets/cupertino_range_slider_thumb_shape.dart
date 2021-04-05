import 'package:flutter/material.dart';

/// The BoxShadow list used by the Cupertino Slider.
const List<BoxShadow> _kSliderBoxShadows = <BoxShadow>[
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
const Color _kThumbBorderColor = Color(0x0A000000);


/// A class that extends the [RangeSliderThumbShape] class.
///
/// This provides you with the Functionality of adjusting the BoxShadow
/// painted below the Thumb.
///
/// Use the `boxShadows` parameter to set the shadow of the Thumb to suit your needs.
/// The value of the `boxShadows` parameter is set to [_kSliderBoxShadows] by default.
class CupertinoRangeSliderThumbShape extends RangeSliderThumbShape {
  /// Create a slider thumb that draws a circle.
  const CupertinoRangeSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.boxShadows,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  }) : assert(enabledThumbRadius != null);

  /// A list of [BoxShadow]s to paint the Thumb.
  /// This is set to [_kSliderBoxShadows] by default.
  ///
  /// You can override this by passing it a list of [BoxShadow] of your choice.
  final List<BoxShadow> boxShadows;

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the material default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius].
  final double disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        @required Animation<double> activationAnimation,
        @required Animation<double> enableAnimation,
        bool isDiscrete = false,
        bool isEnabled = false,
        bool isOnTop,
        @required SliderThemeData sliderTheme,
        TextDirection textDirection,
        Thumb thumb,
        bool isPressed,
      }) {
    assert(context != null);
    assert(center != null);
    assert(activationAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    assert(enableAnimation != null);
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final double radius = radiusTween.evaluate(enableAnimation);

    // Add a stroke of 1dp around the circle if this thumb would overlap
    // the other thumb.
    if (isOnTop == true) {
      final Paint strokePaint = Paint()
        ..color = sliderTheme.overlappingShapeStrokeColor
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final Color color = colorTween.evaluate(enableAnimation);

    final Rect rect = Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius);

    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(rect.shortestSide / 2.0),
    );

    // This is where the `boxShadows` parameter is checked for being null
    // and set to `_kSliderBoxShadows` if this is found to be true.
    for (final BoxShadow shadow in boxShadows ?? _kSliderBoxShadows)
      canvas.drawRRect(rrect.shift(shadow.offset), shadow.toPaint());

    canvas.drawRRect(
      rrect.inflate(0.5),
      Paint()..color = _kThumbBorderColor,
    );

    canvas.drawRRect(rrect, Paint()..color = color);

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );
  }
}