import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';

class CompatibilityScale extends StatelessWidget {
  const CompatibilityScale({
    Key key,
    @required this.value,
    this.startValue = 0.0,
    this.endValue = 100.0,
    this.colorGradient,
  })  : assert(value >= 0.0 && value <= 100.0,
  'The "value" provided must be in the range (0.0, 100.0)\n Given: $value'),
        assert(endValue > startValue,
        'The "endValue" provided must be greater than the "startValue'),
        assert(endValue >= 0.0 && endValue <= 100.0,
        'The "endValue" provided must be in the range (0.0, 100.0)\n Given: $value'),
        assert(startValue >= 0.0 && startValue <= 100.0,
        'The "startValue" provided must be in the range (0.0, 100.0)\n Given: $value'),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PrecachedImage.asset(
            imageURI: BetaIconPaths.thermBorder,
            color: defaultShadowColor,
          ),
          ShaderMask(
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
            child: PrecachedImage.asset(
              imageURI: BetaIconPaths.thermBody,
            ),
          ),
        ],
      ),
    );
  }
}